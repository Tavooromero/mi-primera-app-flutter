import 'package:flutter/material.dart';
import '../services/shared_preferences_service.dart';
import '../models/user_model.dart';
import 'home_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para login
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

  // Controladores para registro
  final TextEditingController _regUsuarioController = TextEditingController();
  final TextEditingController _regEmailController = TextEditingController();
  final TextEditingController _regPasswordController = TextEditingController();
  final TextEditingController _regNombreController = TextEditingController();
  final TextEditingController _regApellidoController = TextEditingController();
  final TextEditingController _regTelefonoController = TextEditingController();
  final TextEditingController _regFechaNacimientoController = TextEditingController();
  final TextEditingController _regGeneroController = TextEditingController();
  final TextEditingController _regDireccionController = TextEditingController();
  final TextEditingController _regOcupacionController = TextEditingController();
  final TextEditingController _regPreferenciasController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  String _errorMessage = '';

  void _submitLogin() async {
    if (_loginEmailController.text.isEmpty || _loginPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, complete email y contraseña';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final success = await SharedPreferencesService.login(
      _loginEmailController.text,
      _loginPasswordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      final user = await SharedPreferencesService.getUserByEmail(_loginEmailController.text);
      if (user != null) {
        await SharedPreferencesService.saveUser(user);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
        );
      }
    } else {
      setState(() {
        _errorMessage = 'Email o contraseña incorrectos';
      });
    }
  }

  void _submitRegister() async {
    if (_regUsuarioController.text.isEmpty ||
        _regEmailController.text.isEmpty ||
        _regPasswordController.text.isEmpty ||
        _regNombreController.text.isEmpty ||
        _regApellidoController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, complete los campos obligatorios';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final newUser = User(
      username: _regUsuarioController.text,
      email: _regEmailController.text,
      password: _regPasswordController.text,
      firstName: _regNombreController.text,
      lastName: _regApellidoController.text,
      phone: _regTelefonoController.text,
      birthDate: _regFechaNacimientoController.text,
      gender: _regGeneroController.text,
      address: _regDireccionController.text,
      occupation: _regOcupacionController.text,
      preferences: _regPreferenciasController.text,
    );

    final success = await SharedPreferencesService.registerUser(newUser);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      await SharedPreferencesService.saveUser(newUser);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: newUser)),
      );
    } else {
      setState(() {
        _errorMessage = 'El email ya está registrado';
      });
    }
  }

  void _clearForm() {
    _regUsuarioController.clear();
    _regEmailController.clear();
    _regPasswordController.clear();
    _regNombreController.clear();
    _regApellidoController.clear();
    _regTelefonoController.clear();
    _regFechaNacimientoController.clear();
    _regGeneroController.clear();
    _regDireccionController.clear();
    _regOcupacionController.clear();
    _regPreferenciasController.clear();
    _errorMessage = '';
  }

  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _isLogin ? 'Bienvenido' : 'Crear Cuenta',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLogin ? 'Inicia sesión en tu cuenta' : 'Regístrate para comenzar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 30),

                // Mensaje de error
                if (_errorMessage.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red.shade600),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red.shade600),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_errorMessage.isNotEmpty) const SizedBox(height: 16),

                // FORMULARIO LOGIN
                if (_isLogin) ...[
                  TextField(
                    controller: _loginEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _loginPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _navigateToForgotPassword,
                      child: const Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],

                // FORMULARIO REGISTRO
                if (!_isLogin) ...[
                  _buildTextField(_regUsuarioController, 'Usuario *', Icons.person),
                  const SizedBox(height: 12),
                  _buildTextField(_regEmailController, 'Email *', Icons.email),
                  const SizedBox(height: 12),
                  _buildTextField(_regPasswordController, 'Contraseña *', Icons.lock, isPassword: true),
                  const SizedBox(height: 12),
                  _buildTextField(_regNombreController, 'Nombre *', Icons.badge),
                  const SizedBox(height: 12),
                  _buildTextField(_regApellidoController, 'Apellido *', Icons.badge),
                  const SizedBox(height: 12),
                  _buildTextField(_regTelefonoController, 'Teléfono', Icons.phone),
                  const SizedBox(height: 12),
                  _buildTextField(_regFechaNacimientoController, 'Fecha de Nacimiento', Icons.cake),
                  const SizedBox(height: 12),
                  _buildTextField(_regGeneroController, 'Género', Icons.transgender),
                  const SizedBox(height: 12),
                  _buildTextField(_regDireccionController, 'Dirección', Icons.home),
                  const SizedBox(height: 12),
                  _buildTextField(_regOcupacionController, 'Ocupación', Icons.work),
                  const SizedBox(height: 12),
                  _buildTextField(_regPreferenciasController, 'Preferencias Personales', Icons.favorite),
                ],

                const SizedBox(height: 24),

                // BOTÓN PRINCIPAL
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLogin ? _submitLogin : _submitRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      _isLogin ? 'Iniciar Sesión' : 'Registrarse',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // BOTÓN LIMPIAR
                if (!_isLogin)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: _clearForm,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                      child: Text(
                        'Limpiar Formulario',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                  ),

                if (!_isLogin) const SizedBox(height: 8),

                // CAMBIAR ENTRE LOGIN/REGISTRO
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                      _errorMessage = '';
                    });
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.grey.shade600),
                      children: [
                        TextSpan(
                          text: _isLogin
                              ? '¿No tienes cuenta? '
                              : '¿Ya tienes cuenta? ',
                        ),
                        TextSpan(
                          text: _isLogin ? 'Regístrate' : 'Inicia Sesión',
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      obscureText: isPassword,
    );
  }
}