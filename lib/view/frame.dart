import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:newhorizontrav/controller/auth/auth_controller.dart';
import 'package:newhorizontrav/controller/frame_controller.dart';
import 'package:newhorizontrav/locale/translation_controller.dart';
import 'package:newhorizontrav/utils/app_consts.dart';
import 'package:newhorizontrav/view/auth/auth.dart';
import 'package:newhorizontrav/view/frame/home.dart';
import 'package:newhorizontrav/view/frame/my_drawer.dart';
import 'package:newhorizontrav/view/frame/search_flight.dart';
import 'package:newhorizontrav/view/settings/settings.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class Frame extends StatefulWidget {
  const Frame({super.key});

  @override
  State<Frame> createState() => _FrameState();
}

class _FrameState extends State<Frame> {
  GetStorage getStorage = GetStorage();

  TranslationController translationController = Get.put( 
    TranslationController(), 
  );
  // MainController mainController = Get.put(MainController()); 
  FrameController frameController = Get.put(FrameController());

  AuthController authController = Get.put(AuthController() );  
  User? user;

  @override
  void initState() {
    super.initState() ;
    user = authController.user;
  }

  // ✅ الشاشات لكل تبويب
  List<Widget> _buildScreens() {  
    return [
      Home(persistentTabController: frameController.persistentTabController), 
      SearchFlight(frameContext: context,
      ),

      const Center(child: Text("Bookings Screen")),
      const Auth(),
      SettingsPage(),
    ];
  }

  // ✅ عناصر الأيقونات
  List<PersistentBottomNavBarItem> _navBarsItems() {
    Color activeColorPrimary = AppConsts.secondaryColor;
    return [
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          AppConsts.logo2,
          width: 24,
          height: 24,
          // color: Colors.black, 
        ),
        inactiveIcon: SvgPicture.asset(
          AppConsts.logoBlack,
          width: 24,
          height: 24,
          color: Colors.grey[400], 
        ),
        title: ("   ${'Home'.tr}"),
        textStyle: TextStyle(
          fontFamily: AppConsts.font,
          fontWeight: FontWeight.normal,
          fontSize: AppConsts.lg,
        ),
        activeColorPrimary: activeColorPrimary,
        inactiveColorPrimary: Colors.grey[400],
        activeColorSecondary: Colors.black, 
      ),

      PersistentBottomNavBarItem(
        icon: const Icon(Icons.search_outlined),
        title: (" ${'Search'.tr}"),
        textStyle: TextStyle(
          fontFamily: AppConsts.font,
          fontWeight: FontWeight.normal,
          fontSize: AppConsts.lg,
        ),
        activeColorPrimary: activeColorPrimary,
        inactiveColorPrimary: Colors.grey[400],
        activeColorSecondary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.flight_takeoff_outlined),
        title: (" ${'Bookings'.tr}"),
        textStyle: TextStyle(
          fontFamily: AppConsts.font,
          fontWeight: FontWeight.normal,
          fontSize: AppConsts.lg,
        ),
        activeColorPrimary: activeColorPrimary,
        inactiveColorPrimary: Colors.grey[400],
        activeColorSecondary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: (" ${'Account'.tr}"),
        textStyle: TextStyle(
          fontFamily: AppConsts.font,
          fontWeight: FontWeight.normal,
          fontSize: AppConsts.lg,
        ),

        activeColorPrimary: activeColorPrimary,
        inactiveColorPrimary: Colors.grey[400],
        activeColorSecondary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings),
        title: (" ${'Settings'.tr}"),
        textStyle: TextStyle(
          fontFamily: AppConsts.font,
          fontWeight: FontWeight.normal,
          fontSize: AppConsts.lg,
        ),

        activeColorPrimary: activeColorPrimary,
        inactiveColorPrimary: Colors.grey[400],
        activeColorSecondary: Colors.black,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
      
        drawer: MyDrawer(persistentTabController: frameController.persistentTabController,),
      
        body: PersistentTabView(
          context,
          backgroundColor: cs.surfaceContainerHighest,
          controller: frameController.persistentTabController,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineToSafeArea: true,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          hideNavigationBarWhenKeyboardAppears: true,
          navBarHeight: 70,
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(0.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
              ),
            ],
          ),
      
          // ✅ النمط المطلوب (Style 10)
          navBarStyle: NavBarStyle.style10,
        ),
      
      ),
    );
  }
}
