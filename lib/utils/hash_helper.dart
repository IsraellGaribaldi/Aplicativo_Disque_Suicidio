import 'package:crypto/crypto.dart';
import 'dart:convert';

class HashHelper {
  static String hashSenha(String senha) {
    final bytes = utf8.encode(senha);
    return sha256.convert(bytes).toString();
  }
}