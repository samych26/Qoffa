import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:qoffa/views/user_type_selection.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🎨 Image de fond
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg_splash.png',
              fit: BoxFit.cover,
            ),
          ),

          // 💬 Contenu principal
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 134),
            child: Consumer<AuthController>(
              builder: (context, authController, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),

                    const Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 32,
                        fontFamily: 'LeagueSpartan',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "We are happy to see you here again. enter your email address and your password.",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 32),

                    // 📧 Email
                    const Text(
                      "Email",
                      style: TextStyle(
                        fontFamily: 'LeagueSpartan',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (_) => authController.clearErrors(),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: const TextStyle(color: Color(0xFFF3E9B5)),
                        hintText: "you@example.com",
                        hintStyle: const TextStyle(color: Color(0xFFF3E9B5)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: authController.emailError != null
                                ? Colors.red
                                : const Color(0xFFF3E9B5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: authController.emailError != null
                                ? Colors.red
                                : const Color(0xFFF3E9B5),
                            width: 2,
                          ),
                        ),
                      ),
                      cursorColor: Colors.white,
                    ),
                    if (authController.emailError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          authController.emailError!,
                          style: const TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      ),

                    const SizedBox(height: 15),


                    // 🔒 Password
                    const Text(
                      "Password",
                      style: TextStyle(
                        fontFamily: 'LeagueSpartan',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      onChanged: (_) => authController.clearErrors(),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        hintStyle: const TextStyle(color: Color(0xFFF3E9B5)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: authController.passwordError != null
                                ? Colors.red
                                : const Color(0xFFF3E9B5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: authController.passwordError != null
                                ? Colors.red
                                : const Color(0xFFF3E9B5),
                            width: 2,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: const Color(0xFFF3E9B5),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      cursorColor: Colors.white,
                    ),
                    if (authController.passwordError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          authController.passwordError!,
                          style: const TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      ),


                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text("Forgot Password?",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 🔘 Log In
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          authController.signInWithEmail(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            context,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF3E9B5),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child:
                        const Text("Log In", style: TextStyle(fontSize: 16)),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ❗ General Error
                    if (authController.generalError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Center(
                          child: Text(
                            authController.generalError!,
                            style:
                            const TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      ),

                    const SizedBox(height: 34),

                    // ❓ Already have account?
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(color: Colors.white70),
                          children: [
                            TextSpan(
                              text: "Sign up",
                              style: const TextStyle(
                                color: Color(0xFFF3E9B5),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => UserTypeSelectionPage()),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}
