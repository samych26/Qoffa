import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'customer/signup_customer.dart';
import 'business/signup_business.dart';
import 'business/BusinessHomeView.dart';


class UserTypeSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/bg_splash.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: Color(0xFFF3E9B5).withOpacity(0),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tell us who you are!",
                  style: TextStyle(
                    fontSize: 26,
                    color: Color(0xFFF3E9B5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Choose your profile to get started.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFF3E9B5),
                  ),
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ClientSignUpView()),
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF3E9B5),
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Customer", style: TextStyle(fontSize: 16)),
                        SvgPicture.asset(
                          'assets/icons/iconCustomer.svg',
                          height: 28.71,
                          width: 19,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => BusinessSignUpPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF3E9B5),
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Business", style: TextStyle(fontSize: 16)),
                        SvgPicture.asset(
                          'assets/icons/iconBusiness.svg',
                          height: 23.5,
                          width: 24,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
