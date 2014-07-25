/**
 * A simple mechanism for processing HTTP multipart form data.
 * 
 * You may use a [PartTransformer] to transform a regular HTTP data stream into
 * a stream of multipart sections in the form of [Part] objects. Each [Part]
 * object contains a set of headers and a stream of data. Here is a simple use
 * case of a [PartTransformer] that generates a `Map<String, String>` from a
 * multipart request:
 *
 *     import 'multidart/multidart.dart';
 *     
 *     HttpRequest request = ...; // somewhere up the line
 *     String boundary = '------myboundary'; // somewhere up the line
 *     
 *     Map<String, String> fields = new Map();
 *     var transformer = new PartTransformer(boundary);
 *     // listen for each Part object
 *     request.transform(transformer).listen((Part x) {
 *       // read the part object
 *       String value = '';
 *       x.stream.listen((List<int> x) {
 *         value += new String.fromCharCodes(x);
 *       }, onDone: () {
 *         // set this field in the map now that we have it all
 *         fields[x.contentDisposition.parameters['name']] = value;
 *       });
 *     }, onError: (e) {
 *       print('Got error: $e');
 *     }, onDone: () {
 *       print('Got multipart request: $fields');
 *     });
 * 
 * Note that this is a simplistic example which totally disregards non-ASCII
 * character encodings.
 * 
 */
library multidart;

import 'dart:async';
import 'dart:io'; // for HeaderValue

part 'src/delimiter.dart';
part 'src/multipart_error.dart';
part 'src/phase.dart';
part 'src/init_phase.dart';
part 'src/headers_phase.dart';
part 'src/body_phase.dart';
part 'src/datum.dart';
part 'src/datum_stream.dart';
part 'src/datum_transformer.dart';
part 'src/part.dart';
part 'src/part_stream.dart';
part 'src/part_transformer.dart';
