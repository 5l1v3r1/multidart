part of multidart;

ContentType _parseContentType(Map<String, HeaderValue> headers) {
  HeaderValue raw = headers['content-type'];
  if (raw == null) return null;
  return ContentType.parse(raw.toString());
}

class Part {
  StreamController<List<int>> _controller;
  final PartStream _owner;
  
  Stream<List<int>> get stream => _controller.stream;
  
  final Map<String, HeaderValue> headers;
  final HeaderValue contentDisposition;
  final HeaderValue contentTransferEncoding;
  final ContentType contentType;
  
  Part._fromStream(_headers, this._owner) :
      headers = _headers,
      contentDisposition = _headers['content-disposition'],
      contentTransferEncoding = _headers['content-transfer-encoding'],
      contentType = _parseContentType(_headers) {
    _controller = new StreamController(onListen: _onListen, onPause: _onPause,
        onResume: _onResume, onCancel: _onCancel);
    if (contentDisposition == null) {
      throw new MultipartError('part missing content-disposition header.');
    }
  }
  
  void _onListen() {
    _owner._rawSubscription.resume();
  }
  
  void _onPause() {
    _owner._rawSubscription.pause();
  }
  
  void _onResume() {
    _owner._rawSubscription.resume();
  }
  
  void _onCancel() {
    if (this != _owner._currentPart) return;
    _owner._rawSubscription.cancel();
    _owner._controller.close();
  }
}
