class Permutation {
  int n;
  int[] x;

  Permutation(int[] _x) {
    n=_x.length;
    x=new int [n];
    for (int i=0; i<n; i++) {
      x[i]=_x[i];
    }
  }

  int get_value(int i) {
    if (0<= i && i<n) {
      return x[i];
    } else {
      return i;
    }
  }

  //表記の仕方１
  void printP() {
    print("(");
    for (int i=0; i<n; i++) {
      print(" "+i);
    }
    println(" )");
    print("(");
    for (int i=0; i<n; i++) {
      print(" "+x[i]);
    }
    println(" )");
  }

  //表記の仕方２
  void printPArrow() {
    println("--------");
    for (int i=0; i<n; i++) {
      println(i+"->"+x[i]);
    }
    println("--------");
  }

  Permutation inverse() {
    int y[]=new int[n];
    for (int i=0; i<n; i++) {
      y[x[i]] =i;
    }
    return new Permutation(y);
  }

  //追加関数。整数値のラベル付け配列を置換の並びに入れ替える。
  int[] applyLabel(int[] arr) {
    int[] res=new int[n];
    for (int i=0; i<n; i++) {
      res[x[i]]=arr[i];
    }

    return res;
  }
}

Permutation makeIdentity(int _n) {
  int [] x=new int [_n];
  for (int i=0; i<_n; i++) {
    x[i]=i;
  }
  return new Permutation(x);
}
