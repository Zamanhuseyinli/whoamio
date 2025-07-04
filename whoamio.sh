#!/bin/sh

MODE=""
ARG_VALUE=""
SEARCH_PATH="/"
USE_REGEX=0
LIMIT=30
ROUGER_MODE=0
SHOW_SUMMARY=0
SHOW_HISTOGRAM=0
IMAGE_MODE=0
SHOW_HELP=0

GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)
MAGENTA=$(tput setaf 5)
RESET=$(tput sgr0)
GRAY=$(tput setaf 8)
BRBLACK=$(tput setaf 8)

while [ "$1" != "" ]; do
    case $1 in
        --files) MODE="files" ;;
        --dir) MODE="dir" ;;
        --iostat) MODE="iostat" ;;
        --PID) MODE="pid" ;;
        --argument-find)
            shift
            if [ -z "$1" ] || [[ "$1" == --* ]]; then
                echo "Error: --argument-find requires an argument." >&2
                exit 1
            fi
            ARG_VALUE="$1"
            ;;
        --path)
            shift
            if [ -z "$1" ] || [[ "$1" == --* ]]; then
                echo "Error: --path requires an argument." >&2
                exit 1
            fi
            SEARCH_PATH="$1"
            ;;
        --regex) USE_REGEX=1 ;;
        --limit)
            shift
            if [ -z "$1" ] || [[ "$1" == --* ]]; then
                echo "Error: --limit requires an argument." >&2
                exit 1
            fi
            LIMIT="$1"
            ;;
        --rouger) ROUGER_MODE=1 ;;
        --summary) SHOW_SUMMARY=1 ;;
        --histogram) SHOW_HISTOGRAM=1 ;;
        --image-mode) IMAGE_MODE=1 ;;
        --help) SHOW_HELP=1 ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
    shift
done

check_proc_io_access() {
    for PID in $(ls /proc | grep -E '^[0-9]+$'); do
        IOFILE="/proc/$PID/io"
        if [ -f "$IOFILE" ]; then
            if [ ! -r "$IOFILE" ]; then
                echo "${YELLOW}Not root access permission! Cannot read $IOFILE${RESET}" >&2
                return 1
            fi
        fi
    done
    return 0
}

rouger_sayings() {
    echo "$MAGENTA"
    cat <<EOF
👽 Rouger: You humans think IO is simple? Ha! I’ve got like a dozen personalities arguing over disk reads!
👽 Rouger: Don’t even try to touch my /proc/io or I’ll abduct your boring processes!
👽 Rouger: Earth IO is so slow... back in my galaxy we stream thoughts directly to devices!
👽 Rouger: I don’t listen to your family, nor your commands, just like your kernel ignoring interrupts.
👽 Rouger: Sometimes I wanna explode like a misbehaving IO scheduler... but then I just float in space instead.
👽 Rouger: You want help? Ha! I’m too busy juggling my inner chaos — with 17 personalities screaming at once.
EOF
    echo "$RESET"
}

rouger_help() {
    echo "${MAGENTA}🔧 whoamio - IO agent shell tool (Rouger Edition)${RESET}"
    echo "Usage: whoamio [mode] [options]"
    echo
    echo "Modes:"
    echo "  --files             Search for files containing 'io' (but what are files anyway? Humans...)"
    echo "  --dir               Search for directories containing 'io' (path? Bah, just space!)"
    echo "  --PID               Find running processes with 'io' in command (Why do you care? I don't.)"
    echo "  --iostat            Print limited /proc/[pid]/io entries (With chaos, confusion, and Rouger comments)"
    echo
    echo "Options:"
    echo "  --argument-find <s>   Additional filter? Fine, but my personalities won't care."
    echo "  --regex               Use regex instead of glob match (regex? Sounds like alien code.)"
    echo "  --path <dir>          Set search directory (default: /, but why?)"
    echo "  --limit <n>           Limit results (default: 30, because I say so)"
    echo "  --summary             Show IO file counts summary (Summary? I prefer chaos.)"
    echo "  --histogram           Show fake histogram (Pixels? Meh.)"
    echo "  --image-mode          Show fake IO device icons (Aliens have better tech.)"
    echo "  --rouger              Speak like Rouger from space (You better believe it.)"
    echo "  --help                Show this cosmic help message"
    echo
    echo "Default: If no arguments are given, all /proc/[pid]/io will be listed via less — boring for me."
}

histogram() {
    echo "${CYAN}📊 Histogram (Fake IO Read Sizes)${RESET}"
    i=1
    while [ $i -le 10 ]; do
        size=$(( RANDOM % 50 ))
        printf "IO[%02d]: " "$i"
        j=0
        while [ $j -lt $size ]; do
            printf "#"
            j=$((j+1))
        done
        echo
        i=$((i+1))
    done
}

image_mode() {
    echo "📸 Fake IO devices:"
    echo "💾 /dev/io0   - QuantumDrive"
    echo "🔌 /dev/io1   - PlasmaConnector"
    echo "📡 /dev/io2   - CosmicInterface"
}

limit_output() {
    head -n "$LIMIT"
}

