part of test;

class StaticStream {
  final List<int> _data;
  StreamController<List<int>> _controller;
  
  Stream<List<int>> get stream => _controller.stream;
  
  StaticStream(this._data, {bool atOnce: true}) {
    _controller = new StreamController(onListen: () {
      if (atOnce) {
        _controller.add(_data);
      } else {
        for (int i = 0; i < _data.length; i++) {
          _controller.add([_data[i]]);
        }
      }
      _controller.close();
    });
  }
}
