part of multidart;

class _HeadersPhase extends _Phase {
  List<int> currentLine;
  final Map<String, HeaderValue> headers;
  
  _HeadersPhase(_DatumStream s) : super(s), headers = new Map() {
    currentLine = null;
  }
  
  _Delimiter get delimiter => new _SingleDelimiter([13, 10]); // \r\n
  
  void handleData(List<int> body) {
    if (currentLine == null) {
      currentLine = body;
    } else {
      currentLine.addAll(body);
    }
  }
  
  _Phase handleDelimiter(List<int> delimiter) {
    if (currentLine == null) {
      stream._controller.add(new Datum.fromHeaders(headers));
      return new _BodyPhase(stream);
    }
    
    String line = new String.fromCharCodes(currentLine);
    currentLine = null;
    
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
