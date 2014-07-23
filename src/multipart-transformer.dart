part of multidart;

class MultipartTransformer implements
  StreamTransformer<List<int>, MultipartPart> {
  
  final String boundary;
  
  MultipartTransformer(String this.boundary);
  
  Stream<MultipartPart> bind(Stream<List<int>> stream) {
    return new MultipartStream(boundary, stream).stream;
  }
  
}
