#!/data/data/com.termux/files/usr/bin/python

from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import subprocess

PORT = 9100
METRICS_SCRIPT = "/data/data/com.termux/files/home/monitor/adb/metrics.sh"

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        try:
            output = subprocess.check_output(
                ["bash", METRICS_SCRIPT],
                stderr=subprocess.STDOUT,
                timeout=3  # hard safety net
            )

            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Cache-Control", "no-store")
            self.send_header("Content-Length", str(len(output)))
            self.end_headers()
            self.wfile.write(output)

        except subprocess.TimeoutExpired:
            self.send_response(504)
            self.end_headers()
            self.wfile.write(b'{"error":"metrics timeout"}')

        except Exception as e:
            self.send_response(500)
            self.end_headers()
            self.wfile.write(str(e).encode())

    def log_message(self, format, *args):
        return  # silence logs

if __name__ == "__main__":
    server = ThreadingHTTPServer(("", PORT), Handler)
    server.serve_forever()
