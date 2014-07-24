import '../multidart.dart';
import 'test_tools/test_tools.dart';
import 'dart:async';

main() {
  TestRequest.read().then((TestRequest req) {
    var stream = new StaticStream(req.body, atOnce: true).stream;
    return testFileUpload(stream, req.program).then((_) {
      return req;
    });
  }).then((req) {
    var stream = new StaticStream(req.body, atOnce: false).stream;
    return testFileUpload(stream, req.program);
  }).then((_) {
    print('passed!');
  });
}

Future testFileUpload(Stream stream, String program) {
  Completer completer = new Completer();
  Map<String, String> fields = new Map();
  String currentName = null;
  
  String boundary = '------WebKitFormBoundaryj4ThXXSLZKddXVWh';
  var transformer = new DatumTransformer(boundary);
  stream.transform(transformer).listen((Datum x) {
    if (!x.isData) {
      String name = x.headers['content-disposition'].parameters['name'];
      currentName = name;
      fields[name] = '';
    } else {
      fields[currentName] += new String.fromCharCodes(x.data);
    }
  }, onError: (e) {
    print("got error: $e");
  }, onDone: () {
    assert(fields['menu-name'] == 'Alux');
    assert(fields['file-name'] == 'alux.iso');
    assert(fields['image'] == program);
    completer.complete(null);
  });
  
  return completer.future;
}
