import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:gallerify/screens/favorite_screen.dart';
import 'package:gallerify/screens/home_screen.dart';
import 'package:gallerify/screens/search_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final _pageController = PageController(initialPage: 0);
  final _controller = NotchBottomBarController(index: 0);

  final List<Widget> _screens = [const HomeScreen(), const SearchScreen(), const FavoriteScreen()];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff01a081),
        title: const Center(child: Text('Wallpaper App', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(_screens.length, (index) => _screens[index]),
      ),
      extendBody: true,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        onTap: (index) => _pageController.jumpToPage(index),
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(Icons.home_filled, color: Colors.blueGrey),
            activeItem: Icon(Icons.home_filled, color: Color(0xff01a081)),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.search, color: Colors.blueGrey),
            activeItem: Icon(Icons.search, color: Color(0xff01a081)),
            itemLabel: 'Search',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.favorite, color: Colors.blueGrey),
            activeItem: Icon(Icons.favorite, color: Color(0xff01a081)),
            itemLabel: 'Favorite',
          ),
        ],
        kIconSize: 22,
        kBottomRadius: 24,
      ),
    );
  }
}
