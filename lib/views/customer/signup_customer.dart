import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../controllers/customer/signup_controller.dart';
import '../login_page.dart';

class ClientSignUpView extends StatefulWidget {
  @override
  _ClientSignUpViewState createState() => _ClientSignUpViewState();
}

class _ClientSignUpViewState extends State<ClientSignUpView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      final signupController = Provider.of<SignUpController>(context, listen: false);
      signupController.registerClient(
        context: context,
        nom: _nomController.text.trim(),
        prenom: _prenomController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phone: _phoneController.text.trim(),
      );
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  // Remplace la méthode _buildStyledField
  Widget _buildStyledField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'LeagueSpartan',
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? _obscurePassword : false,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFF3E9B5)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : const Color(0xFFF3E9B5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : Colors.white,
              ),
            ),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Color(0xFFF3E9B5),
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            )
                : null,
          ),
          cursorColor: Colors.white,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final signupController = context.watch<SignUpController>();
    return Scaffold(
      body: Stack(
        children: [
          // 🎨 Fond
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg_splash.png',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 102),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'LeagueSpartan',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please enter your details to create a new account.",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 32),

                  _buildStyledField(
                    label: "Nom",
                    hint: "Entrez votre nom",
                    controller: _nomController,
                    errorText: context.watch<SignUpController>().nomError,
                  ),
                  const SizedBox(height: 16),
                  _buildStyledField(
                    label: "Prénom",
                    hint: "Entrez votre prénom",
                    controller: _prenomController,
                    errorText: context.watch<SignUpController>().prenomError,
                  ),
                  const SizedBox(height: 16),
                  _buildStyledField(
                    label: "Email",
                    hint: "you@example.com",
                    controller: _emailController,
                    errorText: context.watch<SignUpController>().emailError,
                  ),
                  const SizedBox(height: 16),
                  _buildStyledField(
                    label: "Numéro de téléphone",
                    hint: "06XXXXXXXX",
                    controller: _phoneController,
                    errorText: signupController.phoneError,
                  ),

                  const SizedBox(height: 16),
                  _buildStyledField(
                    label: "Mot de passe",
                    hint: "Entrez votre mot de passe",
                    controller: _passwordController,
                    isPassword: true,
                    errorText: context.watch<SignUpController>().passwordError,
                  ),

                  const SizedBox(height: 32),

                  // Affiche le message de succès ou d’erreur
                  if (signupController.successMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Center(
                        child: Text(
                          signupController.successMessage!,
                          style: const TextStyle(color: Colors.greenAccent, fontSize: 14),
                        ),
                      ),
                    ),
                  if (signupController.generalError != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Center(
                        child: Text(
                          signupController.generalError!,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                        ),
                      ),
                    ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleSignUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF3E9B5),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Create a account ",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Center(
                    child: Text(
                      "or sign up with",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 🔘 Google
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFF3E9B5),
                        side: const BorderSide(color: Color(0xFFF3E9B5)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: SvgPicture.asset(
                                'assets/icons/google.svg',
                                height: 34.13,
                                width: 34.13,
                              ),
                            ),
                          ),
                          const Center(
                            child: Text(
                              "Sign up with Google",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  Center(
                    child: GestureDetector(
                      onTap: _goToLogin,
                      child: const Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(color: Colors.white70),
                          children: [
                            TextSpan(
                              text: "Log in",
                              style: TextStyle(
                                color: Color(0xFFF3E9B5),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
