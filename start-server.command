#!/bin/bash
cd "$(dirname "$0")"
PORT=8765
IP=$(ipconfig getifaddr en0 2>/dev/null)
if [ -z "$IP" ]; then IP=$(ipconfig getifaddr en1 2>/dev/null); fi
if [ -z "$IP" ]; then IP="YOUR-MAC-IP"; fi

echo ""
echo "  Focus Flow is running!"
echo ""
echo "  On your iPhone, open Safari and go to:"
echo ""
echo "    http://$IP:$PORT"
echo ""
echo "  Then: Share → Add to Home Screen"
echo ""
echo "  (Keep this window open while using the app on your phone.)"
echo ""

python3 -m http.server "$PORT"
