part of multidart;

/**
 * A StreamTransformer that converts a binary stream to a stream of [Datum]
 * objects.
 */
class DatumTransformer implements
  StreamTransformer<List<int>, Datum> {
  
  /**
   * The multipart boundary for this stream
   */
  final String boundary;
  
  /**
   * Create a [DatumTransformer] given a multipart boundary.
   */
  DatumTransformer(this.boundary);
  
  /**
   * Create a [Datum] stream from a binary stream.
   */
  Stream<Datum> bind(Stream<List<int>> stream) {
    return new _DatumStream(boundary, stream).stream;
  }
  
}
