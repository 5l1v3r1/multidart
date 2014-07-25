part of multidart;

/**
 * This class represents a generic multipart-related error.
 */
class MultipartError extends Error {
  String message;
  
  /**
   * Create a multipart error with a message.
   */
  MultipartError(this.message);
  
  /**
   * Generate a human-readable representation of this error for debugging
   * purposes.
   */
  String toString() {
    return 'MultipartError: $message';
  }
}
