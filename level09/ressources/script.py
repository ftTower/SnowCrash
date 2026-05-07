#!/usr/bin/env python
import sys

buf = sys.stdin.buffer.read()
buf = buf.strip(b'\n')

for i, b in enumerate(buf):
    b = b - i
    if b < 0:
        b = 255 + b
    sys.stdout.buffer.write(b.to_bytes())
print()