import 'package:homeowner/main.dart';
import 'package:homeowner/model/dashboard_model.dart';
import 'package:homeowner/model/main_types_model.dart';
import 'package:homeowner/network/rest_apis.dart';
import 'package:homeowner/screens/auth/property_screen.dart';
import 'package:homeowner/screens/dashboard/component/type_component.dart';
import 'package:homeowner/screens/dashboard/component/slider_and_location_component.dart';
import 'package:homeowner/screens/dashboard/shimmer/dashboard_shimmer.dart';
import 'package:homeowner/utils/colors.dart';
import 'package:homeowner/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/empty_error_state_widget.dart';
import '../../../component/loader_widget.dart';
import '../component/booking_confirmed_component.dart';
import '../component/new_job_request_component.dart';

class DashboardFragment extends StatefulWidget {
  @override
  _DashboardFragmentState createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends State<DashboardFragment> {
  Future<DashboardResponse>? future;
  List<MainTypesData> mainTypesList = [];

  @override
  void initState() {
    super.initState();
    init();

    setStatusBarColor(primaryColor, delayInMilliSeconds: 800);

    LiveStream().on(LIVESTREAM_UPDATE_DASHBOARD, (p0) {
      init();
      setState(() {});
    });
  }

  void init() async {
    future = userDashboard(
        isCurrentLocation: appStore.isCurrentLocation,
        lat: getDoubleAsync(LATITUDE),
        long: getDoubleAsync(LONGITUDE));
    globalServiceResponse = await getAllServices();
    getTypes();
  }

  Future<void> getTypes() async {
    await getMainTypes().then((value) {
      mainTypesList = value;
      setState(() {});
    }).catchError((e) {
      log(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    LiveStream().dispose(LIVESTREAM_UPDATE_DASHBOARD);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: (appStore.selectedPropertyAddress.isEmpty)
            ? null
            : appBarWidget(
                'K&C Services',
                textColor: white,
                showBack: false,
                titleWidget: Row(
                  children: [
                    // SvgPicture.asset(
                    //   "assets/icons/KandC-logo-dark.svg",
                    //   width: 50,
                    // ),
                    // 13.width,
                    GestureDetector(
                      onTap: () async {
                        await Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => PropertyScreen()))
                            .then((value) {
                          setState(() {});
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_city_outlined,
                              color: white,
                            ),
                            8.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Text(
                                      '${appStore.selectedPropertyName}',
                                      overflow: TextOverflow.ellipsis,
                                      style: primaryTextStyle(
                                          size: 16, color: white),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Text(
                                      appStore.selectedPropertyAddress,
                                      overflow: TextOverflow.ellipsis,
                                      style: primaryTextStyle(
                                          size: 11, color: white),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    // 13.width,
                    // Text(
                    //   appStore.selectedPropertyName, // 'K&C Services',
                    //   style: primaryTextStyle(
                    //       size: 20, weight: FontWeight.bold, color: white),
                    // )
                  ],
                ),
                textSize: APP_BAR_TEXT_SIZE,
                elevation: 3.0,
                color: context.primaryColor,
                // actions: [
                //   if (appStore.isLoggedIn)
                //     Container(
                //       margin: EdgeInsets.only(right: 16),
                //       decoration: boxDecorationDefault(
                //           color: context.cardColor, shape: BoxShape.circle),
                //       height: 36,
                //       padding: EdgeInsets.all(8),
                //       width: 36,
                //       child: Stack(
                //         clipBehavior: Clip.none,
                //         children: [
                //           ic_notification
                //               .iconImage(size: 24, color: primaryColor)
                //               .center(),
                //           Observer(builder: (context) {
                //             return Positioned(
                //               top: -20,
                //               right: -10,
                //               child: appStore.unreadCount.validate() > 0
                //                   ? Container(
                //                       padding: EdgeInsets.all(4),
                //                       child: FittedBox(
                //                         child: Text(appStore.unreadCount.toString(),
                //                             style: primaryTextStyle(
                //                                 size: 12, color: Colors.white)),
                //                       ),
                //                       decoration: boxDecorationDefault(
                //                           color: Colors.red, shape: BoxShape.circle),
                //                     )
                //                   : Offstage(),
                //             );
                //           })
                //         ],
                //       ),
                //     ).onTap(() {
                //       NotificationScreen().launch(context);
                //     })
                // ]
              ),
        body: Stack(
          children: [
            SnapHelperWidget<DashboardResponse>(
              initialData: cachedDashboardResponse,
              future: future,
              errorBuilder: (error) {
                return NoDataWidget(
                  title: error,
                  imageWidget: ErrorStateWidget(),
                  retryText: language.reload,
                  onRetry: () {
                    appStore.setLoading(true);
                    init();

                    setState(() {});
                  },
                );
              },
              loadingWidget: DashboardShimmer(),
              onSuccess: (snap) {
                return AnimatedScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  listAnimationType: ListAnimationType.FadeIn,
                  fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                  onSwipeRefresh: () async {
                    appStore.setLoading(true);

                    init();
                    setState(() {});

                    return await 2.seconds.delay;
                  },
                  children: [
                    SliderLocationComponent(
                      sliderList: snap.slider.validate(),
                      callback: () async {
                        appStore.setLoading(true);

                        init();
                        setState(() {});
                      },
                    ),

                    // TypeComponent(categoryList: snap.category.validate()),
                    // 16.height,
                    // FeaturedServiceListComponent(serviceList: snap.featuredServices.validate()),
                    // ServiceListComponent(serviceList: snap.service.validate()),

                    TypeComponent(categoryList: mainTypesList),
                    if (snap.upcomingData != null &&
                        snap.upcomingData!.isNotEmpty)
                      30.height,
                    PendingBookingComponent(upcomingData: snap.upcomingData),
                    if (snap.upcomingData == null || snap.upcomingData!.isEmpty)
                      12.height,
                    // 12.height,
                    Visibility(visible: false, child: NewJobRequestComponent()),
                  ],
                );
              },
            ),
            Observer(
                builder: (context) =>
                    LoaderWidget().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
