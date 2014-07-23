part of multidart;

class _MultipartBody extends _MultipartState {
  _MultipartHeaders headers;
  MultipartPart partInfo;
  _DoubleDelimiter theDelimiter;
  
  _MultipartBody(_headers) : super(_headers.stream), headers = _headers {
    partInfo = new MultipartPart();
    var finalBoundary = new List.from(boundary);
    finalBoundary.replaceRange(finalBoundary.length - 2,
        finalBoundary.length, [0x2d, 0x2d]); // 0x2d = '-'
    theDelimiter = new _DoubleDelimiter(boundary, finalBoundary);
  }
  
  _Delimiter get delimiter => theDelimiter;
  
  void handleData(List<int> body) {
    print("got data!");
  }
  
  _MultipartState handleDelimiter(List<int> delimiter) {
    // TODO: here, check if it's the last delimiter
    //print("got delimiter ${new String.fromCharCodes(delimiter)}");
    return new _MultipartHeaders(stream);
  }
  
}
