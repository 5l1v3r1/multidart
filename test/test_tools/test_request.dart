part of test;

String getLocalPath(String filename) {
  return 'test_tools/' + filename;
}

class TestRequest {
  List<int> body;
  String program;
  
  TestRequest(this.body, this.program);
  
  static Future<TestRequest> read() {
    List<int> reqData;
    return new File(getLocalPath('sample_req.txt')).readAsString().then((str) {
      return str.replaceAll('\n', '\r\n').codeUnits;
    }).then((_reqData) {
      reqData = _reqData;
      return new File(getLocalPath('program.txt')).readAsString();
    }).then((program) {
      return new TestRequest(reqData, program.replaceAll('\n', '\r\n'));
    });
  }
}
