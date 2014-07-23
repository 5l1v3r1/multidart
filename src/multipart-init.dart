part of multidart;

class _MultipartInit extends _MultipartState {
  int doneCount;
  
  _MultipartInit(MultipartStream s) : super(s), doneCount = 0;
  
  _MultipartState processBuffer() {
    int size = boundary.length - doneCount;
    if (size > buffer.length) size = buffer.length;
    
    var boundaryList = boundary.sublist(doneCount, doneCount + size);
    var bufferList = buffer.sublist(0, size);
    buffer.removeRange(0, size);
    
    for (int i = 0; i < size; i++) {
      if (boundaryList[i] != bufferList[i]) {
        throw new MultipartError('initial boundary did not match');
      }
    }
    
    doneCount += size;
    if (doneCount == boundary.length) {
      return new _MultipartHeaders(stream);
    }
    
    return this;
  }
}
