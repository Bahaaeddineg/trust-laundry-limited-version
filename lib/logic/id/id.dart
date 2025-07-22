import 'dart:convert';

import 'package:crypto/crypto.dart';

String generateShortDisplayId(String fullId, {int length = 8}) {
  final bytes = utf8.encode(fullId);
  final digest = sha1.convert(bytes); // You can use md5 too if preferred
  return digest.toString().substring(0, length).toUpperCase();
}