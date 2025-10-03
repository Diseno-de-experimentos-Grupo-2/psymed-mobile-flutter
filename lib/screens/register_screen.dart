// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Campos adicionales para el perfil de paciente
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _professionalIdController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _professionalIdController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Las contraseñas no coinciden'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Crear cuenta y perfil de paciente
      final success = await authProvider.signUpWithProfile(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        country: _countryController.text.trim(),
        professionalId: int.tryParse(_professionalIdController.text.trim()) ?? 0,
      );

      if (success && mounted) {
        // Hacer login automáticamente después del registro
        final loginSuccess = await authProvider.signIn(
          _usernameController.text.trim(),
          _passwordController.text,
        );
        
        if (loginSuccess && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cuenta creada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
          // Navegar directamente a HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          // Si el login automático falla, solo volver atrás
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Usuario registrado. Por favor inicia sesión'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Error al registrar usuario'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Cuenta"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/logo.png'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Información de la cuenta",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: "Nombre de usuario",
                    hintText: "Ingresa tu nombre de usuario",
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un nombre de usuario';
                    }
                    if (value.length < 3) {
                      return 'El usuario debe tener al menos 3 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Contraseña",
                    hintText: "Ingresa tu contraseña",
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una contraseña';
                    }
                    if (value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Confirmar contraseña",
                    hintText: "Confirma tu contraseña",
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor confirma tu contraseña';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                const Text(
                  "Información personal",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: "Nombre",
                    hintText: "Ingresa tu nombre",
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: "Apellido",
                    hintText: "Ingresa tu apellido",
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu apellido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Correo electrónico",
                    hintText: "ejemplo@correo.com",
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu correo';
                    }
                    if (!value.contains('@')) {
                      return 'Ingresa un correo válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                const Text(
                  "Dirección",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _streetController,
                  decoration: const InputDecoration(
                    labelText: "Calle",
                    hintText: "Av. Principal 123",
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu dirección';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: "Ciudad",
                    hintText: "Lima",
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu ciudad';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _countryController,
                  decoration: const InputDecoration(
                    labelText: "País",
                    hintText: "Perú",
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu país';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _professionalIdController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "ID del Profesional asignado",
                    hintText: "Ingresa el ID de tu psicólogo/psiquiatra",
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el ID del profesional';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Ingresa un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: authProvider.isLoading ? null : _handleRegister,
                        child: authProvider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Crear Cuenta",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}