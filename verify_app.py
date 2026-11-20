import subprocess
import sys
import time
import urllib.request
import json

server = subprocess.Popen(
    [sys.executable, "deploy/app.py"],
    stdout=subprocess.DEVNULL,
    stderr=subprocess.DEVNULL
)

try:
    for attempt in range(15):
        try:
            with urllib.request.urlopen("http://127.0.0.1:5000/", timeout=2) as response:
                data = json.loads(response.read().decode())

                if response.status == 200 and data.get("status") == "success":
                    print("Application verification successful!")
                    print(data.get("message"))
                    break
        except Exception:
            if server.poll() is not None:
                raise RuntimeError("Flask server stopped unexpectedly")
            time.sleep(2)
    else:
        raise RuntimeError("Application verification failed!")

finally:
    server.terminate()
    try:
        server.wait(timeout=5)
    except subprocess.TimeoutExpired:
        server.kill()
