part of multidart;

/**
 * A [_Phase] is used in a loop by a [_DatumStream] to process data. A phase
 * can force a phase transition, in which case it returns a new [_Phase] object
 * to take future data events. 
 */
abstract class _Phase {
  final _DatumStream stream;
  
  List<int> delimiterBody;
  bool processingDelimiter;
  
  List<int> get boundary => stream._boundary;
  List<int> get buffer => stream._buffer;
  
  void set buffer(List<int> b) {
    stream._buffer = b;
  }
  
  _Phase(this.stream) {
    delimiterBody = null;
    processingDelimiter = false;
  }
  
  /**
   * Override this to return the Phase's delimiter.
   */
  _Delimiter get delimiter;
  
  /**
   * Override this to receive events which do not include any delimiter data.
   */
  void handleData(List<int> body);
  
  /**
   * Override this to get notified at the detection of a delimiter.
   */
  _Phase handleDelimiter(List<int> delimiter);
  
  /**
   * This method is called in a loop by the MultipartStream until its buffer
   * is empty.
   */
  _Phase processBuffer() {
    if (processingDelimiter) {
      return processDelimiterNext();
    }
    
    int delIdx = buffer.indexOf(delimiter.start);
    if (delIdx < 0) {
      handleData(buffer);
      buffer = [];
      return this;
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
  
  /**
   * Called internally for each character of a delimiter.
   */
  _Phase processDelimiterNext() {
    delimiterBody.add(buffer[0]);
    buffer.removeAt(0);
    if (!delimiter.isPrefix(delimiterBody)) {
      processingDelimiter = false;
      handleData([delimiterBody[0]]);
      buffer.insertAll(0, delimiterBody.getRange(1, delimiterBody.length));
    } else if (delimiter.isFullDelimiter(delimiterBody)) {
      processingDelimiter = false;
      return handleDelimiter(delimiterBody);
    }
    return this;
  }
}
