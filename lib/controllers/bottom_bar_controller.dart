// controllers\barang\bottom_bar_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBarController extends GetxController {
  var selectedIndex = 2.obs;
  final PageController pageController = PageController(initialPage: 2);

  void onTabTapped(int index) {
    selectedIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void onPageChanged(int index) {
    selectedIndex.value = index;
  }

  void resetToHome() {
    // Cek jika currentIndex bukan 2
    if (selectedIndex.value != 2) {
      // Reset index ke 2
      selectedIndex.value = 2;
      // Gunakan jumpToPage tanpa dispose PageController
      pageController.jumpToPage(2);
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
