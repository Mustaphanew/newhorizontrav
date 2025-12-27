import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:newhorizontrav/controller/auth/auth_controller.dart';
import 'package:newhorizontrav/utils/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../../utils/app_consts.dart';

class MyDrawer extends StatefulWidget {
  final PersistentTabController? persistentTabController;
  const MyDrawer({super.key, this.persistentTabController});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    AuthController authController = Get.find();
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: cs.primary,
            child: InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                decoration: BoxDecoration(
                  // color: AppConsts.primaryColor,
                ),
                height: 260,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (user != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: SizedBox(height: 80, width: 80, child: CacheImg("${user!.photoURL}")),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "${user!.displayName}",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: cs.onPrimary,
                          fontFamily: AppConsts.font,
                          fontWeight: FontWeight.normal,
                          fontSize: AppConsts.lg,
                        ),
                      ),
                      Text(
                        "${user!.email}",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: cs.onPrimary,
                          fontFamily: AppConsts.font,
                          fontWeight: FontWeight.normal,
                          fontSize: AppConsts.sm,
                        ),
                      ),
                    ],
                    if (user == null) ...[
                      SvgPicture.asset(AppConsts.logo3, width: 60, height: 60),
                      SizedBox(height: 16),
                      SvgPicture.asset(AppConsts.brand, width: 171.92 / 1.65, height: 66 / 1.65),
                    ],
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DrawerItem(
                    icon: SvgPicture.asset(AppConsts.logoBlack, width: 24, height: 24, color: Get.isDarkMode ? Colors.white : Colors.black),
                    title: "Home".tr,
                    onClick: () async {
                      if (widget.persistentTabController != null) {
                        widget.persistentTabController!.jumpToTab(0);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                  DrawerItem(
                    icon: Icon(
                      Icons.search,
                      size: 26,
                      // color: AppConsts.tertiaryColor[800],
                    ),
                    title: "Search".tr,
                    onClick: () async {
                      if (widget.persistentTabController != null) {
                        widget.persistentTabController!.jumpToTab(1);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                  DrawerItem(
                    icon: Icon(
                      Icons.flight_land,
                      size: 26,
                      // color: AppConsts.tertiaryColor[800],
                    ),
                    title: "Bookings".tr,
                    onClick: () async {
                      if (widget.persistentTabController != null) {
                        widget.persistentTabController!.jumpToTab(2);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                  DrawerItem(
                    icon: Icon(
                      Icons.groups_2_outlined,
                      size: 26,
                      // color: AppConsts.tertiaryColor[800],
                    ),
                    title: "About Us".tr,
                    onClick: () async {
                      if (widget.persistentTabController != null) {
                        widget.persistentTabController!.jumpToTab(1);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                  Divider(height: 1),
                  DrawerItem(
                    icon: Icon(
                      Icons.notifications_outlined,
                      size: 26,
                      // color: AppConsts.tertiaryColor[800],
                    ),
                    title: "Notifications".tr,
                    onClick: () async {
                      if (widget.persistentTabController != null) {
                        widget.persistentTabController!.jumpToTab(1);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                  DrawerItem(
                    icon: Icon(
                      Icons.settings_outlined,
                      size: 26,
                      // color: AppConsts.tertiaryColor[800],
                    ),
                    title: "Settings".tr,
                    onClick: () async {
                      if (widget.persistentTabController != null) {
                        widget.persistentTabController!.jumpToTab(4);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            color: Colors.transparent,
            child: SizedBox(
              width: AppConsts.sizeContext(context).width,
              height: 60,
              // color: Colors.red,
              child: TextButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: cs.outline, width: 2),
                  ),
                ),
                onPressed: () async {
                  if (user == null) {
                    if (widget.persistentTabController != null) {
                      widget.persistentTabController!.jumpToTab(3);
                    }
                    Navigator.of(context).pop();
                  } else {
                    authController.signOut();
                  }
                },
                child: Text((user == null) ? "Sign in".tr : "Sign out".tr, style: TextStyle(fontSize: AppConsts.xlg)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final Function()? onClick;

  const DrawerItem({super.key, required this.icon, required this.title, this.onClick});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConsts.sizeContext(context).width,
      height: 70,
      child: TextButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Get.isDarkMode ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
        onPressed: onClick,
        child: Row(
          children: [
            SizedBox(width: 8),
            icon,
            SizedBox(width: 16),
            Text(title, style: TextStyle(fontSize: AppConsts.lg)),
          ],
        ),
      ),
    );
  }
}
