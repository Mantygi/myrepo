#!/bin/bash

# ===== Configuration =====
AUTH_LOG="/var/log/auth.log"
NGINX_LOG="/var/log/nginx/access.log"
APACHE_LOG="/var/log/apache2/access.log"
REPORT="log_report_$(date +%F).txt"

echo "Generating Log Report..."
echo "=================================" > $REPORT
echo "Log Report - $(date)" >> $REPORT
echo "=================================" >> $REPORT
echo "" >> $REPORT

# ===== Failed SSH Attempts =====
echo "1️⃣ Failed SSH Login Attempts:" >> $REPORT
if [ -f "$AUTH_LOG" ]; then
    grep "Failed password" $AUTH_LOG | wc -l >> $REPORT
else
    echo "Auth log not found." >> $REPORT
fi
echo "" >> $REPORT

# ===== Top IPs with Failed SSH =====
echo "2️⃣ Top 5 IPs with Failed SSH Attempts:" >> $REPORT
if [ -f "$AUTH_LOG" ]; then
    grep "Failed password" $AUTH_LOG | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | head -5 >> $REPORT
else
    echo "Auth log not found." >> $REPORT
fi
echo "" >> $REPORT

# ===== 404 Errors (Nginx or Apache) =====
echo "3️⃣ 404 Errors:" >> $REPORT

if [ -f "$NGINX_LOG" ]; then
    grep ' 404 ' $NGINX_LOG | wc -l >> $REPORT
elif [ -f "$APACHE_LOG" ]; then
    grep ' 404 ' $APACHE_LOG | wc -l >> $REPORT
else
    echo "No web server logs found." >> $REPORT
fi

echo "" >> $REPORT
echo "Report saved as $REPORT"