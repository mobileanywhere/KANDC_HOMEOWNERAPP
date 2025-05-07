import 'package:homeowner/main.dart';
import 'package:homeowner/screens/auth/sign_in_screen.dart';
import 'package:homeowner/screens/booking/booking_detail_screen.dart';
import 'package:homeowner/screens/dashboard/fragment/booking_fragment.dart';
import 'package:homeowner/screens/dashboard/fragment/dashboard_fragment.dart';
import 'package:homeowner/screens/dashboard/fragment/profile_fragment.dart';
import 'package:homeowner/screens/service/service_detail_screen.dart';
import 'package:homeowner/utils/colors.dart';
import 'package:homeowner/utils/constant.dart';
import 'package:homeowner/utils/images.dart';
import 'package:homeowner/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class DashboardScreen extends StatefulWidget {
  final bool? redirectToBooking;

  DashboardScreen({this.redirectToBooking});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.redirectToBooking.validate(value: false)) {
      currentIndex = 1;
    }

    afterBuildCreated(() async {
      /// Changes System theme when changed
      if (getIntAsync(THEME_MODE_INDEX) == THEME_MODE_SYSTEM) {
        appStore.setDarkMode(context.platformBrightness() == Brightness.dark);
      }

      View.of(context).platformDispatcher.onPlatformBrightnessChanged =
          () async {
        if (getIntAsync(THEME_MODE_INDEX) == THEME_MODE_SYSTEM) {
          appStore.setDarkMode(
              MediaQuery.of(context).platformBrightness == Brightness.light);
        }
      };
    });

    init();
  }

  void init() async {
    if (isMobile) {
      /// Handle Notification click and redirect to that Service & BookDetail screen
      // OneSignal.shared.setNotificationOpenedHandler(
      //     (OSNotificationOpenedResult notification) async {
      //   if (notification.notification.additionalData == null) return;

      //   if (notification.notification.additionalData!.containsKey('id')) {
      //     String? notId =
      //         notification.notification.additionalData!["id"].toString();
      //     if (notId.validate().isNotEmpty) {
      //       BookingDetailScreen(bookingId: notId.toString().toInt())
      //           .launch(context);
      //     }
      //   } else if (notification.notification.additionalData!
      //       .containsKey('service_id')) {
      //     String? notId =
      //         notification.notification.additionalData!["service_id"];
      //     if (notId.validate().isNotEmpty) {
      //       ServiceDetailScreen(serviceId: notId.toInt()).launch(context);
      //     }
      //   } else if (notification.notification.additionalData!
      //       .containsKey('sender_uid')) {
      //     String? notId =
      //         notification.notification.additionalData!["sender_uid"];
      //     if (notId.validate().isNotEmpty) {
      //       currentIndex = 3;
      //       setState(() {});
      //     }
      //   }
      // });
    }

    // await 3.seconds.delay;
    // showForceUpdateDialog(context);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      message: language.lblBackPressMsg,
      child: Scaffold(
        body: [
          DashboardFragment(),
          Observer(
              builder: (context) => appStore.isLoggedIn
                  ? BookingFragment(
                      isRequests: true,
                    )
                  : SignInScreen(isFromDashboard: true)),
          if (appStore.isLoggedIn)
            BookingFragment(
              isRequests: false,
            ),
          // if (appStore.isLoggedIn) NotificationScreen(),
          // CategoryScreen(),
          // Observer(builder: (context) => appStore.isLoggedIn ? ChatListScreen() : SignInScreen(isFromDashboard: true)),
          ProfileFragment(),
        ][currentIndex],
        bottomNavigationBar: Blur(
          blur: 30,
          borderRadius: radius(0),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: context.primaryColor.withOpacity(0.02),
              indicatorColor: context.primaryColor.withOpacity(0.1),
              labelTextStyle:
                  WidgetStateProperty.all(primaryTextStyle(size: 12)),
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: NavigationBar(
              selectedIndex: currentIndex,
              destinations: [
                NavigationDestination(
                  icon: ic_home.iconImage(color: appTextSecondaryColor),
                  selectedIcon: ic_home.iconImage(color: context.primaryColor),
                  label: language.home,
                ),
                NavigationDestination(
                  icon: ic_ticket.iconImage(color: appTextSecondaryColor),
                  selectedIcon:
                      ic_ticket.iconImage(color: context.primaryColor),
                  label: 'Requests',
                ),
                if (appStore.isLoggedIn)
                  NavigationDestination(
                    icon: ic_ticket.iconImage(color: appTextSecondaryColor),
                    selectedIcon:
                        ic_ticket.iconImage(color: context.primaryColor),
                    label: 'Inspections',
                  ),
                // if (appStore.isLoggedIn)
                //   NavigationDestination(
                //     icon:
                //         ic_notification.iconImage(color: appTextSecondaryColor),
                //     selectedIcon:
                //         ic_notification.iconImage(color: context.primaryColor),
                //     label: language.lblNotification,
                //   ),
                // NavigationDestination(
                //   icon: ic_category.iconImage(color: appTextSecondaryColor),
                //   selectedIcon: ic_category.iconImage(color: context.primaryColor),
                //   label: language.category,
                // ),
                // NavigationDestination(
                //   icon: ic_chat.iconImage(color: appTextSecondaryColor),
                //   selectedIcon: ic_chat.iconImage(color: context.primaryColor),
                //   label: language.lblChat,
                // ),
                NavigationDestination(
                  icon: ic_profile2.iconImage(color: appTextSecondaryColor),
                  selectedIcon:
                      ic_profile2.iconImage(color: context.primaryColor),
                  label: language.profile,
                ),
              ],
              onDestinationSelected: (index) {
                currentIndex = index;
                setState(() {});
              },
            ),
          ),
        ),
      ),
    );
  }
}
