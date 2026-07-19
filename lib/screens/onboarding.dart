import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sehaty/core/appcolors.dart';
import 'package:sehaty/screens/welcome.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../models/model_onboarding.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  bool isLast = false;

  final List<OnboardingModel> pages = const [
    OnboardingModel(
      image: "assets/on1.svg",
      title: "ابحث عن دكتور متخصص",
      description:
          "اكتشف مجموعة واسعة من الأطباء الخبراء والمتخصصين في مختلف المجالات.",
    ),
    OnboardingModel(
      image: "assets/on2.svg",
      title: "سهولة الحجز",
      description: "احجز المواعيد بضغطة زر في أي وقت وفي أي مكان.",
    ),
    OnboardingModel(
      image: "assets/on3.svg",
      title: "آمن وسري",
      description: "كن مطمئنًا لأن خصوصيتك وأمانك هما أهم أولوياتنا.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Welcome()),
                      );
                    },
                    child: const Text(
                      "تخطي",
                      style: TextStyle(color: AppColors.primary, fontSize: 22),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    isLast = (index == pages.length - 1);
                  });
                },
                itemBuilder: (context, index) {
                  final page = pages[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        Expanded(
                          flex: 6,
                          child: SvgPicture.asset(
                            page.image,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 40),

                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Cairo",
                          ),
                        ),

                        const SizedBox(height: 20),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            page.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              height: 1.6,
                              color: Colors.black87,
                              fontFamily: "Cairo",
                            ),
                          ),
                        ),

                        const Spacer(),
                      ],
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 35),
              child: Row(
                children: [
                  if (isLast)
                    SizedBox(
                      width: 180,
                      height: 65,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Welcome()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                        ),
                        child: const Text(
                          "هيا بنا",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontFamily: "Cairo",
                          ),
                        ),
                      ),
                    ),

                  const Spacer(),

                  SmoothPageIndicator(
                    controller: _controller,
                    count: pages.length,
                    effect: WormEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: Colors.grey.shade400,
                      dotHeight: 12,
                      dotWidth: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
