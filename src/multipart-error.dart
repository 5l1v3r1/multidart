part of multidart;

class MultipartError extends Error {
  String message;
  
  MultipartError(this.message);
  
  String toString() {
    return 'MultipartError: $message';
  }
}
