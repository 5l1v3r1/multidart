import '../lib/multidart.dart';
import 'test_tools/test_tools.dart';
import 'dart:async';
import 'dart:io';

typedef bool ErrorValidator(obj);

class TestCase {
  String requestBody;
  String name;
  ErrorValidator validator;
  TestCase(this.requestBody, this.name, this.validator);
}

void main() {
  String invlStart = "hey there bro";
  String invlHeader = '------boundary\r\nhey\r\n';
  String missingHeader = '------boundary\r\nContent-type: foo\r\n\r\n' +
      'some content\r\n------boundary--\r\n';
  String prematureEnd = '------boundary';
  String badDisposition = '------boundary\r\nContent-type: foo\r\n' +
      'Content-disposition: fooobarrrrrr; =; =\r\n\r\nsome content' +
      '\r\n------boundary--\r\n';
  
  List<TestCase> tests = [];
  tests.add(new TestCase(invlStart, 'invalid start', (obj) {
    if (!(obj is MultipartError)) return false;
    return obj.message == 'initial boundary did not match';
  }));
  tests.add(new TestCase(invlHeader, 'invalid header', (obj) {
    if (!(obj is MultipartError)) return false;
    return obj.message == 'header missing colon: "hey"';
  }));
  tests.add(new TestCase(missingHeader, 'missing content-disposition', (obj) {
    if (!(obj is MultipartError)) return false;
    return obj.message == 'part missing content-disposition header';
  }));
  tests.add(new TestCase(prematureEnd, 'premature end', (obj) {
    if (!(obj is MultipartError)) return false;
    return obj.message == 'premature end of stream';
  }));
  tests.add(new TestCase(badDisposition, 'bad content-disposition', (obj) {
    return obj is RangeError;
  }));
  
  Iterator<TestCase> iterator = tests.iterator;
  
  void runNext() {
    if (!iterator.moveNext()) {
      print("passed!");
      exit(0);
    }
    TestCase test = iterator.current;
    print("testing " + test.name + '...');
    List<int> body = test.requestBody.codeUnits;
    testFailureRequest(body, test.validator, false).then((_) {
      return testFailureRequest(body, test.validator, true);
    }).then((_) {
      runNext();      
    });
  }
  
  runNext();
}

Future testFailureRequest(List<int> body, ErrorValidator validator,
                          bool atOnce) {
  Completer completer = new Completer();
  Stream stream = new StaticStream(body, atOnce: atOnce).stream;
  
  String boundary = '----boundary';
  var transformer = new PartTransformer(boundary);
  var sub;
  sub = stream.transform(transformer).listen((Part x) {
    x.stream.drain();
  }, onError: (e) {
    sub.cancel();
    if (!validator(e)) {
      print('invalid error: $e');
      exit(1);
    } else {
      completer.complete(null);
    }
  }, onDone: () {
    print("did not receive expected error!");
    exit(1);
  });
  
  return completer.future;
}
