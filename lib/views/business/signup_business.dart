import 'dart:ui';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../../controllers/business/business_signup_controller.dart';
import '../login_page.dart';

class BusinessSignUpPage extends StatefulWidget {
  const BusinessSignUpPage({super.key});

  @override
  State<BusinessSignUpPage> createState() => _BusinessSignUpPageState();
}

class _BusinessSignUpPageState extends State<BusinessSignUpPage> {
  int currentPage = 1;
  String selectedCategory = 'Restaurant';
  final List<String> categories = ['restaurant', 'pastry', 'market', 'bakery'];

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final businessNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final registrationNumberController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    businessNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    registrationNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BusinessSignUpController>(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg_splash.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
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
                  if (currentPage == 1) _buildFirstPage(controller),
                  if (currentPage == 2) _buildSecondPage(controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hint, String? errorText, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: isPassword,
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
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildFirstPage(BusinessSignUpController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("First Name"),
        _buildInputField(firstNameController, "John", controller.firstNameError),
        _buildLabel("Last Name"),
        _buildInputField(lastNameController, "Doe", controller.lastNameError),
        _buildLabel("Email"),
        _buildInputField(emailController, "john@example.com", controller.emailError),
        _buildLabel("Password"),
        _buildInputField(passwordController, "Enter password", controller.passwordError, isPassword: true),
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
        _buildGlobalMessage(controller),
        _buildNextButton(controller),
        const SizedBox(height: 16),
        _buildProgress(1),
        const SizedBox(height: 16),
        _buildTermsText(),
      ],
    );
  }

  Widget _buildSecondPage(BusinessSignUpController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Business Name"),
        _buildInputField(businessNameController, "Qoffa", controller.businessNameError),
        _buildLabel("Phone Number"),
        _buildInputField(phoneController, "06 XX XX XX XX", controller.phoneNumberError),
        _buildLabel("Business Address"),
        _buildInputField(addressController, "123 Rue Example, Ville", controller.addressError),
        _buildLabel("Commercial Registration Number"),
        _buildInputField(registrationNumberController, "RC-1234567890", controller.registrationNumberError),
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
                height: 30.57,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await controller.pickRegistrationFile();
                    setState(() {});
                  },
                  icon: const SizedBox(),
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          controller.fileName ?? "Upload",
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
        if (controller.registrationFileError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              controller.registrationFileError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 24),
        _buildGlobalMessage(controller),
        _buildNextButton(controller),
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

  Widget _buildDropdown() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF3E9B5)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              value: selectedCategory,
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF3E9B5), width: 1.5),
                ),
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
                  child: Text(category, style: const TextStyle(color: Color(0xFFF3E9B5))),
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

  Widget _buildNextButton(BusinessSignUpController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.isLoading ? null : () async {
          if (currentPage == 1) {
            final valid = controller.validateFirstPage(
              firstName: firstNameController.text.trim(),
              lastName: lastNameController.text.trim(),
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );
            if (valid) {
              setState(() => currentPage = 2);
            }
          } else {
            await controller.registerBusiness(
              context: context,
              firstName: firstNameController.text.trim(),
              lastName: lastNameController.text.trim(),
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
              category: selectedCategory,
              businessName: businessNameController.text.trim(),
              phoneNumber: phoneController.text.trim(),
              address: addressController.text.trim(),
              registrationNumber: registrationNumberController.text.trim(),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF3E9B5),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: controller.isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.black,
            strokeWidth: 2,
          ),
        )
            : Text(
          currentPage == 1 ? "Next" : "Sign Up",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildProgress(int step) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 30,
          height: 5,
          decoration: BoxDecoration(
            color: step == index + 1 ? Colors.white : Colors.white24,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }

  Widget _buildTermsText() {
    return const Text(
      "By continuing, you agree to Terms of Use and Privacy Policy.",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white70, fontSize: 12),
    );
  }

  Widget _buildGlobalMessage(BusinessSignUpController controller) {
    if (controller.globalMessage == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        controller.globalMessage!,
        style: TextStyle(
          color: controller.isSuccessMessage ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}