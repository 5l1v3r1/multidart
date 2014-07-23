part of multidart;

class _MultipartHeaders extends _MultipartState {
  List<int> currentLine;
  Map<String, HeaderValue> headers;
  
  _MultipartHeaders(MultipartStream s) : super(s), currentLine = [];
  
  _MultipartState processBuffer() {
    // use this to process the buffer, then return a MultipartPart when
    // appropriate
    while (buffer.length) {
      
    }
    
    // var newState = _MultipartBody(state);
    // state._controller.add(newState.partInfo);
    return this;
  }
}
