import 'package:flutter/material.dart';
import 'package:qoffa/controleur/loginControleur.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  String? _erreurMessage;
  bool _emailInvalide = false;
  bool _motDePasseInvalide = false;

  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
      _erreurMessage = null;
      _emailInvalide = false;
      _motDePasseInvalide = false;
    });

    final controller = LoginControleur(
      identifiant: _emailController.text.trim(),
      motDePasse: _passwordController.text.trim(),
    );

    await controller.verifierConnexion();

    if (mounted) {
      setState(() {
        _isLoading = false;
        _erreurMessage = controller.messageErreur;
        _emailInvalide = controller.messageErreur?.toLowerCase().contains('email') ?? false;
        _motDePasseInvalide = controller.messageErreur?.toLowerCase().contains('mot de passe') ?? false;
      });

      if (controller.estValide) {
        Navigator.pushReplacementNamed(
          context,
          controller.typeUtilisateur == 'commercant' ? '/commercant' : '/client',
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  (MediaQuery.of(context).padding.top + kToolbarHeight),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'We Are Happy To See You Here Again. Enter Your Email Address And Your Password.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'example@example.com',
                      hintStyle: TextStyle(color: const Color(0xFFCCFF00).withOpacity(0.5)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: _emailInvalide ? Colors.redAccent : const Color(0xFFCCFF00),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: _emailInvalide ? Colors.redAccent : const Color(0xFFCCFF00),
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.black,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: '••••••••••••',
                      hintStyle: TextStyle(color: const Color(0xFFCCFF00).withOpacity(0.5)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: _motDePasseInvalide ? Colors.redAccent : const Color(0xFFCCFF00),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: _motDePasseInvalide ? Colors.redAccent : const Color(0xFFCCFF00),
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.black,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xFFCCFF00),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                  ),
                  const SizedBox(height: 16),
                  if (_erreurMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        _erreurMessage!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCCFF00),
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/la page forgot password');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Forgot Password'),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup_customer');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: const Color(0xFFCCFF00),
                        side: const BorderSide(color: Color(0xFFCCFF00)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Create an account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'or sign up with',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialIcon(Icons.g_mobiledata_rounded),
                      const SizedBox(width: 16),
                      _socialIcon(Icons.facebook_rounded),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login_customer');
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Color(0xFFCCFF00),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'By continuing, you agree to ',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/terms');
                        },
                        child: const Text(
                          'Terms of Use',
                          style: TextStyle(
                            color: Color(0xFFCCFF00),
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const Text(
                        ' and ',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/privacy');
                        },
                        child: const Text(
                          'Privacy Policy',
                          style: TextStyle(
                            color: Color(0xFFCCFF00),
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialIcon(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: Color(0xFFCCFF00),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black, size: 28),
        onPressed: () {
          // À implémenter : login Google / Facebook
        },
      ),
    );
  }
}
