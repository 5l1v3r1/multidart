part of multidart;

abstract class _MultipartState {
  MultipartStream stream;
  List<int> delimiterBody;
  bool processingDelimiter;
  
  List<int> get boundary => stream._boundary;
  List<int> get buffer => stream._buffer;
  void set buffer(List<int> b) => stream._buffer = b;
  
  _MultipartState(this.stream) : processingDelimiter = false;
  
  // abstract fields
  _Delimiter get delimiter;
  void handleData(List<int> body);
  _MultipartState handleDelimiter(List<int> delimiter);
  
  // called in a loop by MultipartStream
  _MultipartState processBuffer() {
    if (processingDelimiter) {
      return processNextDelimiter();
    }
    
    int delIdx = buffer.indexOf(delimiter.start);
    if (delIdx < 0) {
      handleData(buffer);
      buffer = [];
      return;
    }
    if (delIdx > 0) {
      var body = buffer.sublist(0, delIdx);
      buffer.removeRange(0, delIdx);
      handleData(body);
    }
    
    // now, delimiter is at index 0
    processingDelimiter = true;
    delimiterBody = <int>[];
    return this; // super loop will catch us
  }
  
  // called for each character in a delimiter
  _MultipartState processNextDelimiter() {
    delimiterBody.add(buffer[0]);
    buffer.removeAt(0);
    if (!delimiter.isPrefix(delimiterBody)) {
      processingDelimiter = false;
      handleData(delimiterBody);
    } else if (delimiter.length == delimiterBody.length) {
      processingDelimiter = false;
      return handleDelimiter(delimiterBody);
    }
    return this;
  }
}
