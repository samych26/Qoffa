import 'package:flutter/material.dart';
import 'package:qoffa/controleur/clientControleur.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  bool isPasswordHidden = true;

  Future<void> handleSignUp() async {
    List<String> nameParts = fullNameController.text.trim().split(" ");
    String nom = nameParts.length > 1 ? nameParts.last : "";
    String prenom = nameParts.length > 1 ? nameParts.first : "";

    final controller = ClientControleur();

    bool result = await controller.inscrireClient(
      nom: nom,
      prenom: prenom,
      email: emailController.text.trim(),
      motDePasse: passwordController.text,
      confirmationMotDePasse: passwordController.text,
      adresseClient: "", 
      numTelClient: phoneController.text.trim(),
    );

    if (result) {
      Navigator.pushNamed(context, '/home_client');
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Erreur"),
          content: const Text("Échec de l'inscription. Vérifiez les informations saisies."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create An Account",
                  style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Create Your Account. It Takes Less Than A Minute.\nEnter Your Full Name, Your Email, A Password, And Your Phone Number.",
                  style: TextStyle(fontSize: 14, color: Colors.white60),
                ),
                const SizedBox(height: 32),

                const Text("Full Name", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 4),
                TextField(
                  controller: fullNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: buildInputDecoration("first and last name"),
                ),
                const SizedBox(height: 16),

                const Text("Email", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 4),
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: buildInputDecoration("example@example.com"),
                ),
                const SizedBox(height: 16),

                const Text("Password", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 4),
                TextField(
                  controller: passwordController,
                  obscureText: isPasswordHidden,
                  style: const TextStyle(color: Colors.white),
                  decoration: buildInputDecoration("************").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                        color: Color(0xFFCCFF00),
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                const Text("Phone Number", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 4),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white),
                  decoration: buildInputDecoration("0XXXXXXXXX"),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFCCFF00),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Create an account"),
                  ),
                ),
                const SizedBox(height: 20),

                const Center(
                  child: Text("or sign up with", style: TextStyle(color: Colors.white60)),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFFCCFF00),
                      child: IconButton(
                        icon: const Icon(Icons.g_mobiledata, color: Colors.black),
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup_google');
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    CircleAvatar(
                      backgroundColor: Color(0xFFCCFF00),
                      child: IconButton(
                        icon: const Icon(Icons.facebook, color: Colors.black),
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup_facebook');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/login_customer'),
                    child: const Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(color: Colors.white54),
                        children: [
                          TextSpan(
                            text: "Log in",
                            style: TextStyle(color: Color(0xFFCCFF00)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/terms'),
                    child: const Text(
                      "By continuing, you agree to\nTerms of Use and Privacy Policy.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFCCFF00), fontSize: 12),
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

  InputDecoration buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFCCFF00)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFCCFF00)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFCCFF00)),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
