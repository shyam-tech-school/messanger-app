import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/core/routes/route_name.dart';
import 'package:mail_messanger/features/onboard/presentation/pages/onboard/datasource/onboard_data_source.dart';
import 'package:mail_messanger/features/onboard/presentation/pages/onboard/presentation/widgets/onboard_pages.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final _pageController = PageController();
  int _currentIndex = 0;

  void _next() {
    if (_currentIndex < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.pushNamed(context, RouteName.otpScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1220),
      body: SizedBox(
        height: .maxFinite,
        width: .maxFinite,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: (value) => setState(() => _currentIndex = value),
              itemBuilder: (context, index) =>
                  OnboardPages(onboardData: pages[index]),
            ),

            Positioned(
              bottom: 80,
              left: 16,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentIndex == index ? 22 : 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? ColorConstants.primaryColor
                          : ColorConstants.dotColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 60,
              right: 20,
              child: GestureDetector(
                onTap: _next,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 50,
                  width: _currentIndex == pages.length - 1 ? 180 : 140,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorConstants.primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    _currentIndex == pages.length - 1 ? "Get Started" : "Next",
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'LuckiestGuy',
                      color: ColorConstants.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
