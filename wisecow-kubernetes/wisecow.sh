#!/bin/sh
echo "Wisdom served on port=4499..."
fortune | cowsay > /tmp/output.txt
python3 -m http.server 4499 --bind 0.0.0.0
