import 'dart:io';

import 'package:homeowner/component/loader_widget.dart';
import 'package:homeowner/main.dart';
import 'package:homeowner/model/package_data_model.dart';
import 'package:homeowner/model/service_detail_response.dart';
import 'package:homeowner/network/rest_apis.dart';
import 'package:homeowner/screens/dashboard/dashboard_screen.dart';
import 'package:homeowner/utils/colors.dart';
import 'package:homeowner/utils/images.dart';
import 'package:homeowner/utils/model_keys.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/booking_amount_model.dart';
import '../../../utils/common.dart';
import '../../../utils/configs.dart';
import '../../../utils/constant.dart';

class ConfirmBookingDialog extends StatefulWidget {
  final List<File> imagesFile;
  final ServiceDetailResponse data;
  final num? bookingPrice;
  final int qty;
  final String? couponCode;
  final BookingPackage? selectedPackage;
  final BookingAmountModel? bookingAmountModel;

  const ConfirmBookingDialog(
      {super.key, required this.imagesFile,
      required this.data,
      required this.bookingPrice,
      this.qty = 1,
      this.couponCode,
      this.selectedPackage,
      this.bookingAmountModel});

  @override
  State<ConfirmBookingDialog> createState() => _ConfirmBookingDialogState();
}

class _ConfirmBookingDialogState extends State<ConfirmBookingDialog> {
  Map? selectedPackage;
  List<int> selectedService = [];

  bool isSelected = false;
  String serviceId = "";

