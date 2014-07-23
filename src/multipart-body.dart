part of multidart;

class _MultipartBody extends _MultipartState {
  _MultipartHeaders headers;
  MultipartPart partInfo;
  
  _MultipartBody(this.headers) : super(this.headers.stream) {
    partInfo = new MultipartPart();
  }
  
  _MultipartState processBuffer() {
    // use the buffer to seek out a terminal boundary and write everything to a
    // body stream in the meantime
    return this;
  }
  
}
