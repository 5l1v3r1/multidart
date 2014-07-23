part of multidart;

class MultipartDatum {
  final List<int> data;
  final Map<String, HeaderValue> headers;
  final bool isData;
  
  MultipartDatum.fromData(this.data) : headers = null, isData = true;
  
  MultipartDatum.fromHeaders(this.headers): data = null, isData = false;
  
  String toString() {
    if (isData) {
      return '<MultipartDatum data=$data>';
    } else {
      return '<MultipartDatum headers=$headers>';
    }
  }
  
}
