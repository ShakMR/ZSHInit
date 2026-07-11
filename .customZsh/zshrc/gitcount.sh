#!/bin/bash

# This script defines a function to calculate git commits from a CSV.
# It is intended to be sourced (e.g., in .zshrc or .bashrc).
#
# To use:
# 1. Add 'source /path/to/commit_counter.sh' to your .zshrc
# 2. Restart your shell or run 'source ~/.zshrc'
# 3. You can now run the function:
#    git_commit_count_csv <input.csv>
#
git_commit_count_yoy() {
    # --- Validation ---
    if [ "$#" -ne 1 ]; then
        echo "Usage: git_commit_count_yoy <input_file>"
        echo "Description: Reads a file with author emails, one per line."
        echo "Input file format: author.email@example.com or regex"
        return 1
    fi

    local INPUT_FILE=$1

    if [ ! -r "$INPUT_FILE" ]; then
        echo "Error: File not found or is not readable: $INPUT_FILE"
        return 2
    fi

    # --- Date Calculation ---
    local current_year=$(date +%Y)
    local previous_year=$((current_year - 1))
    
    local previous_year_start_date="$previous_year-01-01"
    local previous_year_end_date="$previous_year-12-31"
    local current_year_start_date="$current_year-01-01"
    local current_year_end_date="$current_year-12-31"

    # --- Processing ---
    echo "Processing commit counts from file: $INPUT_FILE"
    echo "Comparing years: $previous_year vs $current_year"
    echo "--------------------------------------------------------------------------------"

    local author_raw author
    local count_prev_year count_curr_year
    local total_prev_year=0
    local total_curr_year=0

    # Read the file line by line
    while IFS= read -r author_raw; do
        author=$(echo "$author_raw" | xargs)

        if [[ -z "$author" ]]; then
            echo "Skipping empty line..."
            continue
        fi

        count_prev_year=$(git log --author="$author" --since="$previous_year_start_date" --until="$previous_year_end_date" --pretty=oneline | wc -l | xargs)
        count_curr_year=$(git log --author="$author" --since="$current_year_start_date" --until="$current_year_end_date" --pretty=oneline | wc -l | xargs)

        local yoy_change="N/A"
        if [ "$count_prev_year" -ne 0 ]; then
            yoy_change=$(awk "BEGIN {printf \"%.2f%%\", ($count_curr_year - $count_prev_year) / $count_prev_year * 100}")
        elif [ "$count_curr_year" -gt 0 ]; then
            yoy_change="INF"
        fi

        printf "Author: %-30s | %s: %-5s | %s: %-5s | YoY Change: %s\n" "$author" "$previous_year" "$count_prev_year" "$current_year" "$count_curr_year" "$yoy_change"

        total_prev_year=$((total_prev_year + count_prev_year))
        total_curr_year=$((total_curr_year + count_curr_year))
    done < "$INPUT_FILE"

    echo "--------------------------------------------------------------------------------"
    echo "Calculation complete."
    
    local total_yoy_change="N/A"
    if [ "$total_prev_year" -ne 0 ]; then
        total_yoy_change=$(awk "BEGIN {printf \"%.2f%%\", ($total_curr_year - $total_prev_year) / $total_prev_year * 100}")
    elif [ "$total_curr_year" -gt 0 ]; then
        total_yoy_change="INF"
    fi

    printf "Total %s: %-5s\n" "$previous_year" "$total_prev_year"
    printf "Total %s: %-5s\n" "$current_year" "$total_curr_year"
    printf "Total YoY Change: %s\n" "$total_yoy_change"
}

