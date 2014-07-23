part of multidart;

abstract class _MultipartState {
  MultipartStream stream;
  
  List<int> get boundary => stream._boundary;
  List<int> get buffer => stream._buffer;
  
  _MultipartState(this.stream);
  
  _MultipartState processBuffer();
}