if [ "$SHOW_HELP" = "1" ]; then
    if [ "$ROUGER_MODE" -eq 1 ]; then
        rouger_help
    else
        show_help() {
            echo "${YELLOW}🔧 whoamio - IO agent shell tool${RESET}"
            echo "Usage: whoamio [mode] [options]"
            echo
            echo "Modes:"
            echo "  --files             Search for files containing 'io'"
            echo "  --dir               Search for directories containing 'io'"
            echo "  --PID               Search running processes with 'io' in command"
            echo "  --iostat            Print limited /proc/[pid]/io entries"
            echo
            echo "Options:"
            echo "  --argument-find <s>   Additional filter for name/content"
            echo "  --regex               Use regex instead of glob match"
            echo "  --path <dir>          Set search directory (default: /)"
            echo "  --limit <n>           Limit results (default: 30)"
            echo "  --summary             Show IO file counts summary"
            echo "  --histogram           Show fake histogram"
            echo "  --image-mode          Show fake IO device icons"
            echo "  --rouger              Speak like Rouger from space"
            echo "  --help                Show this help message"
            echo
            echo "Default: If no arguments are given, all /proc/[pid]/io will be listed via less."
        }
        show_help
    fi
    exit 0
fi

if [ "$ROUGER_MODE" -eq 1 ] && [ -z "$MODE" ]; then
    rouger_sayings
    exit 0
fi

if [ -z "$MODE" ]; then
    if ! check_proc_io_access; then exit 1; fi
    TMPFILE=$(mktemp)
    for PID in $(ls /proc | grep -E '^[0-9]+$'); do
        IOFILE="/proc/$PID/io"
        if [ -f "$IOFILE" ]; then
            echo "${GREEN}📦 PID $PID${RESET}" >> "$TMPFILE"
            sed 's/^/  /' "$IOFILE" >> "$TMPFILE"
            echo "${GRAY}---${RESET}" >> "$TMPFILE"
        fi
    done
    less -R "$TMPFILE"
    rm -f "$TMPFILE"
    exit 0
fi

case "$MODE" in
    files)
        echo "${GREEN}📁 Searching files in $SEARCH_PATH with 'io' and '$ARG_VALUE'${RESET}"
        if [ "$USE_REGEX" = "1" ]; then
            find "$SEARCH_PATH" -type f 2>/dev/null | grep -Ei "io.*$ARG_VALUE" | limit_output
        else
            find "$SEARCH_PATH" -type f -iname "*io*$ARG_VALUE*" 2>/dev/null | limit_output
        fi
        ;;
    dir)
        echo "${GREEN}📂 Searching directories in $SEARCH_PATH with 'io' and '$ARG_VALUE'${RESET}"
        if [ "$USE_REGEX" = "1" ]; then
            find "$SEARCH_PATH" -type d 2>/dev/null | grep -Ei "io.*$ARG_VALUE" | limit_output
        else
            find "$SEARCH_PATH" -type d -iname "*io*$ARG_VALUE*" 2>/dev/null | limit_output
        fi
        ;;
    iostat)
        if ! check_proc_io_access; then exit 1; fi
        if [ "$ROUGER_MODE" -eq 1 ]; then
            # Rouger tarzı iostat
            echo "${MAGENTA}👽 Rouger's chaotic IO stats incoming!${RESET}"
            for PID in $(ls /proc | grep -E '^[0-9]+$'); do
                IOFILE="/proc/$PID/io"
                if [ -f "$IOFILE" ]; then
                    echo "${MAGENTA}👽 PID $PID (Don't trust this process)${RESET}"
                    head -n 3 "$IOFILE" | sed 's/^/👽  /'
                    echo "👽 ---"
                fi
            done
            rouger_sayings
        else
            echo "${CYAN}📊 Listing IO stat files from /proc/[pid]/io...${RESET}"
            for PID in $(ls /proc | grep -E '^[0-9]+$'); do
                IOFILE="/proc/$PID/io"
                if [ -f "$IOFILE" ]; then
                    echo "${YELLOW}PID $PID:${RESET}"
                    head -n 5 "$IOFILE"
                    echo "---"
                fi
            done
        fi
        ;;
    pid)
        echo "${MAGENTA}🔍 Searching processes with 'io' and '$ARG_VALUE' in cmdline${RESET}"
        for PID in $(ls /proc | grep -E '^[0-9]+$'); do
            if [ -r "/proc/$PID/cmdline" ]; then
                CMDLINE=$(tr '\0' ' ' < "/proc/$PID/cmdline")
                if [ "$USE_REGEX" = "1" ]; then
                    echo "$CMDLINE" | grep -Eq "io.*$ARG_VALUE" && echo "PID $PID: $CMDLINE"
                else
                    echo "$CMDLINE" | grep -iq "io.*$ARG_VALUE" && echo "PID $PID: $CMDLINE"
                fi
            fi
        done
        ;;
esac

if [ "$ROUGER_MODE" -eq 1 ] && [ "$MODE" != "iostat" ]; then
    rouger_sayings
fi

if [ "$SHOW_SUMMARY" -eq 1 ]; then
    echo "${CYAN}📊 Summary:${RESET}"
    echo "  🧠 IO stat entries found: $(find /proc -type f -name "io" 2>/dev/null | wc -l)"
    echo "  📁 Files with io: $(find / -type f -iname '*io*' 2>/dev/null | head -n 100 | wc -l)"
fi

if [ "$SHOW_HISTOGRAM" -eq 1 ]; then
    histogram
fi

if [ "$IMAGE_MODE" -eq 1 ]; then
    image_mode
fi
