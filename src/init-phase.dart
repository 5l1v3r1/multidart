part of multidart;

class _InitPhase extends _Phase {
  _InitPhase(s) : super(s);
  
  void handleData(List<int> body) {
    throw new MultipartError('initial boundary did not match');
  }
  
  _Phase handleDelimiter(List<int> boundary) {
    return new _HeadersPhase(stream);
  }
  
  _Delimiter get delimiter => new _SingleDelimiter(boundary);
}
