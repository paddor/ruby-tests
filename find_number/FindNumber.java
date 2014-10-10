public class FindNumber {
  public static void main(String[] args) {
    long i = 20;
    int j;
    boolean dividable_by_all;
    while (true) {
      dividable_by_all = true;
      for (j = 20; j >= 1; j--) {
        if (i % j != 0) {
          dividable_by_all = false;
          break;
        }
      }
      if (dividable_by_all) {
        System.out.println(i);
        return;
      }
      i += 20;
    }
  }
}
