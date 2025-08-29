1. Install Termux and allow storage:
   termux-setup-storage

2. Install Python and necessary packages:
   pkg update && pkg upgrade -y
   pkg install python git curl -y
   pip install flask requests

3. Copy the MyBotProject folder to /storage/emulated/0/

4. Navigate to the project folder:
   cd /storage/emulated/0/MyBotProject

5. Run the server:
   python main.py

6. On your Lua client (Roblox or other):
   - Replace `server_ip` with your phone’s IP (ifconfig -> wlan0 inet)
   - Replace the `key` with a valid key from keys.json

7. Push Lua scripts to your GitHub repo (MyBotRepo).
   - Any updates there will be fetched automatically by clients.

8. Optional: Add more keys in keys.json as needed.
