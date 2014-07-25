part of multidart;

/**
 * This class represents a sequence of bytes that has the potential to cause a
 * phase transition.
 */
abstract class _Delimiter {
  int get start;
  bool isPrefix(List<int> list);
  bool isFullDelimiter(List<int> list);
}

class _SingleDelimiter implements _Delimiter {
  List<int> delimiter;
  
  int get start => delimiter[0];
  
  _SingleDelimiter(this.delimiter);
  
  bool isPrefix(List<int> list) {
    if (list.length > delimiter.length) return false;
    for (int i = 0; i < list.length; i++) {
      if (list[i] != delimiter[i]) return false;
    }
    return true;
  }
  
  bool isFullDelimiter(List<int> list) {
    return list.length == delimiter.length && isPrefix(list);
  }

}

class _DoubleDelimiter implements _Delimiter {
  _SingleDelimiter del1;
  _SingleDelimiter del2;
  
  int get start => del1.start;
  
  _DoubleDelimiter(List<int> l1, List<int> l2) {
    del1 = new _SingleDelimiter(l1);
    del2 = new _SingleDelimiter(l2);
    assert(del1.start == del2.start);
  }
  
  bool isPrefix(List<int> l) {
    return del1.isPrefix(l) || del2.isPrefix(l);
  }
  
  bool isFullDelimiter(List<int> l) {
    return del1.isFullDelimiter(l) || del2.isFullDelimiter(l);
  }

}
