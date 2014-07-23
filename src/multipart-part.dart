part of multidart;

class MultipartPart {
  final StreamController<MultipartPart> _controller;
  Stream<MultipartPart> get stream => _controller.stream;
  
  MultipartPart() : _controller = new StreamController<MultipartPart>() {
  }
}
