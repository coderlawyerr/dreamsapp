import 'package:dream/const/color.dart';
import 'package:dream/wiew/ruya_add_page.dart';
import 'package:dream/wiew/ruya_list_page.dart';
import 'package:dream/wiew/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<BottomBar> {
  final Color navigationBarColor = AppColors.text;
  int selectedIndex = 1;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    /// [AnnotatedRegion<SystemUiOverlayStyle>] only for android black navigation bar. 3 button navigation control (legacy)

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(systemNavigationBarColor: navigationBarColor, systemNavigationBarIconBrightness: Brightness.dark),
      child: Scaffold(
        // backgroundColor: Colors.grey,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: <Widget>[
            const RuyaListPage(), // Sayfa 1
            RuyaChatPage(), // Sayfa 2
            const SettingPage(), // Sayfa 3
          ],
        ),
        bottomNavigationBar: WaterDropNavBar(
          waterDropColor: AppColors.background,
          backgroundColor: navigationBarColor,
          onItemSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
            pageController.animateToPage(selectedIndex, duration: const Duration(milliseconds: 400), curve: Curves.easeOutQuad);
          },
          selectedIndex: selectedIndex,
          barItems: <BarItem>[
            BarItem(filledIcon: Icons.bookmark, outlinedIcon: Icons.bookmark_border_rounded),
            BarItem(filledIcon: Icons.message, outlinedIcon: Icons.message_outlined),
            BarItem(filledIcon: Icons.settings, outlinedIcon: Icons.settings_outlined),
          ],
        ),
      ),
    );
  }
}
