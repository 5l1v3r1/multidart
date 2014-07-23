part of multidart;

List<int> _boundaryToList(String str) {
  var charCodes = new List<int>.from(str.codeUnits);
  charCodes.addAll('\r\n'.codeUnits);
  return charCodes;
}

class MultipartStream {
  final Stream<List<int>> _source;
  final List<int> _boundary;
  List<int> _buffer;
  
  MultipartState _state;
  
  StreamController<MultipartPart> _controller;
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
    _controller.addError(new MultipartError('premature end of stream'));
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
        if (_state != null) continue;
        
        if (_buffer.length != 0) {
          throw new MultipartError('got excess data');
        }
        _controller.close();
        // TODO: see if the source may still send us an annoyind onDone().
        _sourceSubscription.cancel();
        return;
      }
    } catch(e, s) {
      _sourceSubscription.cancel();
      _controller.addError(e, s);
      _controller.close();
    }
  }

}

