import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:kasirsql/views/page_landing/page1.dart';
import 'package:kasirsql/views/page_landing/page2.dart';
import 'package:kasirsql/views/page_landing/page3.dart';
import 'package:kasirsql/views/page_landing/page4.dart';

class MainLanding extends StatelessWidget {
  const MainLanding({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        viewOne(),
        viewTwo(),
        viewThree(),
        viewFour(),
      ],
      onDone: () {
        Get.offNamed('/halaman_login');
      },
      showNextButton: true,
      next: const Icon(Icons.arrow_forward),
      showSkipButton: true,
      skip: const Text("Skip"),
      done: const Text("Selesai"),
      dotsDecorator: DotsDecorator(
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
