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
  Map<String, String> fields = new Map();
  String currentName = null;
  
  new File('sample_req.txt').readAsString().then((str) {
    return str.replaceAll('\n', '\r\n').codeUnits;
  }).then((buffer) {
    var input = new StaticStream(buffer).stream;
    String boundary = '------WebKitFormBoundaryj4ThXXSLZKddXVWh';
    var transformer = new PartTransformer(boundary);
    input.transform(transformer).listen((Part x) {
      String value = '';
      x.stream.listen((List<int> x) {
        value += new String.fromCharCodes(x);
      }, onDone: () {
        fields[x.contentDisposition.parameters['name']] = value;
      });
    }, onError: (e) {
      print("got error: $e");
    }, onDone: () {
      print('fields = $fields');
      assert(fields['menu-name'] == 'Alux');
      assert(fields['file-name'] == 'alux.iso');
      print('passed!');
      // the `image` field is just so annoying to get as a String with \r\n
    });
  });
}
