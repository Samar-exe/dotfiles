#!/bin/bash
#  _      __     ____                      
# | | /| / /__ _/ / /__  ___ ____  ___ ____
# | |/ |/ / _ `/ / / _ \/ _ `/ _ \/ -_) __/
# |__/|__/\_,_/_/_/ .__/\_,_/ .__/\__/_/   
#                /_/       /_/             
# -----------------------------------------------------
# Enhanced Wallpaper Script with Menu Selector
# -----------------------------------------------------

# -----------------------------------------------------
# Check to use wallpaper cache
# -----------------------------------------------------

if [ -f ~/.config/ml4w/settings/wallpaper_cache ]; then
    use_cache=1
    echo ":: Using Wallpaper Cache"
else
    use_cache=0
    echo ":: Wallpaper Cache disabled"
fi

# -----------------------------------------------------
# Set defaults
# -----------------------------------------------------

force_generate=0
generatedversions="$HOME/.config/ml4w/cache/wallpaper-generated"
waypaperrunning=$HOME/.config/ml4w/cache/waypaper-running
cachefile="$HOME/.config/ml4w/cache/current_wallpaper"
blurredwallpaper="$HOME/.config/ml4w/cache/blurred_wallpaper.png"
squarewallpaper="$HOME/.config/ml4w/cache/square_wallpaper.png"
rasifile="$HOME/.config/ml4w/cache/current_wallpaper.rasi"
blurfile="$HOME/.config/ml4w/settings/blur.sh"
defaultwallpaper="$HOME/wallpaper/default.jpg"
wallpapereffect="$HOME/.config/ml4w/settings/wallpaper-effect.sh"
currWal="$HOME/.config/ml4w/cache/currWal.thumb"
blur="50x30"
blur=$(cat $blurfile 2>/dev/null || echo "50x30")

# Menu selector variables
wall_dir="$HOME/Pictures/wallpaper/"
cacheDir="$HOME/.cache/wallcache"

# Ensures that the script only run once if wallpaper effect enabled
if [ -f $waypaperrunning ]; then
    rm $waypaperrunning
    exit
fi

# Create folder with generated versions of wallpaper if not exists
if [ ! -d $generatedversions ]; then
    mkdir $generatedversions
fi

# Create cache dir if not exists
[ -d "$cacheDir" ] || mkdir -p "$cacheDir"

# -----------------------------------------------------
# Menu Selector Functions
# -----------------------------------------------------

# Get focused monitor
get_monitor_info() {
    if command -v hyprctl &> /dev/null; then
        focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
        monitor_width=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .width')
        scale_factor=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .scale')
    else
        focused_monitor=""
        monitor_width=1920
        scale_factor=1
    fi
}

# Calculate icon size
calculate_icon_size() {
    if command -v bc &> /dev/null; then
        icon_size=$(echo "scale=2; ($monitor_width * 14) / ($scale_factor * 96)" | bc)
    else
        icon_size=14
    fi
    rofi_override="element-icon{size:${icon_size}px;}"
    rofi_command="rofi -i -show -dmenu -theme $HOME/.config/rofi/applets/wallSelect.rasi -theme-str $rofi_override"
}

# Detect number of cores and set a sensible number of jobs
get_optimal_jobs() {
    local cores=$(nproc)
    (( cores <= 2 )) && echo 2 || echo $(( (cores > 4) ? 4 : cores-1 ))
}

process_image() {
    local imagen="$1"
    local nombre_archivo=$(basename "$imagen")
    local cache_file="${cacheDir}/${nombre_archivo}"
    local md5_file="${cacheDir}/.${nombre_archivo}.md5"
    local lock_file="${cacheDir}/.lock_${nombre_archivo}"

    if command -v xxh64sum &> /dev/null; then
        local current_md5=$(xxh64sum "$imagen" | cut -d' ' -f1)
    else
        local current_md5=$(md5sum "$imagen" | cut -d' ' -f1)
    fi

    (
        flock -x 200
        if [ ! -f "$cache_file" ] || [ ! -f "$md5_file" ] || [ "$current_md5" != "$(cat "$md5_file" 2>/dev/null)" ]; then
            if command -v magick &> /dev/null; then
                magick "$imagen" -resize 500x500^ -gravity center -extent 500x500 "$cache_file"
            else
                cp "$imagen" "$cache_file"
            fi
            echo "$current_md5" > "$md5_file"
        fi
        # Clean the lock file after processing
        rm -f "$lock_file"
    ) 200>"$lock_file"
}

