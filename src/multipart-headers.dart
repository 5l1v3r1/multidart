part of multidart;

class _MultipartHeaders extends _MultipartState {
  List<int> currentLine;
  Map<String, HeaderValue> headers;
  
  _MultipartHeaders(MultipartStream s) : super(s), currentLine = [] {
    headers = new Map<String, HeaderValue>();
  }
  
  _Delimiter get delimiter => new _SingleDelimiter([13, 10]); // \r\n
  
  void handleData(List<int> body) {
    currentLine.addAll(body);
  }
  
  _MultipartState handleDelimiter(List<int> delimiter) {
    if (currentLine.length == 0) {
      var newState = new _MultipartBody(this);
      stream._controller.add(newState.partInfo);
      return newState;
    }
    
    String line = new String.fromCharCodes(currentLine);
    currentLine = <int>[];
    
    int index = line.indexOf(':');
    if (index < 0) {
      throw new MultipartError('header missing colon: "$line"');
    }
    
    var keyName = line.substring(0, index).toLowerCase();
    var valueBody = line.substring(index + 1);
    
    headers[keyName] = HeaderValue.parse(valueBody);
    return this;
  }
}
