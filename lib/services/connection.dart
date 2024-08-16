import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class Connection {
  final WebSocketChannel channel;

  Connection(String url) : channel = WebSocketChannel.connect(Uri.parse(url)) {
    _sendSubscriptionMessage();
  }

  Stream<List<Map<String, dynamic>>> get stream {
    return channel.stream.map((message) {
      final decoded = jsonDecode(message) as Map<String, dynamic>;
      if (decoded['stream'] == "all@fpTckr") {
        final List<dynamic> datalist = decoded["data"];
        return datalist.map((item) => item as Map<String, dynamic>).toList();
      } else {
        return [];
      }
    });
  }

  void _sendSubscriptionMessage() {
    final subscriptionMessage = jsonEncode({
      "method": "SUBSCRIBE",
      "params": ["all@ticker"],
      "cid": "1"
    });
    channel.sink.add(subscriptionMessage);
  }

  void dispose() {
    channel.sink.close();
  }
}
