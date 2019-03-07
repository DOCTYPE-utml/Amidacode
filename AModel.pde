//文字変換機
class AModel {
  Permutation p;
  int[] biases=new int[4];

  AModel(Permutation _p, int[] _biases) {
    p=_p;
    biases=_biases;
  }

  String[] txtToResArr(String txt) {
    int[] arr=convertToUnicodeNum(txt);
    for (int i=0; i<4; i++) {
      arr[i]+=biases[i];
    }
    int[] resNum=p.applyLabel(arr);
    String[] resArr=new String[4];
    for (int i=0; i<4; i++) {
      resArr[i]=hex(resNum[i]).substring(7);
    }

    return resArr;
  }

  String txtToResTxt(String txt) {
    String[] resArr=txtToResArr(txt);
    String resUnicode="\\u";
    for (int i=0; i<4; i++) {
      resUnicode+=resArr[i];
    }

    return convertToOiginal(resUnicode);
  }
}
