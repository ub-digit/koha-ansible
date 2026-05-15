#!/usr/bin/env python3
import sys
import json
import subprocess
import datetime
import signal
import os
import threading

process_name = sys.argv[1]
cmd = sys.argv[2:]

# Start process
p = subprocess.Popen(
    cmd,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    text=True,
    bufsize=1,
    start_new_session=True
)

def emit(stream, line):
    event = {
        "@timestamp": datetime.datetime.utcnow().isoformat() + "Z",
        "message": line.rstrip("\n"),
        "service.name": process_name,
        "log.logger": stream,
    }

    #TODO: Dot or nested?

    if stream == "stderr":
        event["log.level"] = "error"
    else:
        event["log.level"] = "info"

    sys.stdout.write(json.dumps(event) + "\n")
    sys.stdout.flush()

def reader(pipe, stream_name):
    try:
        for line in iter(pipe.readline, ''):
            emit(stream_name, line)
    finally:
        pipe.close()

def forward_signal(sig, frame):
    try:
        os.killpg(p.pid, sig)
    except ProcessLookupError:
        pass

signal.signal(signal.SIGTERM, forward_signal)
signal.signal(signal.SIGINT, forward_signal)
signal.signal(signal.SIGHUP, forward_signal)

# Stream both outputs concurrently

t1 = threading.Thread(target=reader, args=(p.stdout, "stdout"))
t2 = threading.Thread(target=reader, args=(p.stderr, "stderr"))

t1.start()
t2.start()

exit_code = p.wait()

t1.join()
t2.join()

sys.exit(exit_code)