  Future<void> bookServices() async {
    if (widget.selectedPackage != null) {
      if (widget.selectedPackage!.serviceList != null) {
        for (var element in widget.selectedPackage!.serviceList!) {
          selectedService.add(element.id.validate());
        }

        for (var i in selectedService) {
          if (i == selectedService.last) {
            serviceId = serviceId + i.toString();
          } else {
            serviceId = "$serviceId$i,";
          }
        }
      }

      selectedPackage = {
        PackageKey.packageId: widget.selectedPackage!.id.validate(),
        PackageKey.categoryId: widget.selectedPackage!.categoryId != -1
            ? widget.selectedPackage!.categoryId.validate()
            : null,
        PackageKey.name: widget.selectedPackage!.name.validate(),
        PackageKey.price: widget.selectedPackage!.price.validate(),
        PackageKey.serviceId: serviceId,
        PackageKey.startDate: widget.selectedPackage!.startDate.validate(),
        PackageKey.endDate: widget.selectedPackage!.endDate.validate(),
        PackageKey.isFeatured:
            widget.selectedPackage!.isFeatured == 1 ? '1' : '0',
        PackageKey.packageType: widget.selectedPackage!.packageType.validate(),
      };
    }

    log("selectedPackage: ${[selectedPackage]}");

    // Convert the string to a DateTime object
    DateTime originalDateTime =
        DateTime.parse(widget.data.serviceDetail!.dateTimeVal.validate());

    Map request = {
      'service_id': widget.data.serviceDetail!.id.toString(),
      'property_id': appStore.selectedPropertyAddressId.validate(),
      'provider_id': widget.data.provider!.id.validate().toString(),
      'customer_id': appStore.userId.toString().toString(),
      'description':
          widget.data.serviceDetail!.bookingDescription.validate().toString(),
      'address': appStore.selectedPropertyAddress.validate().toString(),
      'date': originalDateTime.toUtc(),
      'amount': widget.data.serviceDetail!.price,
      'quantity': '${widget.qty}',
      'total_amount':
          widget.bookingPrice.validate().toStringAsFixed(DECIMAL_POINT),
      'coupon_id': widget.couponCode.validate(),
      'attachment_count': widget.imagesFile.length.toString(),
      'type_id': typeId,
      'subtype_id': subTypeId,
    };

    if (widget.bookingAmountModel != null) {
      request.addAll(widget.bookingAmountModel!.toJson());
    }

    if (widget.data.serviceDetail!.isSlotAvailable) {
      request.putIfAbsent('booking_date',
          () => widget.data.serviceDetail!.bookingDate.validate().toString());
      request.putIfAbsent('booking_slot',
          () => widget.data.serviceDetail!.bookingSlot.validate().toString());
      request.putIfAbsent('booking_day',
          () => widget.data.serviceDetail!.bookingDay.validate().toString());
    }

    if (widget.data.taxes.validate().isNotEmpty) {
      request.putIfAbsent('tax', () => widget.data.taxes);
    }
    if (widget.data.serviceDetail != null &&
        widget.data.serviceDetail!.isAdvancePayment) {
      request.putIfAbsent(
          CommonKeys.status, () => BookingStatusKeys.waitingAdvancedPayment);
    }

    appStore.setLoading(true);

    saveBooking(request,
            imageFile: widget.imagesFile
                .where((element) => !element.path.contains('http'))
                .toList())
        .then((bookingDetailResponse) async {
      appStore.setLoading(false);

      // if (widget.data.serviceDetail != null &&
      //     widget.data.serviceDetail!.isAdvancePayment) {
      //   finish(context);
      //   finish(context);
      //   PaymentScreen(
      //           bookings: bookingDetailResponse, isForAdvancePayment: true)
      //       .launch(context);
      // } else {
      finish(context);
      finish(context);
      // showInDialog(
      //   context,
      //   builder: (BuildContext context) => BookingConfirmationDialog(
      //     data: widget.data,
      //     bookingId: bookingDetailResponse.bookingDetail!.id,
      //     bookingPrice: widget.bookingPrice,
      //     selectedPackage: widget.selectedPackage,
      //     bookingDetailResponse: bookingDetailResponse,
      //   ),
      //   backgroundColor: transparentColor,
      //   contentPadding: EdgeInsets.zero,
      // );
      DashboardScreen(redirectToBooking: true).launch(context,
          isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      // }
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return SizedBox(
          width: context.width(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(ic_confirm_check,
                  height: 100, width: 100, color: primaryColor),
              24.height,
              Text(language.lblConfirmBooking, style: boldTextStyle(size: 20)),
              16.height,
              Text(language.lblConfirmMsg,
                  style: primaryTextStyle(), textAlign: TextAlign.center),
              16.height,
              ExcludeSemantics(
                child: CheckboxListTile(
                  checkboxShape:
                      RoundedRectangleBorder(borderRadius: radius(4)),
                  autofocus: false,
                  activeColor: context.primaryColor,
                  checkColor: appStore.isDarkMode
                      ? context.iconColor
                      : context.cardColor,
                  value: isSelected,
                  onChanged: (val) async {
                    isSelected = !isSelected;
                    setState(() {});
                  },
                  title: RichTextWidget(
                    list: [
                      TextSpan(
                          text: '${language.lblAgree} ',
                          style: secondaryTextStyle(size: 14)),
                      TextSpan(
                        text: language.lblTermsOfService,
                        style: boldTextStyle(color: primaryColor, size: 14),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            commonLaunchUrl(TERMS_CONDITION_URL,
                                launchMode: LaunchMode.externalApplication);
                          },
                      ),
                      TextSpan(text: ' & ', style: secondaryTextStyle()),
                      TextSpan(
                        text: language.privacyPolicy,
                        style: boldTextStyle(color: primaryColor, size: 14),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            commonLaunchUrl(PRIVACY_POLICY_URL,
                                launchMode: LaunchMode.externalApplication);
                          },
                      ),
                    ],
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              32.height,
              Row(
                children: [
                  AppButton(
                    onTap: () {
                      finish(context);
                    },
                    text: language.lblCancel,
                    textColor: textPrimaryColorGlobal,
                  ).expand(),
                  16.width,
                  AppButton(
                    text: language.confirm,
                    textColor: Colors.white,
                    color: context.primaryColor,
                    onTap: () {
                      if (isSelected) {
                        bookServices();
                      } else {
                        toast(language.termsConditionsAccept);
                      }
                    },
                  ).expand(),
                ],
              )
            ],
          ).visible(
            !appStore.isLoading,
            defaultWidget: LoaderWidget().withSize(width: 250, height: 280),
          ),
        );
      },
    );
  }
}
