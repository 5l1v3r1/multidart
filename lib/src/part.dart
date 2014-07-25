part of multidart;

ContentType _parseContentType(Map<String, HeaderValue> headers) {
  HeaderValue raw = headers['content-type'];
  if (raw == null) return null;
  return ContentType.parse(raw.toString());
}

/**
 * A streamable object which represents a part in a multipart stream.
 */
class Part {
  StreamController<List<int>> _controller;
  final _PartStream _owner;
  
  /**
   * The stream of data contained in this multipart section.
   */
  Stream<List<int>> get stream => _controller.stream;
  
  /**
   * The headers preceding this multipart section.
   */
  final Map<String, HeaderValue> headers;
  
  /**
   * The content disposition header of the multipart section. Since the
   * multipart specification mandates this be present, this is guaranteed not to
   * be `null`.
   */
  final HeaderValue contentDisposition;
  
  /**
   * The content transfer encoding header, or `null`.
   */
  final HeaderValue contentTransferEncoding;
  
  /**
   * The parsed content type, or `null`.
   */
  final ContentType contentType;
  
  /**
   * If you receive a [Part] object from a [PartTransformer], you may read its
   * headers and realize you want to abort the request.
   * 
   * Without this method, you would have to listen to [stream] and then cancel
   * your subscription. This method essentially wraps that functionality. Note
   * that you should only call this if you have not listened to [stream]
   * already.
   */
  void cancel() {
    _owner._rawSubscription.cancel();
    _owner._controller.close();
    _controller.close();
  }
  
  Part._fromStream(_headers, this._owner) :
      headers = _headers,
      contentDisposition = _headers['content-disposition'],
      contentTransferEncoding = _headers['content-transfer-encoding'],
      contentType = _parseContentType(_headers) {
    _controller = new StreamController(onListen: _onListen, onPause: _onPause,
        onResume: _onResume, onCancel: _onCancel);
    if (contentDisposition == null) {
      throw new MultipartError('part missing content-disposition header');
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
