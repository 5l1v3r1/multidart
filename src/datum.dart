part of multidart;

class Datum {
  final List<int> data;
  final Map<String, HeaderValue> headers;
  final bool isData;
  
  Datum.fromData(this.data) : headers = null, isData = true;
  
  Datum.fromHeaders(this.headers): data = null, isData = false;
  
  String toString() {
    if (isData) {
      return '<MultipartDatum data=$data>';
    } else {
      return '<MultipartDatum headers=$headers>';
    }
  }
  
}
