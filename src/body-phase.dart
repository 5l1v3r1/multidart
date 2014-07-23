part of multidart;

class _BodyPhase extends _Phase {
  _DoubleDelimiter theDelimiter;
  
  _BodyPhase(s) : super(s) {
    var firstBoundary = new List.from(boundary);
    firstBoundary.insertAll(0, [13, 10]);
    
    var finalBoundary = new List.from(firstBoundary);
    finalBoundary.insertAll(finalBoundary.length - 2, [0x2d, 0x2d]); // '--'
    
    theDelimiter = new _DoubleDelimiter(firstBoundary, finalBoundary);
  }
  
  _Delimiter get delimiter => theDelimiter;
  
  void handleData(List<int> body) {
    stream._controller.add(new MultipartDatum.fromData(body));
  }
  
  _Phase handleDelimiter(List<int> delimiter) {
    if (delimiter[delimiter.length - 3] == 0x2d) {
      return null;
    } else {
      return new _HeadersPhase(stream);
    }
  }
  
}