show_wallpaper_menu() {    
    get_monitor_info
    calculate_icon_size
    
    PARALLEL_JOBS=$(get_optimal_jobs)
    
    # Export variables & functions
    export -f process_image
    export wall_dir cacheDir
    
    # Clean old locks before starting
    rm -f "${cacheDir}"/.lock_* 2>/dev/null || true
    
    # Process files in parallel
    find "$wall_dir" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \) -print0 | \
        xargs -0 -P "$PARALLEL_JOBS" -I {} bash -c 'process_image "{}"'
    
    # Clean orphaned cache files and their locks
    for cached in "$cacheDir"/*; do
        [ -f "$cached" ] || continue
        original="${wall_dir}/$(basename "$cached")"
        if [ ! -f "$original" ]; then
            nombre_archivo=$(basename "$cached")
            rm -f "$cached" \
                "${cacheDir}/.${nombre_archivo}.md5" \
                "${cacheDir}/.lock_${nombre_archivo}"
        fi
    done
    
    # Clean any remaining lock files
    rm -f "${cacheDir}"/.lock_* 2>/dev/null || true
    
    # Check if rofi is already running
    if pidof rofi > /dev/null; then
      pkill rofi
    fi
    
    # Launch rofi
    if command -v rofi &> /dev/null; then
        wall_selection=$(find "${wall_dir}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) -print0 |
            xargs -0 basename -a |
            LC_ALL=C sort -V |
            while IFS= read -r A; do
                if [[ "$A" =~ \.gif$ ]]; then
                    printf "%s\n" "$A"  # Handle gifs by showing only file name
                else
                    printf '%s\x00icon\x1f%s/%s\n' "$A" "${cacheDir}" "$A"  # Non-gif files with icon convention
                fi
            done | $rofi_command)
        
        if [[ -n "$wall_selection" ]]; then
            echo "${wall_dir}/${wall_selection}"
        fi
    fi
}

# -----------------------------------------------------
# Get selected wallpaper
# -----------------------------------------------------

if [ -z $1 ]; then
    # Show menu if no argument provided
    if command -v rofi &> /dev/null && [ -d "$wall_dir" ]; then
        echo ":: Opening wallpaper selector menu..."
        selected_wallpaper=$(show_wallpaper_menu)
        if [ -n "$selected_wallpaper" ]; then
            wallpaper="$selected_wallpaper"
        elif [ -f $cachefile ]; then
            wallpaper=$(cat $cachefile)
        else
            wallpaper=$defaultwallpaper
        fi
    else
        # Fall back to cached or default wallpaper if rofi not available or wall_dir doesn't exist
        if [ -f $cachefile ]; then
            wallpaper=$(cat $cachefile)
        else
            wallpaper=$defaultwallpaper
        fi
    fi
else
    wallpaper=$1
fi

used_wallpaper=$wallpaper
echo ":: Setting wallpaper with source image $wallpaper"
tmpwallpaper=$wallpaper

# -----------------------------------------------------
# Copy path of current wallpaper to cache file
# -----------------------------------------------------

if [ ! -f $cachefile ]; then
    touch $cachefile
fi
echo "$wallpaper" >$cachefile
echo ":: Path of current wallpaper copied to $cachefile"

# -----------------------------------------------------
# Get wallpaper filename
# -----------------------------------------------------
if [ -n "$wallpaper" ] && [ -f "$wallpaper" ]; then
    wallpaperfilename=$(basename "$wallpaper")
    echo ":: Wallpaper Filename: $wallpaperfilename"
else
    echo ":: Error: Wallpaper file not found or invalid: $wallpaper"
    exit 1
fi

# -----------------------------------------------------
# Wallpaper Effects
# -----------------------------------------------------

if [ -f $wallpapereffect ]; then
    effect=$(cat $wallpapereffect)
    if [ ! "$effect" == "off" ]; then
        used_wallpaper=$generatedversions/$effect-$wallpaperfilename
        if [ -f $generatedversions/$effect-$wallpaperfilename ] && [ "$force_generate" == "0" ] && [ "$use_cache" == "1" ]; then
            echo ":: Use cached wallpaper $effect-$wallpaperfilename"
        else
            echo ":: Generate new cached wallpaper $effect-$wallpaperfilename with effect $effect"
            notify-send --replace-id=1 "Using wallpaper effect $effect..." "with image $wallpaperfilename" -h int:value:33
            source $HOME/.config/hypr/effects/wallpaper/$effect
        fi
        echo ":: Loading wallpaper $generatedversions/$effect-$wallpaperfilename with effect $effect"
    else
        echo ":: Wallpaper effect is set to off"
    fi
else
    effect="off"
fi

# -----------------------------------------------------
# Set Wallpaper
# -----------------------------------------------------

echo ":: Setting wallpaper with $used_wallpaper"
touch $waypaperrunning

# Try different wallpaper setters in order of preference
if command -v waypaper >/dev/null 2>&1; then
    echo ":: Using waypaper to set wallpaper"
    waypaper --wallpaper "$used_wallpaper"
elif command -v swww >/dev/null 2>&1; then
    echo ":: Using swww to set wallpaper"
    # Initialize swww if not running
    swww query || swww-daemon --format xrgb
    swww img "$used_wallpaper" --transition-fps 60 --transition-type any --transition-duration 2
elif command -v hyprpaper >/dev/null 2>&1; then
    echo ":: Using hyprpaper to set wallpaper"
    hyprctl hyprpaper preload "$used_wallpaper"
    hyprctl hyprpaper wallpaper ",$used_wallpaper"
else
    echo ":: Warning: No wallpaper setter found (waypaper, swww, or hyprpaper)"
fi

# -----------------------------------------------------
# Execute matugen
# -----------------------------------------------------

echo ":: Execute matugen with $used_wallpaper"
if [ -f "$HOME/.cargo/bin/matugen" ] && [ -f "$used_wallpaper" ]; then
    $HOME/.cargo/bin/matugen image "$used_wallpaper" -m "dark"
fi

# -----------------------------------------------------
# Execute wallust
# -----------------------------------------------------

echo ":: Execute wallust with $used_wallpaper"
if [ -f "$HOME/.cargo/bin/wallust" ] && [ -f "$used_wallpaper" ]; then
    $HOME/.cargo/bin/wallust run "$used_wallpaper"
fi

# -----------------------------------------------------
# Walcord (NOT SUPPORTED)
# -----------------------------------------------------

if type walcord >/dev/null 2>&1; then
    walcord
fi

# -----------------------------------------------------
# Reload Waybar
# -----------------------------------------------------

sleep 2
if [ -f "$HOME/.config/waybar/launch.sh" ]; then
    $HOME/.config/waybar/launch.sh
fi
# killall -SIGUSR2 waybar

# -----------------------------------------------------
# Reload nwg-dock-hyprland
# -----------------------------------------------------

if [ -f "$HOME/.config/nwg-dock-hyprland/launch.sh" ]; then
    $HOME/.config/nwg-dock-hyprland/launch.sh &
fi

# -----------------------------------------------------
# Update Pywalfox
# -----------------------------------------------------

if type pywalfox >/dev/null 2>&1; then
    pywalfox update
fi

# -----------------------------------------------------
# Update SwayNC
# -----------------------------------------------------
sleep 0.1
if command -v swaync-client &> /dev/null; then
    swaync-client -rs
fi

# -----------------------------------------------------
# Created blurred wallpaper
# -----------------------------------------------------

if [ -f $generatedversions/blur-$blur-$effect-$wallpaperfilename.png ] && [ "$force_generate" == "0" ] && [ "$use_cache" == "1" ]; then
    echo ":: Use cached wallpaper blur-$blur-$effect-$wallpaperfilename"
else
    echo ":: Generate new cached wallpaper blur-$blur-$effect-$wallpaperfilename with blur $blur"
    # notify-send --replace-id=1 "Generate new blurred version" "with blur $blur" -h int:value:66
    if command -v magick &> /dev/null && [ -f "$used_wallpaper" ]; then
        magick "$used_wallpaper" -resize 75% "$blurredwallpaper"
        echo ":: Resized to 75%"
        if [ ! "$blur" == "0x0" ]; then
            magick "$blurredwallpaper" -blur $blur "$blurredwallpaper"
            cp "$blurredwallpaper" "$generatedversions/blur-$blur-$effect-$wallpaperfilename.png"
            echo ":: Blurred"
        fi
    fi
fi
if [ -f "$generatedversions/blur-$blur-$effect-$wallpaperfilename.png" ]; then
    cp $generatedversions/blur-$blur-$effect-$wallpaperfilename.png $blurredwallpaper
fi

# -----------------------------------------------------
# Create rasi file
# -----------------------------------------------------

if [ ! -f $rasifile ]; then
    touch $rasifile
fi
echo "* { current-image: url(\"$blurredwallpaper\", height); }" >"$rasifile"

# -----------------------------------------------------
# Created square wallpaper
# -----------------------------------------------------

echo ":: Generate new cached wallpaper square-$wallpaperfilename"
if command -v magick &> /dev/null && [ -f "$tmpwallpaper" ]; then
    magick "$tmpwallpaper" -gravity Center -extent 1:1 "$squarewallpaper"
    cp "$squarewallpaper" "$generatedversions/square-$wallpaperfilename.png"
fi
if [ -f "$wallpaper" ]; then
    cp "$wallpaper" "$currWal"
fi
