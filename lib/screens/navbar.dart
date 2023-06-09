// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:mental_2_day/screens/heath.dart';
import 'package:mental_2_day/screens/widgets/coolText.dart';

import 'home.dart';

class Navbar extends StatefulWidget {
  @override
  _Navbar createState() => _Navbar();
}

class _Navbar extends State<Navbar> {
  int _currentPage = 0;
  final _pageController = PageController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: const [
          MyHomePage(),
          Heath(),
        ],
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
      ),
      bottomNavigationBar: BottomBar(
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        selectedIndex: _currentPage,
        onTap: (int index) {
          _pageController.jumpToPage(index);
          setState(() => _currentPage = index);
        },
        items: <BottomBarItem>[
          BottomBarItem(
            icon: const Icon(Icons.home),
            title: coolText(
              text: 'Home',
              fontSize: 12,
            ),
            activeColor: Colors.blue,
            activeTitleColor: Colors.blue.shade600,
          ),
          BottomBarItem(
            icon: const Icon(Icons.search),
            title:  coolText(
              text: 'Info',
              fontSize: 11,
            ),
            backgroundColorOpacity: 0.1,
            activeColor: Colors.greenAccent.shade700,
          ),
        ],
      ),
    );
  }
}