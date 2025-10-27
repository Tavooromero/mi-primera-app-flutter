import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class SharedPreferencesService {
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _dataListKey = 'data_list';
  static const String _usersKey = 'registered_users';

  // Guardar usuario logueado
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
    await prefs.setBool(_isLoggedInKey, true);
  }

  // Registrar nuevo usuario
  static Future<bool> registerUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getRegisteredUsers();

    // Verificar si el email ya existe
    if (users.any((u) => u.email == user.email)) {
      return false; // Email ya registrado
    }

    users.add(user);
    final usersString = users.map((u) => json.encode(u.toJson())).toList();
    await prefs.setStringList(_usersKey, usersString);
    return true;
  }

  // Obtener todos los usuarios registrados
  static Future<List<User>> getRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersList = prefs.getStringList(_usersKey) ?? [];

    return usersList.map((userString) {
      try {
        final userMap = json.decode(userString);
        return User.fromJson(userMap);
      } catch (e) {
        return User(
          username: '',
          email: '',
          password: '',
          firstName: '',
          lastName: '',
          phone: '',
          birthDate: '',
          gender: '',
          address: '',
          occupation: '',
          preferences: '',
        );
      }
    }).toList();
  }

  // Buscar usuario por email (para recuperación de contraseña)
  static Future<User?> findUserByEmail(String email) async {
    final users = await getRegisteredUsers();
    try {
      return users.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  // Verificar login
  static Future<bool> login(String email, String password) async {
    final users = await getRegisteredUsers();
    return users.any((user) => user.email == email && user.password == password);
  }

  // Obtener usuario por email
  static Future<User?> getUserByEmail(String email) async {
    final users = await getRegisteredUsers();
    try {
      return users.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  // Obtener usuario logueado
  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    if (userString != null) {
      try {
        final userMap = json.decode(userString);
        return User.fromJson(userMap);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Verificar si hay usuario logueado
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Cerrar sesión
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  // Guardar datos del formulario
  static Future<void> saveFormData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final existingData = await getFormDataList();
    existingData.add(data);

    final dataStringList = existingData.map((item) => json.encode(item)).toList();
    await prefs.setStringList(_dataListKey, dataStringList);
  }

  // Obtener lista de datos guardados
  static Future<List<Map<String, dynamic>>> getFormDataList() async {
    final prefs = await SharedPreferences.getInstance();
    final dataList = prefs.getStringList(_dataListKey) ?? [];

    return dataList.map((item) {
      try {
        return Map<String, dynamic>.from(json.decode(item));
      } catch (e) {
        return <String, dynamic>{};
      }
    }).toList();
  }
}