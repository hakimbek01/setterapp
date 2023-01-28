import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:setterapp/pages/feed_page.dart';
import 'package:setterapp/pages/products_page.dart';
import 'package:setterapp/pages/profile_page.dart';
import 'package:setterapp/pages/search_page.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  PageController _pageController=PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            _selectedIndex=value;
          });
        },
        children: [
          FeedPage(),
          SearchPage(),
          ProductsPage(),
          ProfilePage()
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        width: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey.shade200,
                color: Colors.black,
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                    iconActiveColor: Colors.white,
                    textStyle: TextStyle(color: Colors.white),
                    activeBorder: Border.all(width: 1,color: Colors.deepOrange),
                    backgroundGradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        tileMode: TileMode.mirror,
                        colors: [
                          Color.fromRGBO(252, 175, 69, .8),
                          Color.fromRGBO(245, 96, 64, .9)
                        ]
                    ),
                  ),
                  GButton(
                    icon: Icons.search,
                    text: 'Search',
                    iconActiveColor: Colors.white,
                    textStyle: TextStyle(color: Colors.white),
                    activeBorder: Border.all(width: 1,color: Colors.deepOrange),
                    backgroundGradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        tileMode: TileMode.mirror,
                        colors: [
                          Color.fromRGBO(252, 175, 69, .8),
                          Color.fromRGBO(245, 96, 64, .9)
                        ]
                    ),
                  ),
                  GButton(
                    text: "Products",
                    icon: Icons.shopping_bag,
                    iconActiveColor: Colors.white,
                    textStyle: TextStyle(color: Colors.white),
                    activeBorder: Border.all(width: 1,color: Colors.deepOrange),
                    backgroundGradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      tileMode: TileMode.mirror,
                      colors: [
                        Color.fromRGBO(252, 175, 69, .8),
                        Color.fromRGBO(245, 96, 64, .9)
                      ]
                    ),
                  ),
                  GButton(
                    text: "Profile",
                    icon: CupertinoIcons.person_crop_circle,
                    iconActiveColor: Colors.white,
                    textStyle: TextStyle(color: Colors.white),
                    activeBorder: Border.all(width: 1,color: Colors.deepOrange),
                    backgroundGradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      tileMode: TileMode.mirror,
                      colors: [
                        Color.fromRGBO(252, 175, 69, .8),
                        Color.fromRGBO(245, 96, 64, .9)
                      ]
                    ),
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                    _pageController.animateToPage(_selectedIndex, duration: Duration(milliseconds: 70), curve: Curves.easeIn);
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}