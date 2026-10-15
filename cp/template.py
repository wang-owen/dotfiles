import os
import sys

input = sys.stdin.readline  # fast; lines keep their "\n", so strip() strings

DEBUG = "LOCAL" in os.environ


def dbg(*args):
    if DEBUG:
        print(f"[{sys._getframe(1).f_lineno}]", *args, file=sys.stderr)


def solve():
    pass


tests = 1
tests = int(input())  # delete when the input is one test
for _ in range(tests):
    solve()
