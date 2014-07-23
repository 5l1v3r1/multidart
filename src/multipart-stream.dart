part of multidart;

List<int> _boundaryToList(String str) {
  var charCodes = new List<int>.from(str.codeUnits);
  charCodes.addAll('\r\n'.codeUnits);
  return charCodes;
}

class MultipartStream {
  final Stream<List<int>> _source;
  final List<int> _boundary;
  final List<int> _buffer;
  
  MultipartState _state;
  
  StreamController<HttpMultipartPart> _controller;
  StreamSubscription _sourceSubscription;
  
  Stream<HttpMultipartPart> get stream => _controller.stream;

  MultipartStream(String boundary, this._source) :
      _boundary = _boundaryToList(boundary), _buffer = <int>[] {
    _state = new _MultipartInit(this);
    _controller = new StreamController(onListen: _onListen, onPause: _onPause,
        onResume: _onResume, onCancel: _onCancel);
  }
  
  _onListen() {
    _sourceSubscription = _source.listen(_onData, onDone: _onDone,
        onError: _onError);
  }
  
  _onPause() {
    _sourceSubscription.pause();
  }
  
  _onResume() {
    _sourceSubscription.resume();
  }
  
  _onCancel() {
    _sourceSubscription.cancel();
  }
  
  _onData(List<int> data) {
    _buffer.addAll(data);
    _processBuffer();
  }
  
  _onDone() {
    // TODO: here, verify that we are actually done
    _controller.close();
  }
  
  _onError(e) {
    _controller.addError(e);
    _controller.close();
  }
  
  _processBuffer() {
    try {
      while (_buffer.length > 0) {
        _state = _state.processBuffer();
      }
    } catch(e, s) {
      _sourceSubscription.cancel();
      _controller.addError(e, s);
      _controller.close();
    }
  }

}

