"""
Simple HTTP server to serve dashboard.html + state.json
Run this BEFORE launching main.exe
"""
import http.server, socketserver, os, sys

PORT = 8080
os.chdir(os.path.dirname(os.path.abspath(__file__)))

class Handler(http.server.SimpleHTTPRequestHandler):
    def log_message(self, format, *args): pass  # suppress noisy logs
    def end_headers(self):
        # Allow fetch() from same origin; no CORS issues
        self.send_header('Cache-Control', 'no-cache, no-store')
        self.send_header('Access-Control-Allow-Origin', '*')
        super().end_headers()

# Try PORT, fall back to PORT+1 if busy
for port in [PORT, PORT + 1, PORT + 2]:
    try:
        with socketserver.TCPServer(("", port), Handler) as httpd:
            print(f"  Dashboard: http://localhost:{port}/dashboard.html")
            print(f"  Serving from: {os.getcwd()}")
            print(f"  Now run main.exe in another terminal to connect.\n")
            httpd.serve_forever()
    except OSError as e:
        if "address already in use" in str(e).lower() or "10048" in str(e):
            print(f"  Port {port} busy, trying {port + 1}...")
            continue
        raise
else:
    print(f"  ERROR: Ports {PORT}-{PORT+2} all busy. Close other servers and retry.")
    sys.exit(1)
