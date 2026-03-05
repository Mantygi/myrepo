#!/bin/bash

# Check if username is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

USERNAME=$1

# Check if user exists
if ! id "$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' does not exist."
    exit 1
fi

echo "=============================="
echo "User Full Details Report"
echo "=============================="
echo ""

echo "1. Basic User Information:"
id "$USERNAME"
echo ""

echo "2. User Entry from /etc/passwd:"
getent passwd "$USERNAME"
echo ""

echo "3. Group Information:"
groups "$USERNAME"
echo ""

echo "4. Home Directory:"
HOME_DIR=$(getent passwd "$USERNAME" | cut -d: -f6)
echo "$HOME_DIR"
echo ""

echo "5. Default Shell:"
SHELL=$(getent passwd "$USERNAME" | cut -d: -f7)
echo "$SHELL"
echo ""

echo "6. Last Login:"
lastlog -u "$USERNAME"
echo ""

echo "7. Password Status:"
sudo chage -l "$USERNAME" 2>/dev/null || echo "Run as root to see password aging info"
echo ""

echo "8. Running Processes:"
ps -u "$USERNAME"
echo ""

echo "9. Home Directory Disk Usage:"
du -sh "$HOME_DIR" 2>/dev/null
echo ""

echo "========== END OF REPORT =========="