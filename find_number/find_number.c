#include <stdio.h>

int main(void) {
  int i = 20;
  int j;
  int dividable_by_all;
  while (1) {
    dividable_by_all = 1;
    for (j = 20; j >= 1; j--) {
      if (i % j != 0) {
        dividable_by_all = 0;
        break;
      }
    }
    if (dividable_by_all) {
      printf("%i\n", i);
      return;
    }
    i += 20;
  }
}
