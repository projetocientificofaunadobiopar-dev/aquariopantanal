import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseService _svc = SupabaseService();

  AuthProvider() {
    _svc.authChanges.listen((_) => notifyListeners());
  }

  bool get isLogged => _svc.session != null;
  Session? get session => _svc.session;

  Future<String?> login(String email, String password) async {
    try {
      await _svc.login(email, password);
      notifyListeners();
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    await _svc.logout();
    notifyListeners();
  }
}
