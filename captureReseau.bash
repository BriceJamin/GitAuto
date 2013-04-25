 tshark -i wlan0 -w /tmp/capture
 tshark -r /tmp/capture -R "wol"

