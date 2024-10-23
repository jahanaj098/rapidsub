#!/bin/bash

# Function to show loading spinner
show_loading() {
    pid=$1
    delay=0.1
    spinner=( '|' '/' '-' '\' )

    while [ -d /proc/$pid ]; do
        for symbol in "${spinner[@]}"; do
            echo -ne "\rFetching subdomains... $symbol"
            sleep $delay
        done
    done
    echo -ne "\rFetching subdomains... Done!\n"
}

# Function to fetch subdomains
fetch_subdomains() {
    domain=$1
    subdomains_per_page=100
    output_file="$domain-rapid.txt"
    
    # Fetch the first page to get the total number of subdomains
    response=$(curl -s "https://rapiddns.io/subdomain/$domain")
    total_subdomains=$(echo "$response" | grep -oP '(?<=<span style="color: #39cfca; ">)[0-9,]+(?=</span>)' | sed 's/,//g')

    # Check if total subdomains were extracted
    if [[ -z "$total_subdomains" ]]; then
        echo "Could not determine the total number of subdomains from RapidDNS."
        exit 1
    fi

    # Calculate the total number of pages
    total_pages=$(( (total_subdomains + subdomains_per_page - 1) / subdomains_per_page ))

    # Create or empty the output file
    > "$output_file"

    # Loop through each page and fetch subdomains
    for (( page=1; page<=total_pages; page++ )); do
        curl -s "https://rapiddns.io/subdomain/$domain?page=$page" | \
        grep -oP '(?<=<td>)[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' >> "$output_file"
    done

    # Trim leading/trailing whitespaces and remove duplicates
    sed -i 's/^[ \t]*//;s/[ \t]*$//' "$output_file"   # Trim leading/trailing spaces
    sort -u "$output_file" -o "$output_file"          # Sort and remove duplicates
}

# Prompt for domain input
read -p "Enter domain: " domain

# Validate if the domain is non-empty
if [[ -n "$domain" ]]; then
    # Fetch subdomains in background and show loading animation
    fetch_subdomains "$domain" &
    fetch_pid=$!
    show_loading $fetch_pid
else
    echo "Invalid domain entered."
    exit 1
fi

echo "Subdomains saved to $domain-rapid.txt"

