import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:google_fonts/google_fonts.dart';

PageViewModel viewOne() {
  return PageViewModel(
    // titleWidget: Text("title widget"),
    useScrollView: true,
    decoration: const PageDecoration(
      footerFit: FlexFit.tight,
      fullScreen: true,
      // pageColor: Colors.red,
      imageFlex: 2,
      titlePadding: EdgeInsets.only(
        top: 30,
      ),
      bodyPadding: EdgeInsets.only(
        top: 30,
      ),
    ),
    title: "Selamat Datang di Tim Kasir",
    body: "Welcome to the app! This is a description of how it works.",
    image: Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  // color: Colors.amber,
                  height: 25,
                  width: 25,
                  child: Image.asset(
                    'assets/images/logo/logoTimKasir.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  "Tim Kasir",
                  style: GoogleFonts.lato(
                    // textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 450,
              width: double.infinity,
              // color: Colors.amber,
              child: Image.asset(
                'assets/images/kasir2.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
