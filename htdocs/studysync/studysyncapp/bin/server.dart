// ./bin/server.dart
import 'dart:io';

main() async {
  var port = int.parse(Platform.environment['PORT'] ?? '4567');
  var server = await HttpServer.bind(InternetAddress.anyIPv4, port);

  print('Server listening at port $port');

  await for (HttpRequest request in server) {
    request.response
      ..write('Hello, World!')
      ..close();
  }
}