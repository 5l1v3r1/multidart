part of multidart;

/**
 * Either a piece of data from a multipart section OR a set of headers for the
 * section that follows.
 */
class Datum {
  /**
   * The binary data in this datum. This field is only valid if [isData] is
   * `true`.
   */
  final List<int> data;
  
  /**
   * The header map for this packet. This field is only valid if [isData] is
   * `false`.
   */
  final Map<String, HeaderValue> headers;
  
  /**
   * `true` if this is a data packet, false if it is a header packet.
   */
  final bool isData;
  
  /**
   * Create a binary datum.
   */
  Datum.fromData(this.data) : headers = null, isData = true;
  
  /**
   * Create a header datum.
   */
  Datum.fromHeaders(this.headers): data = null, isData = false;
  
  /**
   * A human-readable representation of this datum, usually for debugging
   * purposes only.
   */
  String toString() {
    if (isData) {
      return '<MultipartDatum data=$data>';
    } else {
      return '<MultipartDatum headers=$headers>';
    }
  }
  
}
