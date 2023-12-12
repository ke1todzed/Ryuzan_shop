import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<String> signInEmailAndPassword(String email, String password);
  Future<String> signUpEmailAndPassword(String email, String password);
  Future resetPassword(String email);

  Future<void> signOut();
}


class SupabaseAuthRepository implements AuthRepository {
  final supabase = Supabase.instance.client;

  @override
  Future<String> signInEmailAndPassword(String email, String password) async {
    String errMsg = "";
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final userId = response.user?.id;
      if (userId == null) {
        throw UnimplementedError();
      }
    }on AuthException catch (e){
      switch (e.message){
        case "Email not confirmed":
          errMsg = "Эл-почта не подтверждена!";
          break;
        case "Invalid login credentials":
          errMsg = "Неверный логин или пароль";
          break;
        default:
          errMsg = "Ошибка";
          break;
      }
    }
    if (errMsg == ""){
      return "1";
    }
    return errMsg;
  }

  @override
  Future resetPassword(String email) async {
    await supabase.auth.resetPasswordForEmail(email);
  }

  @override
  Future<String> signUpEmailAndPassword(String email, String password) async {
    await supabase.auth.signUp(email: email, password: password);
    return "1";
  }

  @override
  Future<void> signOut() async {
    await supabase.auth.signOut();
    return;
  }
}
