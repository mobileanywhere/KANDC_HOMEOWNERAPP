import 'package:homeowner/component/back_widget.dart';
import 'package:homeowner/component/base_scaffold_body.dart';
import 'package:homeowner/main.dart';
import 'package:homeowner/screens/auth/property_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/constant.dart';

class AppScaffold extends StatelessWidget {
  final String? appBarTitle;
  final bool showBack;
  final List<Widget>? actions;

  final Widget child;
  final Color? scaffoldBackgroundColor;
  final Widget? bottomNavigationBar;
  final bool showLoader;

  AppScaffold({
    this.appBarTitle,
    required this.child,
    this.actions,
    this.scaffoldBackgroundColor,
    this.bottomNavigationBar,
    this.showLoader = true,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitle != null
          ? appBarWidget(
              appBarTitle.validate(),
              titleWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    appBarTitle.validate(),
                    style: boldTextStyle(color: white, size: APP_BAR_TEXT_SIZE),
                  ),
                  if (appStore.selectedPropertyAddressId != '')
                    Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 14,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                        ),
                        Text(
                          appStore.selectedPropertyName,
                          style: TextStyle(color: white, fontSize: 12),
                        ),
                      ],
                    ).onTap(() async {
                      await Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => PropertyScreen()))
                          .then((v) {});
                    }),
                ],
              ),
              textColor: white,
              showBack: showBack,
              textSize: APP_BAR_TEXT_SIZE,
              elevation: 0.0,
              color: context.primaryColor,
              backWidget: BackWidget(),
              actions: actions,
            )
          : null,
      backgroundColor: scaffoldBackgroundColor,
      body: Body(child: child, showLoader: showLoader),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
