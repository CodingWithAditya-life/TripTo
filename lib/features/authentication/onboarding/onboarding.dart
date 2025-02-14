import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tripto/features/authentication/screens/home/home_screen.dart';
import 'package:tripto/features/authentication/screens/signUp/signUp_page.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  isLastPage = index == 2;
                });
              },
              children: [
                buildPage(
                  title: 'Book Your Ride in Seconds!',
                  description:
                  'Find and book your perfect ride effortlessly. Fast, reliable, and convenient auto booking at your fingertips.',
                  image: 'assets/images/triotoSplash.jpg',
                ),
                buildPage(
                  title: 'Safe, Reliable & Affordable',
                  description:
                  'We ensure your safety and comfort with verified drivers and competitive fares.',
                  image: 'assets/images/autoSafety.png',
                ),
                buildPage(
                  title: 'Pay Your Way',
                  description:
                  'Choose from cash, card, or digital wallets. Your convenience, your choice.',
                  image: 'assets/images/payment.png',
                ),
              ],
            ),
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: WormEffect(dotHeight: 10, dotWidth: 10),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: ElevatedButton(
                onPressed: () => _pageController.jumpToPage(2),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
                child: Text('Skip'),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  if (isLastPage) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  } else {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
                child: Text(isLastPage ? "Get Started" : "Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPage({
    required String title,
    required String description,
    required String image,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0),
      child: Column(
        children: [
          Image.asset(
            image,
            width: 250,
            height: 250,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
