import 'package:homeowner/component/loader_widget.dart';
import 'package:homeowner/main.dart';
import 'package:homeowner/model/booking_data_model.dart';
import 'package:homeowner/model/booking_status_model.dart';
import 'package:homeowner/network/rest_apis.dart';
import 'package:homeowner/screens/auth/property_screen.dart';
import 'package:homeowner/screens/booking/booking_detail_screen.dart';
import 'package:homeowner/screens/booking/component/booking_item_component.dart';
import 'package:homeowner/screens/booking/component/status_dropdown_component.dart';
import 'package:homeowner/screens/booking/shimmer/booking_shimmer.dart';
import 'package:homeowner/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/empty_error_state_widget.dart';

class BookingFragment extends StatefulWidget {
  final bool isRequests;

  BookingFragment({required this.isRequests});

  @override
  _BookingFragmentState createState() => _BookingFragmentState();
}

class _BookingFragmentState extends State<BookingFragment> {
  UniqueKey keyForStatus = UniqueKey();

  ScrollController scrollController = ScrollController();

  Future<List<BookingData>>? future;
  Future<List<BookingData>>? inspactionFuture;
  List<BookingData> bookings = [];
  List<BookingData> inspectionBookings = [];

  int page = 1;
  int inspectionPage = 1;
  bool isLastPage = false;
  bool isLastPageInspection = false;

  String selectedValue = BOOKING_TYPE_ALL;

  @override
  void initState() {
    super.initState();
    init();

    afterBuildCreated(() {
      if (appStore.isLoggedIn) {
        setStatusBarColor(context.primaryColor);
      }
    });

    LiveStream().on(LIVESTREAM_UPDATE_BOOKING_LIST, (p0) {
      page = 1;
      appStore.setLoading(true);
      init();
      setState(() {});
    });
  }

