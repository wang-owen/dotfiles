// dbg(a, b) prints "[line] a, b = ..., ..." to stderr. Only local builds
// include this (they define LOCAL); on the judge dbg() compiles to nothing.
#pragma once
#include <bits/stdc++.h>
using namespace std;

// cerr is unbuffered, so build each line here and write it once
inline ostringstream dbg_os;

template <class T> void dbg_show(const T &x);
void dbg_list(const auto &...xs) {
  const char *sep = "";
  ((dbg_os << exchange(sep, ", "), dbg_show(xs)), ...);
}
template <class T> void dbg_show(const T &x) {
  if constexpr (is_same_v<T, char>) {
    dbg_os << '\'' << x << '\'';
  } else if constexpr (is_convertible_v<const T &, string_view>) {
    dbg_os << '"' << string_view(x) << '"';
  } else if constexpr (requires { typename T::container_type; }) {
    struct Open : T { // stack, queue, priority_queue: show what is inside
      using T::c;
    };
    dbg_show(Open{x}.c);
  } else if constexpr (requires { begin(x), end(x); }) {
    dbg_os << '[';
    const char *sep = "";
    for (const auto &e : x)
      dbg_os << exchange(sep, ", "), dbg_show(e);
    dbg_os << ']';
  } else if constexpr (requires { tuple_size<T>::value; }) {
    dbg_os << '(';
    apply([](const auto &...e) { dbg_list(e...); }, x);
    dbg_os << ')';
  } else {
    dbg_os << x;
  }
}
void dbg_out(int line, const char *names, const auto &...values) {
  dbg_os.str("");
  dbg_os << boolalpha << '[' << line << "] " << names << " = ";
  dbg_list(values...);
  dbg_os << '\n';
  cerr << dbg_os.view();
}
#define dbg(...) dbg_out(__LINE__, #__VA_ARGS__ __VA_OPT__(, ) __VA_ARGS__)
