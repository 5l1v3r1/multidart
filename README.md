# multidart

This is an easy-to-use HTTP multipart library for Dart.

# Usage

Import multidart like this:

```dart
import 'multidart/multidart.dart';
```

You will get these two pieces of data from some HTTP server:

```dart
HttpRequest request = ...; // somewhere up the line
String boundary = '------myboundary'; // somewhere up the line
```

Now, the fun part. This will parse the multipart request and convert it to a `Map`:

```dart
Map<String, String> fields = new Map();
var transformer = new PartTransformer(boundary);
// listen for each Part object
request.transform(transformer).listen((Part x) {
  // read the part object
  String value = '';
  x.stream.listen((List<int> x) {
    value += new String.fromCharCodes(x);
  }, onDone: () {
    // set this field in the map now that we have it all
    fields[x.contentDisposition.parameters['name']] = value;
  });
}, onError: (e) {
  print('Got error: $e');
}, onDone: () {
  print('Got multipart request: $fields');
});
```

You can use a `PartTransformer` to parse a multipart request stream. The `PartTransformer` class converts a stream of `List<int>` objects to a stream of `Part` objects. Each `Part` object has a `stream` property which emits `List<int>` objects itself. Additionally, you can access a `Part`'s headers through its `header` property (the type of which is `Map<String, HeaderValue>`).

You will not receive another `Part` until you have completely read the previous `Part`. Nevertheless, each `Part` is "independent" from the main `Stream<Part>`. Because of this, you can pause or even `cancel()` your subscription to the main stream while still reading the current `Part`. Note, however, that if you `cancel()` your subscription to a `Part`, its parent `Stream<Part>` will be cancelled as well.

# Disclaimer

This is one of the first pieces of Dart code I have ever written. Do not judge me for it!

# Status

I have run some tests to make sure that this parser works properly. As far as performance is concerned, I do not expect it to be the best. The way the parser currently works, any carriage return in an uploaded file will cause a buffer flush, meaning that the byte arrays you get from a `Part`'s stream may be relatively small (a completely random file would yield an average of 256 bytes per buffer).
