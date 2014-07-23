part of multidart;

class DatumTransformer implements
  StreamTransformer<List<int>, Datum> {
  
  final String boundary;
  
  DatumTransformer(this.boundary);
  
  Stream<Datum> bind(Stream<List<int>> stream) {
    return new DatumStream(boundary, stream).stream;
  }
  
}
