part of multidart;

class MultipartTransformer implements
  StreamTransformer<List<int>, MultipartDatum> {
  
  final String boundary;
  
  MultipartTransformer(this.boundary);
  
  Stream<MultipartDatum> bind(Stream<List<int>> stream) {
    return new MultipartStream(boundary, stream).stream;
  }
  
}
