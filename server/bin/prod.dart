import 'dart:io';

import 'package:server/socky.g.dart';
import 'package:socky_server/server.dart';

void main() async {
  var httpServer = await HttpServer.bind(
    InternetAddress.anyIPv4,
    8080,
  );
  print('Listening on ${httpServer.address.host}:${httpServer.port}');

  var sockyServer = SockyServer(
    httpServer: httpServer,
    rootSockyBuilder: () => RootSocky(),
  );

  await sockyServer.start();
}
