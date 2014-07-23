part of multidart;

abstract class _Delimiter {
  int get start;
  int get length;
  bool isPrefix(List<int> list);
}

class _SingleDelimiter implements _Delimiter {
  List<int> delimiter;
  
  int get start => delimiter[0];
  int get length => delimiter.length;
  
  _SingleDelimiter(this.delimiter);
  
  bool isPrefix(List<int> list) {
    if (list.length > delimiter.length) return false;
    for (int i = 0; i < list.length; i++) {
      if (list[i] != delimiter[i]) return false;
    }
    return true;
  }

}

class _DoubleDelimiter implements _Delimiter {
  _SingleDelimiter del1;
  _SingleDelimiter del2;
  
  int get start => del1.start;
  int get length => del1.length;
  
  _DoubleDelimiter(List<int> l1, List<int> l2) {
    del1 = new _SingleDelimiter(l1);
    del2 = new _SingleDelimiter(l2);
    assert(del1.start == del2.start);
    assert(del1.length == del2.length);
  }
  
  bool isPrefix(List<int> l) {
    return del1.isPrefix(l) || del2.isPrefix(l);
  }

}
