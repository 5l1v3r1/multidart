part of multidart;

/**
 * A StreamTransformer that converts a binary stream to a stream of [Part]
 * objects.
 */
class PartTransformer implements
  StreamTransformer<List<int>, Part> {
  
  /**
   * The multipart boundary for this stream.
   */
  final String boundary;
  
  /**
   * Create a [_PartStream] given a multipart boundary.
   */
  PartTransformer(this.boundary);
  
  /**
   * Creat a [Part] stream from a binary stream.
   */
  Stream<Part> bind(Stream<List<int>> stream) {
    Stream<Datum> datumStream = new _DatumStream(boundary, stream).stream;
    return new _PartStream(datumStream).stream;
  }
  
}
