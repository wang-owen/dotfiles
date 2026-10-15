// dbg(a, b) prints "[line] a, b = ..., ..." to stderr. Only local builds
// include this (they define LOCAL); on the judge dbg() compiles to nothing.
#pragma once
#include <bits/stdc++.h>
using namespace std;

template <class T> void dbg_show(const T &x) {
  if constexpr (is_same_v<T, char>) {
    cerr << '\'' << x << '\'';
  } else if constexpr (is_convertible_v<const T &, string_view>) {
    cerr << '"' << string_view(x) << '"';
  } else if constexpr (requires { typename T::container_type; }) {
    struct Open : T { // stack, queue, priority_queue: show what is inside
      using T::c;
    };
    dbg_show(Open{x}.c);
  } else if constexpr (requires { begin(x), end(x); }) {
    cerr << '[';
    const char *sep = "";
    for (const auto &e : x)
      cerr << sep, dbg_show(e), sep = ", ";
    cerr << ']';
  } else if constexpr (requires { tuple_size<T>::value; }) {
    cerr << '(';
    apply(
        [](const auto &...e) {
          const char *sep = "";
          ((cerr << exchange(sep, ", "), dbg_show(e)), ...);
        },
        x);
    cerr << ')';
  } else {
    cerr << x;
  }
}
template <class... T>
void dbg_out(int line, const char *names, const T &...values) {
  cerr << boolalpha << '[' << line << "] " << names << " = ";
  const char *sep = "";
  ((cerr << exchange(sep, ", "), dbg_show(values)), ...);
  cerr << endl;
}
#define dbg(...) dbg_out(__LINE__, #__VA_ARGS__ __VA_OPT__(, ) __VA_ARGS__)
