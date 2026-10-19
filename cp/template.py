import math
import os
import sys
from bisect import bisect_left, bisect_right
from itertools import chain
from types import GeneratorType

input = sys.stdin.readline  # fast; lines keep their "\n", so strip() strings

DEBUG = "LOCAL" in os.environ


def dbg(*args):
    if DEBUG:
        print(f"[{sys._getframe(1).f_lineno}]", *args, file=sys.stderr)


# deep recursion: decorate with @bootstrap, write `yield f(x)` for recursive calls
# and `yield ret` instead of `return ret` (a bare `yield` when returning nothing)
def bootstrap(f, stack=[]):
    def wrapped(*args):
        if stack:
            return f(*args)
        to = f(*args)
        while True:
            if type(to) is GeneratorType:
                stack.append(to)
                to = next(to)
            else:
                stack.pop()
                if not stack:
                    return to
                to = stack[-1].send(to)

    return wrapped


# https://github.com/tatyam-prime/SortedSet
class SortedMultiset:
    BUCKET_RATIO = 16
    SPLIT_RATIO = 24

    def __init__(self, a=[]):
        a = sorted(a)
        n = self.size = len(a)
        num_bucket = math.ceil(math.sqrt(n / self.BUCKET_RATIO))
        self.a = [
            a[n * i // num_bucket : n * (i + 1) // num_bucket]
            for i in range(num_bucket)
        ]

    def __iter__(self):
        return chain.from_iterable(self.a)

    def __reversed__(self):
        return chain.from_iterable(map(reversed, reversed(self.a)))

    def __eq__(self, other):
        return list(self) == list(other)

    def __len__(self):
        return self.size

    def __repr__(self):
        return type(self).__name__ + str(self.a)

    def __str__(self):
        s = str(list(self))
        return "{" + s[1:-1] + "}"

    def _position(self, x):
        for i, a in enumerate(self.a):
            if x <= a[-1]:
                return (a, i, bisect_left(a, x))
        a = self.a[-1]
        return (a, len(self.a) - 1, len(a))

    def __contains__(self, x):
        if self.size == 0:
            return False
        a, _, i = self._position(x)
        return i != len(a) and a[i] == x

    def count(self, x):
        return self.index_right(x) - self.index(x)

    def _insert(self, a, b, i, x):
        a.insert(i, x)
        self.size += 1
        if len(a) > len(self.a) * self.SPLIT_RATIO:
            mid = len(a) >> 1
            self.a.insert(b + 1, a[mid:])
            del a[mid:]

    def add(self, x) -> bool:
        if self.size == 0:
            self.a = [[x]]
            self.size = 1
            return True
        a, b, i = self._position(x)
        self._insert(a, b, i, x)
        return True

    def _pop(self, a, b, i):
        ans = a.pop(i)
        self.size -= 1
        if not a:
            del self.a[b]
        return ans

    def discard(self, x):
        if self.size == 0:
            return False
        a, b, i = self._position(x)
        if i == len(a) or a[i] != x:
            return False
        self._pop(a, b, i)
        return True

    def lt(self, x):
        for a in reversed(self.a):
            if a[0] < x:
                return a[bisect_left(a, x) - 1]

    def le(self, x):
        for a in reversed(self.a):
            if a[0] <= x:
                return a[bisect_right(a, x) - 1]

    def gt(self, x):
        for a in self.a:
            if a[-1] > x:
                return a[bisect_right(a, x)]

    def ge(self, x):
        for a in self.a:
            if a[-1] >= x:
                return a[bisect_left(a, x)]

    def _locate(self, i):
        if i < 0:
            for b, a in enumerate(reversed(self.a)):
                i += len(a)
                if i >= 0:
                    return a, ~b, i
        else:
            for b, a in enumerate(self.a):
                if i < len(a):
                    return a, b, i
                i -= len(a)
        raise IndexError

    def __getitem__(self, i):
        a, _, i = self._locate(i)
        return a[i]

    def pop(self, i=-1):
        return self._pop(*self._locate(i))

    def index(self, x):  # number of elements < x
        ans = 0
        for a in self.a:
            if a[-1] >= x:
                return ans + bisect_left(a, x)
            ans += len(a)
        return ans

    def index_right(self, x):  # number of elements <= x
        ans = 0
        for a in self.a:
            if a[-1] > x:
                return ans + bisect_right(a, x)
            ans += len(a)
        return ans


class SortedSet(SortedMultiset):
    def __init__(self, a=[]):
        super().__init__(set(a))

    def add(self, x):  # returns False if x was already present
        if self.size == 0:
            return super().add(x)
        a, b, i = self._position(x)
        if i != len(a) and a[i] == x:
            return False
        self._insert(a, b, i, x)
        return True


def solve():
    pass


tests = 1
tests = int(input())  # delete when the input is one test
for _ in range(tests):
    solve()
