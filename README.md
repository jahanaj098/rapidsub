# RapidDNS Subdomain Enumerator

This is a Bash script for enumerating subdomains from [RapidDNS.io](https://rapiddns.io) with pagination handling. The script automatically removes duplicate subdomains, provides a simple loading spinner while fetching, and saves the results to a text file.

## Features
- Fetch subdomains from RapidDNS.io with pagination support.
- Removes duplicate subdomains automatically.
- Displays a loading spinner while subdomains are being fetched.
- Saves subdomains to a text file named `<domain>-rapid.txt`.

## Requirements
- Bash
- `curl` (installed by default on most Unix systems)
- `grep`, `sed`, `sort`

## How to Use

1. Clone the repository or download the script:
   ```bash
   git clone https://github.com/jahanaj098/rapiddns-subdomain-enumerator.git
   cd rapiddns-subdomain-enumerator
   chmod +x rapdisub.sh
   ./rapdisub.sh
