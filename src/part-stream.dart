part of multidart;

class PartStream {
  final Stream<Datum> _rawStream; 
  StreamSubscription<Datum> _rawSubscription;
  
  StreamController<Part> _controller;
  Stream<Part> get stream => _controller.stream;
  
  Part _currentPart;
  bool shouldCancel;
  
  PartStream(this._rawStream) {
    shouldCancel = false;
    _currentPart = null;
    _controller = new StreamController(onListen: _onListen, onCancel: _onCancel);
  }
  
  void _onListen() {
    _rawSubscription = _rawStream.listen(_onData, onError: _onError,
        onDone: _onDone);
  }
  
  void _onCancel() {
    if (_currentPart == null) {
      _rawSubscription.cancel();
      _controller.close();
    } else {
      shouldCancel = true;
    }
  }
  
  void _onData(Datum x) {
    if (x.isData) {
      assert(_currentPart != null);
      _currentPart._controller.add(x.data);
      return;
    }
    // end current part
    if (_currentPart != null) {
      _currentPart._controller.close();
    }
    // see if we should terminate
    if (shouldCancel) {
      _rawSubscription.cancel();
      _controller.close();
      return;
    }
    // attempt to create a new part
    try {
      _currentPart = new Part._fromStream(x.headers, this);
    } catch (e, s) {
      // report the error
      _rawSubscription.cancel();
      _controller.addError(e, s);
      _controller.close();
      return;
    }
    // wait for the part to be listen()'d before we continue to send data
    _rawSubscription.pause();
    _controller.add(_currentPart);
  }
  
  void _onError(e) {
    _controller.addError(e);
    _controller.close();
  }
  
  void _onDone() {
    if (_currentPart != null) {
      _currentPart._controller.close();
    }
    _controller.close();
  }
}
