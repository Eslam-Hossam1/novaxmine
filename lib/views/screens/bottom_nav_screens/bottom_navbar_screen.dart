import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/my_images.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/screens/bottom_nav_screens/home/home_screen.dart';
import 'package:mine_lab/views/screens/bottom_nav_screens/menu/menu_screen.dart';
import 'package:mine_lab/views/screens/bottom_nav_screens/mine/mining_track/mining_tracks_screen.dart';
import 'package:mine_lab/views/screens/bottom_nav_screens/wallet/wallet_screen.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  List<String> iconList = [
    MyImages.home,
    MyImages.wallet,
    MyImages.miningTracks,
    MyImages.category
  ];

  late List<Widget> _widgets;
  late GlobalKey<ScaffoldState> _dashBoardScaffoldKey;
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _dashBoardScaffoldKey = GlobalKey<ScaffoldState>();

    _widgets = <Widget>[
      const HomeScreen(),
      const WalletScreen(),
      const MiningTracksScreen(),
      const MenuScreen(),
    ];
  }

  _onTabChange(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;

    final textList = [
      MyStrings!.home,
      MyStrings.coinWallets,
      MyStrings.miningTracks,
      MyStrings.menu
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: MyColor.primaryColor,
        systemNavigationBarColor: MyColor.colorWhite,
        systemNavigationBarDividerColor: MyColor.colorWhite,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
          key: _dashBoardScaffoldKey,
          // body: IndexedStack(
          //   index: currentIndex,
          //   children: _widgets,
          // ),
          body: _widgets[currentIndex],
          bottomNavigationBar: AnimatedBottomNavigationBar.builder(
            height: 65,
            elevation: 10,
            itemCount: iconList.length,
            tabBuilder: (int index, bool isActive) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    iconList[index],
                    height: 20,
                    width: 20,
                    color: isActive ? MyColor.primaryColor : MyColor.colorGrey,
                  ),
                  const SizedBox(height: Dimensions.space5),
                  Text(textList[index],
                      style: interRegularExtraSmall.copyWith(
                          color: isActive
                              ? MyColor.primaryColor
                              : MyColor.colorGrey))
                ],
              );
            },
            backgroundColor: MyColor.colorWhite,
            gapLocation: GapLocation.none,
            leftCornerRadius: 0,
            rightCornerRadius: 0,
            onTap: (index) {
              _onTabChange(index);
            },
            activeIndex: currentIndex,
          )),
    );
  }
}
