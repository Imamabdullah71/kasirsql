// menu_bottom_bar\main_home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class ManageHomePage extends StatelessWidget {
  const ManageHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
        title: Text(
          "Halaman Utama".toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              // color: const Color.fromARGB(255, 229, 135, 246),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color.fromARGB(255, 114, 94, 225),
                width: 2.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 114, 94, 225),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            BootstrapIcons.upc_scan,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Scan",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 114, 94, 225),
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 114, 94, 225),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            Get.toNamed("/transaksi_page");
                          },
                          icon: const Icon(
                            BootstrapIcons.cart3,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Transaksi",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 114, 94, 225),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
