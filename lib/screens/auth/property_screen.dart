import 'package:homeowner/component/loader_widget.dart';
import 'package:homeowner/model/property_model.dart';
import 'package:homeowner/network/rest_apis.dart';
import 'package:homeowner/screens/auth/add_property_screen.dart';
import 'package:homeowner/screens/dashboard/dashboard_screen.dart';
import 'package:homeowner/utils/colors.dart';
import 'package:homeowner/utils/images.dart';
import 'package:homeowner/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/back_widget.dart';
import '../../main.dart';
import '../../utils/constant.dart';

class PropertyScreen extends StatefulWidget {
  final bool fromRequestService;
  final bool isFromLogin;
  final bool isFromSignup;
  const PropertyScreen(
      {super.key,
      this.fromRequestService = false,
      this.isFromLogin = false,
      this.isFromSignup = false});

  @override
  State<PropertyScreen> createState() => _PropertyScreenState();
}

class _PropertyScreenState extends State<PropertyScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.isFromLogin) {}
    getAllProperties({'customer_id': appStore.userId});
  }

  Widget subscriptionContainer({
    required String planTitle,
    required String planDescription,
    required double price,
    required String planId,
  }) {
    return Container(
      width: context.width(),
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Color(0xffB5AB9F),
        border: Border.all(color: Color(0xffB5AB9F)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text(
                    planTitle,
                    textAlign: TextAlign.left,
                    style: secondaryTextStyle(
                        color: white, weight: FontWeight.bold, size: 18),
                  ).center(),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    planDescription,
                    textAlign: TextAlign.left,
                    style: secondaryTextStyle(
                        color: white, size: 14, weight: FontWeight.bold),
                  ).center(),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Rs. ${price.toStringAsFixed(2)}',
                    style: secondaryTextStyle(
                        color: white, weight: FontWeight.bold, size: 15),
                  ).center(),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
            AppButton(
              width: context.width(),
              onTap: () async {
                Navigator.of(context).pop();
              },
              text: 'Okay',
              color: white,
              textColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Properties',
          backWidget: widget.isFromLogin
              ? null
              : BackWidget(
                  iconColor: white,
                  onPressed: () {
                    if (widget.fromRequestService) {
                      Navigator.pop(context, true);
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                ),
          textSize: APP_BAR_TEXT_SIZE,
          elevation: 0,
          color: primaryColor,
          textColor: white,
          systemUiOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness:
                  appStore.isDarkMode ? Brightness.light : Brightness.dark,
              statusBarColor: context.scaffoldBackgroundColor),
          actions: [
            GestureDetector(
              onTap: () async {
                var result = await AddPropertyScreen(
                  fromProfile: true,
                ).launch(context);
                if (result) {
                  setState(() {});
                }
              },
              child: Container(
                  decoration: boxDecorationDefault(color: white),
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: primaryColor,
                      ),
                      5.width,
                      Text(
                        'Add Property',
                        style: primaryTextStyle(
                            color: primaryColor, weight: FontWeight.bold),
                      ),
                    ],
                  )),
            ),
          ]),
      body: FutureBuilder<List<PropertyData>>(
          future: getAllProperties({'customer_id': appStore.userId}),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoaderWidget();
            }
            if (snapshot.data!.isEmpty) {
              return Center(child: Text('No Data Found'));
            }
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      PropertyData? property = snapshot.data?[index];
                      appStore.setSelectedPropertyName(property?.name ?? '');
                      appStore
                          .setSelectedPropertyAddress(property?.address ?? '');
                      appStore.setSelectedPropertyAddressId(
                          '${property?.id ?? ''}');
                      setState(() {});
                      if (widget.isFromLogin) {
                        Navigator.of(context).pop();
                      } else if (widget.isFromSignup) {
                        DashboardScreen().launch(context, isNewTask: true);
                      }
                    },
                    tileColor: appStore.selectedPropertyAddressId ==
                            '${snapshot.data?[index].id}'
                        ? Colors.green.withOpacity(0.1)
                        : null,
                    leading: Text(
                      '${index + 1}.',
                      style: primaryTextStyle(size: 16),
                    ),
                    title: Text(
                      '${snapshot.data?[index].name} ${(snapshot.data?[index].size == null || snapshot.data?[index].size == '') ? '' : '(Square Ft. ${snapshot.data?[index].size})'}',
                      style: primaryTextStyle(
                          color: primaryColor, weight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Address: ${snapshot.data?[index].address}',
                          style: primaryTextStyle(color: grey),
                        ),
                        if (snapshot.data?[index].isSubscription == 1)
                          GestureDetector(
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Plan Information'),
                                    content: subscriptionContainer(
                                        planTitle: snapshot.data?[index]
                                                .subscriptionData?.title ??
                                            'No Plan',
                                        planDescription: snapshot
                                                .data?[index]
                                                .subscriptionData
                                                ?.description ??
                                            'No Description',
                                        price: (snapshot.data?[index]
                                                    .subscriptionData?.amount ??
                                                0)
                                            .toDouble(),
                                        planId:
                                            '${snapshot.data?[index].subscriptionData?.id ?? ''}'),
                                  );
                                },
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Subscribed',
                                  style: primaryTextStyle(
                                      size: 12, color: greenColor),
                                ),
                                8.width,
                                ic_info.iconImage(size: 16, color: black)
                              ],
                            ),
                          ),
                      ],
                    ),
                    trailing: Container(
                      width: MediaQuery.of(context).size.width * 0.14,
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: [
                          appStore.selectedPropertyAddressId ==
                                  '${snapshot.data?[index].id}'
                              ? ic_confirm_check.iconImage(
                                  size: 16, color: greenColor)
                              : SizedBox(
                                  width: 16,
                                  height: 16,
                                ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          GestureDetector(
                              onTap: () async {
                                var result = await AddPropertyScreen(
                                  fromProfile: true,
                                  propertyData: snapshot.data?[index],
                                ).launch(context);
                                if (result) {
                                  setState(() {});
                                }
                              },
                              child: ic_edit_square.iconImage(
                                  size: 20, color: grey)),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
