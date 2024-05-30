#include <stdio.h>
#include <stdlib.h>

int fact(int n) {
    int ans = 1;
    while (n > 1) {
        ans *= n;
        n--;
    }
    return ans;
}

int main() {
    return 0;
}