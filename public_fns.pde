int[] convertToUnicodeNum(String original) {
  StringBuilder sb = new StringBuilder();
  for (int i = 0; i < original.length(); i++) {
    sb.append(String.format("\\u%04X", Character.codePointAt(original, i)));
  }
  String unicode = sb.toString();

  int[] result=new int[4];
  for (int i=0; i<4; i++) {
    result[i]=unhex(unicode.substring(2+i, 3+i));
  }

  return result;
}

String convertToOiginal(String unicode){
    String[] codeStrs = unicode.split("\\\\u");
    int[] codePoints = new int[codeStrs.length - 1]; // 最初が空文字なのでそれを抜かす
    for (int i = 0; i < codePoints.length; i++) {
        codePoints[i] = Integer.parseInt(codeStrs[i + 1], 16);
    }
    String encodedText = new String(codePoints, 0, codePoints.length);
    return encodedText;
}