  void init() async {
    if (widget.isRequests) {
      future = getBookingList(page,
          status: selectedValue,
          bookings: bookings,
          customerId: appStore.userId!, lastPageCallback: (b) {
        isLastPage = b;
      });
    } else {
      fetchInspectionList(loading: true);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(LIVESTREAM_UPDATE_BOOKING_LIST);
    //scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchInspectionList({bool loading = true}) async {
    appStore.setLoading(loading);
    var request = {'customer_id': appStore.uid};
    inspactionFuture = getInspectionList(inspectionPage, request,
        status: selectedValue,
        bookings: inspectionBookings, lastPageCallback: (b) {
      isLastPageInspection = b;
    });
    appStore.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        widget.isRequests ? 'Service Requests' : 'Inspections',
        titleWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.isRequests ? 'Service Requests' : 'Inspections',
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
                    .then((v) {
                  setState(() {});
                });
              }),
          ],
        ),
        showBack: false,
        elevation: 3.0,
        color: context.primaryColor,
      ),
      body: SizedBox(
        width: context.width(),
        height: context.height(),
        child: Stack(
          children: [
            (widget.isRequests)
                ? SnapHelperWidget<List<BookingData>>(
                    initialData: cachedBookingList,
                    future: future,
                    errorBuilder: (error) {
                      return NoDataWidget(
                        title: error,
                        imageWidget: ErrorStateWidget(),
                        retryText: language.reload,
                        onRetry: () {
                          keyForStatus = UniqueKey();
                          page = 1;
                          appStore.setLoading(true);

                          init();
                          setState(() {});
                        },
                      );
                    },
                    loadingWidget: BookingShimmer(),
                    onSuccess: (list) {
                      return AnimatedListView(
                        controller: scrollController,
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                            bottom: 60, top: 8, right: 16, left: 16),
                        itemCount: list.length,
                        shrinkWrap: true,
                        listAnimationType: ListAnimationType.FadeIn,
                        fadeInConfiguration:
                            FadeInConfiguration(duration: 2.seconds),
                        slideConfiguration:
                            SlideConfiguration(verticalOffset: 400),
                        emptyWidget: NoDataWidget(
                          title: language.lblNoBookingsFound,
                          subTitle: language.noBookingSubTitle,
                          imageWidget: EmptyStateWidget(),
                        ),
                        itemBuilder: (_, index) {
                          BookingData? data = list[index];

                          return GestureDetector(
                            onTap: () {
                              if (widget.isRequests) {
                                if (data.bookingType == 'plan') {
                                } else {
                                  BookingDetailScreen(
                                          bookingId: data.id.validate())
                                      .launch(context);
                                }
                              } else {}
                            },
                            child: BookingItemComponent(
                              bookingData: data,
                              inspection: false,
                            ),
                          );
                        },
                        onNextPage: () {
                          if (!isLastPage) {
                            page++;
                            appStore.setLoading(true);

                            init();
                            setState(() {});
                          }
                        },
                        onSwipeRefresh: () async {
                          page = 1;
                          appStore.setLoading(true);

                          init();
                          setState(() {});

                          return await 1.seconds.delay;
                        },
                      ).paddingOnly(left: 0, right: 0, bottom: 0, top: 76);
                    },
                  )
                : inspectionWidget(),
            Positioned(
              left: 16,
              right: 16,
              top: 16,
              child: StatusDropdownComponent(
                isValidate: false,
                key: keyForStatus,
                onValueChanged: (BookingStatusResponse value) {
                  selectedValue = value.value.toString();

                  page = 1;
                  appStore.setLoading(true);
                  init();

                  setState(() {});

                  if (bookings.isNotEmpty) {
                    scrollController.animateTo(0,
                        duration: 1.seconds, curve: Curves.easeOutQuart);
                  } else {
                    scrollController = ScrollController();
                  }
                },
              ),
            ),
            Observer(
                builder: (_) => LoaderWidget().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }

  Widget inspectionWidget() {
    return Stack(
      children: [
        SnapHelperWidget<List<BookingData>>(
          initialData: cachedBookingListInspection,
          future: inspactionFuture,
          loadingWidget: BookingShimmer(),
          onSuccess: (inspectionList) {
            return AnimatedListView(
              controller: scrollController,
              onSwipeRefresh: () async {
                inspectionPage = 1;
                await fetchInspectionList(loading: true);
                setState(() {});
                return await 1.seconds.delay;
              },
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              listAnimationType: ListAnimationType.FadeIn,
              fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
              itemCount: inspectionList.length,
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              emptyWidget: NoDataWidget(
                title: 'No Inspection Found',
                subTitle:
                    'Looks like your customer haven\'t book your services yet',
                imageWidget: EmptyStateWidget(),
              ),
              itemBuilder: (_, index) => BookingItemComponent(
                  bookingData: inspectionList[index],

                  // index: index,
                  inspection: !widget.isRequests),
              disposeScrollController: false,
              onNextPage: () {
                if (!isLastPageInspection) {
                  inspectionPage++;
                  appStore.setLoading(true);

                  fetchInspectionList();
                  setState(() {});
                }
              },
            ).paddingOnly(left: 0, right: 0, bottom: 0, top: 10);
          },
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              retryText: 'Reload',
              imageWidget: ErrorStateWidget(),
              onRetry: () {
                keyForStatus = UniqueKey();
                appStore.setLoading(true);
                inspectionPage = 1;

                fetchInspectionList();
                setState(() {});
              },
            );
          },
        ).paddingOnly(top: 66),
        Positioned(
          left: 16,
          right: 16,
          top: 16,
          child: Container(),
          // child: BookingStatusDropdown(
          //   isValidate: false,
          //   statusType: selectedValue,
          //   key: keyForStatus,
          //   onValueChanged: (BookingStatusResponse value) {
          //     // page = 1;
          //     // appStore.setLoading(true);

          //     // selectedValue =
          //     //     value.value.validate(value: BOOKING_PAYMENT_STATUS_ALL);
          //     // fetchAllBookingList(loading: true);
          //     // setState(() {});

          //     // if (bookings.isNotEmpty) {
          //     //   scrollController.animateTo(0,
          //     //       duration: 1.seconds, curve: Curves.easeOutQuart);
          //     // } else {
          //     //   scrollController = ScrollController();
          //     // }
          //   },
          // ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: AppTextField(
          //         textFieldType: TextFieldType.NAME,
          //         isValidationRequired: false,
          //         decoration: inputDecoration(context,
          //             hint: 'Search Inspections', islabelText: false),
          //       ),
          //     ),
          //     8.width,
          //     Container(
          //       width: 45.0,
          //       height: 45.0,
          //       decoration: BoxDecoration(
          //         color: selectedValue == BOOKING_PAYMENT_STATUS_ALL
          //             ? cardColor
          //             : primaryColor,
          //         borderRadius: BorderRadius.circular(8.0),
          //       ),
          //       child: Icon(
          //         Icons.filter_list,
          //         color: selectedValue == BOOKING_PAYMENT_STATUS_ALL
          //             ? black
          //             : white,
          //       ),
          //     ).onTap(() {
          //       _showDialog(context);
          //     }),
          //   ],
          // ),
        ),
        Observer(builder: (_) => LoaderWidget().visible(appStore.isLoading)),
      ],
    );
  }
}
