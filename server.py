from http.server import BaseHTTPRequestHandler, HTTPServer
import subprocess

PORT = 9100
METRICS_SCRIPT = "/data/data/com.termux/files/home/monitor/adb/metrics.sh"

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        output = subprocess.check_output([METRICS_SCRIPT])
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Cache-Control", "no-cache")
        self.end_headers()
        self.wfile.write(output)

    def log_message(self, format, *args):
        return  # silence logs

if __name__ == "__main__":
    HTTPServer(("", PORT), Handler).serve_forever()
