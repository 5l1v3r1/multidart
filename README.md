# multidart

This is an easy-to-use HTTP multipart library for Dart.

# Usage

Here is the simplest example:

    import 'multidart/multidart.dart';
    HttpRequest request = ...; // somewhere up the line
    String boundary = '------myboundary'; // somewhere up the line
    
    Map<String, String> fields = new Map();
    var transformer = new PartTransformer(boundary);
    request.transform(transformer).listen((Part x) {
      String value = '';
      x.stream.listen((List<int> x) {
        value += new String.fromCharCodes(x);
      }, onDone: () {
        fields[x.contentDisposition.parameters['name']] = value;
      });
    }, onError: (e) {
      print('Got error: $e');
    }, onDone: () {
      print('Got multipart request: $fields');
    });

You can use a `PartTransformer` to parse a multipart request stream. The `PartTransformer` class converts a stream of `List<int>` objects to a stream of `Part` objects. Each `Part` object has a `stream` property which emits `List<int>` objects itself. Additionally, you can access a `Part`'s headers through the its `header` property (the type of which is `Map<String, HeaderValue>`).

You will not receive another `Part` until you have completely read the previous `Part`. Nevertheless, each `Part` is "independent" from the main `Stream<Part>`. Because of this, you can pause or even `cancel()` your subscription to the main stream while still reading the current `Part`. However, if you `cancel()` your subscription to a `Part`, the `Stream<Part>` will be cancelled as well.

# Disclaimer

This is one of the first pieces of Dart code I have ever written. Do not judge me for it!

# Status

It would seem that this library works wonderfully for properly-formatted data. I have yet to formulate tests that verify the library's error handling ability.

# TODO:

 * Use underscores instead of dashes for filenames
 * Write error test for premature EOF
 * Write error test for excessive data
 * Write error test for missing `content-disposition`
 * Write error test for invalid header
