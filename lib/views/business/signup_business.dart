import 'dart:ui';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import '../login_page.dart';

class BusinessSignUpPage extends StatefulWidget {
  const BusinessSignUpPage({super.key});

  @override
  State<BusinessSignUpPage> createState() => _BusinessSignUpPageState();
}

class _BusinessSignUpPageState extends State<BusinessSignUpPage> {
  int currentPage = 1;
  String selectedCategory = 'Restaurant';
  final List<String> categories = ['Restaurant', 'Supermarket', 'Market', 'Bakery'];
  String? selectedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg_splash.png',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Text(
                  currentPage == 1 ? "Create Business Account" : "Business Details",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'LeagueSpartan',
                  ),
                ),
                const SizedBox(height: 24),
                if (currentPage == 1) _buildFirstPage(),
                if (currentPage == 2) _buildSecondPage(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFirstPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("First Name"),
        _buildInputField("John"),

        _buildLabel("Last Name"),
        _buildInputField("Doe"),

        _buildLabel("Email"),
        _buildInputField("john@example.com"),

        _buildLabel("Password"),
        _buildInputField("Enter password", isPassword: true),

        _buildLabel("Business Category"),
        _buildDropdown(),

        const SizedBox(height: 16),
        Center(
          child: RichText(
            text: TextSpan(
              text: "Already have an account? ",
              style: const TextStyle(color: Colors.white70),
              children: [
                TextSpan(
                  text: "Log in",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        _buildNextButton(),
        const SizedBox(height: 16),
        _buildProgress(1),
        const SizedBox(height: 16),
        _buildTermsText(),
      ],
    );
  }

  Widget _buildSecondPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Business Name"),
        _buildInputField("Qoffa"),

        _buildLabel("Phone Number"),
        _buildInputField("06 XX XX XX XX"),

        _buildLabel("Business Address"),
        _buildInputField("123 Rue Example, Ville"),

        _buildLabel("Commercial Registration Number"),
        _buildInputField("RC-1234567890"),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: _buildLabel("Commercial Registration File"),
            ),
            const SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 30.57, // Hauteur personnalisée
                child: ElevatedButton.icon(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles();
                    if (result != null) {
                      setState(() {
                        selectedFile = result.files.single.name;
                      });
                    }
                  },
                  icon: const SizedBox(), // vide pour garder l'espace à gauche (ou tu peux mettre une autre icône)
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          selectedFile ?? "Upload",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Icon(Icons.upload_file, size: 20),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF3E9B5),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),
        _buildNextButton(),
        const SizedBox(height: 16),
        _buildProgress(2),
        const SizedBox(height: 16),
        _buildTermsText(),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'LeagueSpartan',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, {bool isPassword = false}) {
    return TextFormField(
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFF3E9B5)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF3E9B5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFF3E9B5)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              value: selectedCategory,
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFF3E9B5), width: 1.5),
                ),
                offset: const Offset(0, 10),
                elevation: 4,
              ),
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 12),
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.arrow_drop_down, color: Color(0xFFF3E9B5)),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.white30),
                      ),
                    ),
                    child: Text(
                      category,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFFF3E9B5)),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (currentPage == 1) {
            setState(() => currentPage = 2);
          } else {
            // Enregistrement final ou redirection ici
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Account created!")),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF3E9B5).withOpacity(0.80),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),

        ),
        child: const Text("Next", style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildProgress(int current) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        final isActive = current == index + 1;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 30,
          height: 4,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFF3E9B5) : Colors.white38,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }


  Widget _buildTermsText() {
    return const Center(
      child: Text(
        "By continuing, you agree to\nTerms of Use and Privacy Policy.",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white54, fontSize: 13),
      ),
    );
  }
}
