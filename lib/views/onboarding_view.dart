import 'package:flutter/material.dart';
import 'customer/login_customer.dart';
import 'business/login_business.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/onboarding1.png",
      "title": "Delicious deals, zero \n waste thrills! ",
      "text": "Delicious meals at small prices, big impact on \n reducing food waste."
    },
    {
      "image": "assets/images/onboarding2.png",
      "title": "Discover hidden gems. \n",
      "text": "Find nearby restaurants and bakeries and \n more offering unsold food at friendly prices."
    },
    {
      "image": "assets/images/onboarding3.png",
      "title": "Make every bite count. \n",
      "text": "Enjoy great food while making a positive \n impact on your community"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: onboardingData.length + 1,
        itemBuilder: (context, index) {
          if (index == onboardingData.length) {
            return _buildLastPage();
          } else {
            return _buildOnboardingPage(onboardingData[index], index);
          }
        },
      ),
    );
  }

  Widget _buildOnboardingPage(Map<String, String> data, int index) {
    return Container(
      color: Color(0xFFD6EE8F), // FOND GÉNÉRAL
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: Stack(
              children: [
                Center(
                  child: Image.asset(
                    data["image"]!,
                    width: 330,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    data["title"]!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D5049),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    data["text"]!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF391713),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildProgressIndicator(index),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 133,
                    height: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1D5049),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onPressed: () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text("Next", style: TextStyle(fontSize: 17)),
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


  Widget _buildLastPage() {
    return Container(
      color: Color(0xFFFFFFFF), // Fond global
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              width: double.infinity,
              color: Colors.white, // Fond supérieur
              child: Center(
                child: Image.asset("assets/images/onboarding4.png", width: 300),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFF1D5049),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Tell us who you are !",
                    style: TextStyle(
                      color: Color(0xFFF3E9B5),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 44),
                  SizedBox(
                    width: 160,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF3E9B5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerLoginPage(),
                          ),
                        );
                      },
                      child: Text("Customer", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 160,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF3E9B5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusinessLoginPage(),
                          ),
                        );
                      },
                      child: Text("Business", style: TextStyle(color: Colors.black)),
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



  Widget _buildProgressIndicator(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: 20,
          height: 4,
          decoration: BoxDecoration(
            color: i == index ? Color(0xFF2F6948) : Color(0xFFA6CCA7),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

