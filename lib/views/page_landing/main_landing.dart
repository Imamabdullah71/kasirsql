import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:tim_kasir/Views/landing_pages/page_view_models/page1.dart';
import 'package:tim_kasir/Views/landing_pages/page_view_models/page2.dart';
import 'package:tim_kasir/Views/landing_pages/page_view_models/page3.dart';
import 'package:tim_kasir/Views/landing_pages/page_view_models/page4.dart';

class PageOneL extends StatelessWidget {
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
      next: Icon(Icons.arrow_forward),
      showSkipButton: true,
      skip: Text("Skip"),
      done: Text("Selesai"),
      dotsDecorator: DotsDecorator(
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
