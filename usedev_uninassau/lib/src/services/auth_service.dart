import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  static const String _tokenKey = 'auth_token';

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<bool> login(String username, String password) async {
    if (username.isEmpty || username.length < 3) {
      throw Exception('Usuário deve ter pelo menos 3 caracteres');
    }

    if (password.isEmpty || password.length < 4) {
      throw Exception('Senha deve ter pelo menos 4 caracteres');
    }

    await Future<void>.delayed(const Duration(milliseconds: 800));

    final token = 'token_${username}_${DateTime.now().millisecondsSinceEpoch}';

    await _storage.write(key: _tokenKey, value: token);

    return true;
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<void> saveSession(String username) async {
    await _storage.write(key: _tokenKey, value: username);
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }
}