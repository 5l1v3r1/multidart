part of multidart;

class PartTransformer implements
  StreamTransformer<List<int>, Datum> {
  
  final String boundary;
  
  PartTransformer(this.boundary);
  
  Stream bind(Stream<List<int>> stream) {
    Stream<Datum> datumStream = new DatumStream(boundary, stream).stream;
    return new PartStream(datumStream).stream;
  }
  
}
