part of multidart;

class _MultipartInit extends _MultipartState {
  _MultipartInit(s) : super(s);
  
  void handleData(List<int> body) {
    throw new MultipartError('initial boundary did not match');
  }
  
  _MultipartState handleDelimiter(List<int> boundary) {
    return new _MultipartHeaders(stream);
  }
  
  _Delimiter get delimiter => new _SingleDelimiter(boundary);
}
