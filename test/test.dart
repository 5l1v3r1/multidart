import '../multidart.dart';
import 'dart:io';
import 'dart:async';

class StaticStream {
  final List<int> _data;
  StreamController<List<int>> _controller;
  
  Stream<List<int>> get stream => _controller.stream;
  
  StaticStream(this._data) {
    _controller = new StreamController(onListen: () {
      _controller.add(_data);
      _controller.close();
    });
  }
  
}

main() {
  testFileUpload();
}

testFileUpload() {
  new File('sample_req.txt').readAsString().then((str) {
    return str.replaceAll('\n', '\r\n').codeUnits;
  }).then((buffer) {
    var input = new StaticStream(buffer).stream;
    String boundary = '------WebKitFormBoundaryj4ThXXSLZKddXVWh';
    input.transform(new MultipartTransformer(boundary)).listen((x) {
      print("got part");
    }, onError: (e) {
      print("got error: $e");
    });
  });
}
