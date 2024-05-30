#include <stdlib.h>

void veryHugeFunction(int a, int b, int c, int d, int e, int f, int g, int h,
                      int j, int *s, char ch);

void veryHugeFunction(int a, int b, int c, int d, int e, int f, int g, int h,
                      int j, int *s, char ch) {
  if (a == 0 || d == 10 || a + b + c + d + e + f + g + h + j != s[1] ||
      ch != 's')
    return;

  int hugevariabletextlength = b + c + e;

  veryHugeFunction(a--, b--, c--, d++, hugevariabletextlength, f++, g--, h--,
                   j--, s, ch);
}

int main(int argc, char const *argv[]) { return 0; }