import 'package:homeowner/component/back_widget.dart';
import 'package:homeowner/component/empty_error_state_widget.dart';
import 'package:homeowner/main.dart';
import 'package:homeowner/model/package_data_model.dart';
import 'package:homeowner/model/service_detail_response.dart';
import 'package:homeowner/network/rest_apis.dart';
import 'package:homeowner/screens/booking/component/final_service_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BookServiceScreen extends StatefulWidget {
  final ServiceDetailResponse? data;
  final int bookingAddressId;
  final int serviceId;
  final BookingPackage? selectedPackage;
  final int? typeId;
  // final int? subTypeId;
  final int? categoryId;
  final int? subCategoryId;
  final bool isExists;

  const BookServiceScreen(
      {super.key, this.data,
      required this.serviceId,
      this.bookingAddressId = 0,
      this.selectedPackage,
      this.typeId,
      // this.subTypeId,
      this.categoryId,
      this.subCategoryId,
      this.isExists = false});

  @override
  _BookServiceScreenState createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  List<CustomStep>? stepsList;

  Future<ServiceDetailResponse>? future;

  int selectedAddressId = 0;
  int selectedBookingAddressId = -1;
  BookingPackage? selectedPackage;

  @override
  void initState() {
    super.initState();

    debugPrint(
        'BookingServiceIds -------> TypeId: ${widget.typeId}, SubTypeId: {widget.subTypeId}, CategoryId: ${widget.categoryId}, SubCategoryId: ${widget.subCategoryId}');

    init();
  }

  void init() async {
    future = getServiceDetails(
        serviceId: widget.serviceId.validate(),
        categoryId: widget.categoryId,
        subcategoryId: widget.subCategoryId,
        customerId: appStore.userId);
    // stepsList = [
    //   CustomStep(
    //     title: widget.data.serviceDetail!.isSlotAvailable ? language.lblStep2 : language.lblStep1,
    //     page: FinalServiceBookingScreen(
    //       data: widget.data,
    //       isSlotAvailable: !widget.data.serviceDetail!.isSlotAvailable,
    //     ),
    //   ),
    //   CustomStep(
    //     title: widget.data.serviceDetail!.isSlotAvailable ? language.lblStep3 : language.lblStep2,
    //     page: BookingServiceStep3(data: widget.data, selectedPackage: widget.selectedPackage != null ? widget.selectedPackage : null),
    //   ),
    // ];

    // if (widget.data.serviceDetail!.isSlotAvailable) {
    //   stepsList!.insert(0, CustomStep(title: language.lblStep1, page: BookingServiceStep1(data: widget.data)));
    // }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        'Request Service',
        textColor: Colors.white,
        color: context.primaryColor,
        backWidget: BackWidget(),
      ),
      body: SnapHelperWidget(
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
        onSuccess: (snap) => FinalServiceBookingScreen(
          data: snap,
          isSlotAvailable: !snap.serviceDetail!.isSlotAvailable,
          selectedPackage:
              widget.selectedPackage,
          typeId: widget.typeId,
          // subTypeId: widget.subTypeId,
          categoryId: widget.categoryId,
          subCategoryId: widget.subCategoryId,
          isExist: widget.isExists,
        ),

        //  Container(
        //   child: Column(
        //     children: [
        //       CustomStepper(stepsList: stepsList.validate()).expand(),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}

class CustomStep {
  final String title;
  final Widget page;

  CustomStep({required this.title, required this.page});
}
