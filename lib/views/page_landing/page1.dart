import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

PageViewModel viewOne() {
  return PageViewModel(
    useScrollView: true,
    decoration: const PageDecoration(
      footerFit: FlexFit.tight,
      fullScreen: true,
      imageFlex: 2,
      titlePadding: EdgeInsets.only(
        top: 30,
      ),
      bodyPadding: EdgeInsets.only(
        top: 30,
      ),
    ),
    title: "Selamat Datang di TransaksiKu",
    body:
        "Aplikasi ini membantu Anda dalam pencatatan transaksi dan stok barang dengan mudah.",
    image: Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                  width: 25,
                ),
                const SizedBox(width: 5),
                Text(
                  "TransaksiKu",
                  style: GoogleFonts.lato(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            SizedBox(
              height: 300,
              width: 300,
              child: Lottie.asset(
                'assets/lotties/welcome1.json',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
