#include <stdio.h>
#include <stdlib.h>

void foo(int i) {
  foo(i+1);
}

int main() {
  foo(0);

  return 0;
}