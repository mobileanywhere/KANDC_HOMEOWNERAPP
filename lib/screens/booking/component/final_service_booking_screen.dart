import 'dart:io';

import 'package:homeowner/app_theme.dart';
import 'package:homeowner/component/app_common_dialog.dart';
import 'package:homeowner/component/custom_image_picker.dart';
import 'package:homeowner/component/loader_widget.dart';
import 'package:homeowner/main.dart';
import 'package:homeowner/model/booking_amount_model.dart';
import 'package:homeowner/model/package_data_model.dart';
import 'package:homeowner/model/property_model.dart';
import 'package:homeowner/model/service_detail_response.dart';
import 'package:homeowner/screens/auth/property_screen.dart';
import 'package:homeowner/screens/booking/component/coupon_widget.dart';
import 'package:homeowner/screens/dashboard/dashboard_screen.dart';
import 'package:homeowner/screens/map/map_screen.dart';
import 'package:homeowner/services/location_service.dart';
import 'package:homeowner/utils/booking_calculations_logic.dart';
import 'package:homeowner/utils/colors.dart';
import 'package:homeowner/utils/common.dart';
import 'package:homeowner/utils/constant.dart';
import 'package:homeowner/utils/images.dart';
import 'package:homeowner/utils/permissions.dart';
import 'package:homeowner/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../network/rest_apis.dart';

class FinalServiceBookingScreen extends StatefulWidget {
  final ServiceDetailResponse data;
  final bool? isSlotAvailable;
  final BookingPackage? selectedPackage;
  final int? typeId;
  final int? subTypeId;
  final int? categoryId;
  final int? subCategoryId;
  final bool isExist;

  const FinalServiceBookingScreen(
      {super.key, required this.data,
      this.isSlotAvailable,
      required this.selectedPackage,
      this.typeId,
      this.subTypeId,
      this.categoryId,
      this.subCategoryId,
      this.isExist = false});

  @override
  _FinalServiceBookingScreenState createState() =>
      _FinalServiceBookingScreenState();
}

class _FinalServiceBookingScreenState extends State<FinalServiceBookingScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  PropertyData? selectedPropertyData;

  TextEditingController dateTimeCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();
  TextEditingController summaryController = TextEditingController();
  FocusNode summaryFocusNode = FocusNode();

  DateTime currentDateTime = DateTime.now();
  DateTime? selectedDate;
  DateTime? finalDate;
  TimeOfDay? pickedTime;
  bool isButtonClicked = false;
  bool isNowButtonClicked = true;

  BookingAmountModel bookingAmountModel = BookingAmountModel();
  num advancePaymentAmount = 0;
  CouponData? appliedCouponData;
  int itemCount = 1;

  UniqueKey uniqueKey = UniqueKey();

  List<File> imageFiles = [];
  List<Attachments> tempAttachments = [];
  List<PropertyData> propertiesList = [];

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (widget.data.serviceDetail!.dateTimeVal != null) {
      if (widget.isSlotAvailable.validate()) {
        dateTimeCont.text = formatDate(
            widget.data.serviceDetail!.dateTimeVal.validate(),
            format: DATE_FORMAT_1);
        selectedDate =
            DateTime.parse(widget.data.serviceDetail!.dateTimeVal.validate());
        pickedTime = TimeOfDay.fromDateTime(selectedDate!);
      }
      addressCont.text = widget.data.serviceDetail!.address.validate();
    }
    getProperties();
    setCurrentDateWithAdditional2Hours();

    setPrice();
  }

  // void selectDateAndTime(BuildContext context) async {
  //   await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate ?? currentDateTime,
  //     firstDate: currentDateTime,
  //     lastDate: currentDateTime.add(30.days),
  //     locale: Locale(appStore.selectedLanguageCode),
  //     cancelText: language.lblCancel,
  //     confirmText: language.lblOk,
  //     helpText: language.lblSelectDate,
  //     builder: (_, child) {
  //       return Theme(
  //         data: appStore.isDarkMode ? ThemeData.dark() : AppTheme.lightTheme(),
  //         child: child!,
  //       );
  //     },
  //   ).then((date) async {
  //     if (date != null) {
  //       await showTimePicker(
  //         context: context,
  //         initialTime: pickedTime ?? TimeOfDay.now(),
  //         cancelText: language.lblCancel,
  //         confirmText: language.lblOk,
  //         builder: (_, child) {
  //           return Theme(
  //             data: appStore.isDarkMode
  //                 ? ThemeData.dark()
  //                 : AppTheme.lightTheme(),
  //             child: child!,
  //           );
  //         },
  //       ).then((time) {
  //         if (time != null) {
  //           finalDate = DateTime(
  //               date.year, date.month, date.day, time.hour, time.minute);

  //           DateTime now = DateTime.now().subtract(1.minutes);
  //           if (date.isToday &&
  //               finalDate!.millisecondsSinceEpoch <
  //                   now.millisecondsSinceEpoch) {
  //             return toast(language.selectedOtherBookingTime);
  //           }

  //           selectedDate = date;
  //           pickedTime = time;
  //           widget.data.serviceDetail!.dateTimeVal = finalDate.toString();
  //           dateTimeCont.text =
  //               "${formatDate(selectedDate.toString(), format: DATE_FORMAT_3)} ${pickedTime!.format(context).toString()}";

  //           setState(() {
  //             isNowButtonClicked = false;
  //             isButtonClicked = true;
  //           });
  //         }
  //       }).catchError((e) {
  //         toast(e.toString());
  //       });
  //     }
  //   });
  // }

  bool showTimeOptions = false;
  String? selectedPeriod;

  void selectDateAndTime(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: selectedDate ?? currentDateTime,
      firstDate: currentDateTime,
      lastDate: currentDateTime.add(30.days),
      locale: Locale(appStore.selectedLanguageCode),
      cancelText: language.lblCancel,
      confirmText: language.lblOk,
      helpText: language.lblSelectDate,
      builder: (_, child) {
        return Theme(
          data: appStore.isDarkMode ? ThemeData.dark() : AppTheme.lightTheme(),
          child: child!,
        );
      },
    ).then((date) {
      if (date != null) {
        setState(() {
          selectedDate = date;
          // Set the selected date in the UI
          dateTimeCont.text =
              formatDate(selectedDate.toString(), format: DATE_FORMAT_3);

          // Close the calendar and show the radio buttons instead of showing the time picker.
          showTimeOptions = true; // A boolean to show/hide the radio buttons
          isButtonClicked =
              true; // Set to true to reflect the schedule button has been clicked.
          isNowButtonClicked = false;
        });
      }
    });
  }

// Helper function to get time based on selected period (Morning, Mid, Afternoon)
  void setTimeBasedOnPeriod(String period) {
    switch (period) {
      case 'Morning':
        pickedTime = TimeOfDay(hour: 9, minute: 0);
        break;
      case 'Mid':
        pickedTime = TimeOfDay(hour: 12, minute: 0);
        break;
      case 'Afternoon':
        pickedTime = TimeOfDay(hour: 15, minute: 0);
        break;
    }

    // Combine date and time
    finalDate = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      pickedTime!.hour,
      pickedTime!.minute,
    );

    // Update the text controller to show the selected date and time
    dateTimeCont.text =
        "${formatDate(selectedDate.toString(), format: DATE_FORMAT_3)} ${pickedTime!.format(context)}";

    // Hide the time options once a period is selected
    setState(() {
      showTimeOptions = true;
    });
  }

  void setCurrentDateWithAdditional2Hours() {
    final DateTime newDateTime = currentDateTime.add(Duration(hours: 2));

    selectedDate = newDateTime;
    pickedTime = TimeOfDay.fromDateTime(newDateTime);
    finalDate = newDateTime;
    widget.data.serviceDetail!.dateTimeVal = finalDate.toString();

    dateTimeCont.text =
        "${formatDate(selectedDate.toString(), format: DATE_FORMAT_3)} ${pickedTime!.format(context).toString()}";
    setState(() {});
  }

  void _handleSetLocationClick() {
    Permissions.cameraFilesAndLocationPermissionsGranted().then((value) async {
      await setValue(PERMISSION_STATUS, value);

      if (value) {
        String? res = await MapScreen(
                latitude: getDoubleAsync(LATITUDE),
                latLong: getDoubleAsync(LONGITUDE))
            .launch(context);

        if (res != null) {
          addressCont.text = res;
          setState(() {});
        }
      }
    });
  }

  void _handleCurrentLocationClick() {
    Permissions.cameraFilesAndLocationPermissionsGranted().then((value) async {
      await setValue(PERMISSION_STATUS, value);

      if (value) {
        appStore.setLoading(true);

        await getUserLocation().then((value) {
          addressCont.text = value;
          widget.data.serviceDetail!.address = value.toString();
          setState(() {});
        }).catchError((e) {
          log(e);
          toast(e.toString());
        });

        appStore.setLoading(false);
      }
    }).catchError((e) {
      //
    });
  }

  void setPrice() {
    bookingAmountModel = finalCalculations(
      servicePrice: widget.data.serviceDetail!.price.validate(),
      appliedCouponData: appliedCouponData,
      discount: widget.data.serviceDetail!.discount.validate(),
      taxes: widget.data.taxes,
      quantity: itemCount,
      selectedPackage: widget.selectedPackage,
    );

    if (bookingAmountModel.finalGrandTotalAmount.isNegative) {
      appliedCouponData = null;
      setPrice();

      toast("This coupon can't be applied");
    } else {
      advancePaymentAmount = (bookingAmountModel.finalGrandTotalAmount *
          (widget.data.serviceDetail!.advancePaymentPercentage.validate() / 100)
              .toStringAsFixed(DECIMAL_POINT)
              .toDouble());
    }
    setState(() {});
  }

  void applyCoupon() async {
    var value = await showInDialog(
      context,
      backgroundColor: context.cardColor,
      contentPadding: EdgeInsets.zero,
      builder: (p0) {
        return AppCommonDialog(
          title: language.lblAvailableCoupons,
          child: CouponWidget(
            couponData: widget.data.couponData.validate(),
            appliedCouponData: appliedCouponData,
          ),
        );
      },
    );

    if (value != null) {
      if (value is bool && !value) {
        appliedCouponData = null;
      } else if (value is CouponData) {
        appliedCouponData = value;
      } else {
        appliedCouponData = null;
      }
      setPrice();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void getProperties() async {
    try {
      var res = await getAllProperties({'customer_id': appStore.userId});
      propertiesList.clear();
      propertiesList.addAll(res);
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 24, right: 16, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.height,
                Text(language.lblStepper1Title,
                    style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                20.height,
                Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Container(
                    decoration: boxDecorationDefault(color: context.cardColor),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.isSlotAvailable.validate(value: true))
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language.lblDateAndTime,
                                  style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                              8.height,
                              SizedBox(
                                width: context.width() * 0.89,
                                height: context.height() * 0.05,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setCurrentDateWithAdditional2Hours();
                                          setState(() {
                                            isNowButtonClicked = true;
                                            isButtonClicked = false;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: isNowButtonClicked
                                                  ? primaryColor
                                                  : null,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                              boxShadow: defaultBoxShadow(
                                                  blurRadius: 0,
                                                  spreadRadius: 0)),
                                          padding: EdgeInsets.all(10),
                                          child: Center(
                                              child: Text(
                                            'Now',
                                            style: TextStyle(
                                                color: isNowButtonClicked
                                                    ? white
                                                    : null),
                                          )),
                                        ),
                                      ),
                                    ),
                                    20.width,
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          selectDateAndTime(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: isButtonClicked
                                                  ? primaryColor
                                                  : null,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                              boxShadow: defaultBoxShadow(
                                                  blurRadius: 0,
                                                  spreadRadius: 0)),
                                          padding: EdgeInsets.all(10),
                                          child: Center(
                                              child: Text(
                                            'Schedule',
                                            style: TextStyle(
                                              color: isButtonClicked
                                                  ? white
                                                  : null,
                                            ),
                                          )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (selectedDate != null && !isNowButtonClicked)
                                16.height,
                              if (selectedDate != null && !isNowButtonClicked)
                                AppTextField(
                                  textFieldType: TextFieldType.OTHER,
                                  controller: dateTimeCont,
                                  isValidationRequired: true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return language.requiredText;
                                    }
                                    return null;
                                  },
                                  readOnly: true,
                                  onTap: () {
                                    selectDateAndTime(context);
                                  },
                                  decoration: inputDecoration(context,
                                          prefixIcon: ic_calendar
                                              .iconImage(size: 10)
                                              .paddingAll(14))
                                      .copyWith(
                                    fillColor: context.scaffoldBackgroundColor,
                                    filled: true,
                                    hintText: language.chooseDateAndTime,
                                    hintStyle: secondaryTextStyle(),
                                  ),
                                ),
                              20.height,
                              if (selectedDate != null && showTimeOptions) ...[
                                16.height,
                                Text("Select Time Period",
                                    style:
                                        boldTextStyle(size: LABEL_TEXT_SIZE)),
                                Column(
                                  children: [
                                    RadioListTile<String>(
                                      title: Text('Morning'),
                                      value: 'Morning',
                                      groupValue:
                                          selectedPeriod, // A string variable holding the selected period
                                      onChanged: (value) {
                                        setState(() {
                                          selectedPeriod = value!;
                                          setTimeBasedOnPeriod(
                                              selectedPeriod ?? 'Morning');
                                        });
                                      },
                                    ),
                                    RadioListTile<String>(
                                      title: Text('Mid'),
                                      value: 'Mid',
                                      groupValue: selectedPeriod,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedPeriod = value!;
                                          setTimeBasedOnPeriod(
                                              selectedPeriod ?? 'Mid');
                                        });
                                      },
                                    ),
                                    RadioListTile<String>(
                                      title: Text('Afternoon'),
                                      value: 'Afternoon',
                                      groupValue: selectedPeriod,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedPeriod = value!;
                                          setTimeBasedOnPeriod(
                                              selectedPeriod ?? 'Afternoon');
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                16.height,
                              ]
                            ],
                          ),
                        if (appStore.isLoggedIn)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Property',
                                  style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                              8.height,
                              GestureDetector(
                                onTap: () async {
                                  await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              PropertyScreen()))
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                                child: Container(
                                  width: context.width(),
                                  height: 45,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: selectedPropertyData == null
                                          ? primaryColor
                                          : context.scaffoldBackgroundColor),
                                  child: Align(
                                    alignment: selectedPropertyData == null
                                        ? Alignment.center
                                        : Alignment.centerLeft,
                                    child: Text(
                                      appStore.selectedPropertyAddress.isEmpty
                                          ? 'Add Property'
                                          : appStore.selectedPropertyAddress,
                                      style: secondaryTextStyle(
                                        size: 14,
                                        color: selectedPropertyData == null
                                            ? white
                                            : grey,
                                      ),
                                    ).paddingSymmetric(horizontal: 12),
                                  ),
                                ).paddingOnly(bottom: 12),
                              ),
                            ],
                          ),
                        Visibility(
                          visible: false,
                          child: Text(language.lblYourAddress,
                              style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                        ),
                        Visibility(
                          visible: false,
                          child: AppTextField(
                            textFieldType: TextFieldType.MULTILINE,
                            // controller: addressCont,
                            maxLines: 1,
                            onFieldSubmitted: (s) {
                              // widget.data.serviceDetail!.address = s;
                            },
                            initialValue: appStore.address,
                            enabled: false,
                            decoration: inputDecoration(
                              context,
                              prefixIcon: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ic_location
                                      .iconImage(size: 22)
                                      .paddingOnly(top: 8),
                                ],
                              ),
                            ).copyWith(
                              fillColor: context.scaffoldBackgroundColor,
                              filled: true,
                              // hintText: language.lblEnterYourAddress,
                              hintStyle: secondaryTextStyle(),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                child: Text(language.lblChooseFromMap,
                                    style: boldTextStyle(
                                        color: primaryColor, size: 13)),
                                onPressed: () {
                                  _handleSetLocationClick();
                                },
                              ).flexible(),
                              TextButton(
                                onPressed: _handleCurrentLocationClick,
                                child: Text(language.lblUseCurrentLocation,
                                    style: boldTextStyle(
                                        color: primaryColor, size: 13),
                                    textAlign: TextAlign.right),
                              ).flexible(),
                            ],
                          ),
                        ),
                        8.height,
                        Text("Summary *",
                            style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                        8.height,
                        AppTextField(
                          textFieldType: TextFieldType.MULTILINE,
                          controller: summaryController,
                          maxLines: 10,
                          minLines: 4,
                          maxLength: 100,
                          isValidationRequired: true,
                          onFieldSubmitted: (s) {},
                          focus: summaryFocusNode,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Summary should not be empty.';
                            }
                            return null;
                          },
                          decoration: inputDecoration(context).copyWith(
                            fillColor: context.scaffoldBackgroundColor,
                            filled: true,
                            hintText: 'Enter Summary',
                            hintStyle: secondaryTextStyle(),
                          ),
                        ),
                        8.height,
                        Text("Comments:",
                            style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                        8.height,
                        AppTextField(
                          textFieldType: TextFieldType.MULTILINE,
                          controller: descriptionCont,
                          maxLines: 10,
                          minLines: 4,
                          isValidationRequired: false,
                          onFieldSubmitted: (s) {
                            widget.data.serviceDetail!.bookingDescription = s;
                          },
                          decoration: inputDecoration(context).copyWith(
                            fillColor: context.scaffoldBackgroundColor,
                            filled: true,
                            hintText: 'Enter Comments',
                            hintStyle: secondaryTextStyle(),
                          ),
                        ),
                        16.height,
                        CustomImagePicker(
                          key: uniqueKey,
                          onRemoveClick: (value) {
                            if (tempAttachments.validate().isNotEmpty &&
                                imageFiles.isNotEmpty) {
                              showConfirmDialogCustom(
                                context,
                                dialogType: DialogType.DELETE,
                                positiveText: 'Delete',
                                negativeText: 'Cancel',
                                onAccept: (p0) {
                                  imageFiles.removeWhere(
                                      (element) => element.path == value);
                                  // removeAttachment(id: tempAttachments.validate().firstWhere((element) => element.url == value).id.validate());
                                },
                              );
                            } else {
                              showConfirmDialogCustom(
                                context,
                                dialogType: DialogType.DELETE,
                                positiveText: 'Delete',
                                negativeText: 'Cancel',
                                onAccept: (p0) {
                                  imageFiles.removeWhere(
                                      (element) => element.path == value);
                                  if (isUpdate) {
                                    uniqueKey = UniqueKey();
                                  }
                                  setState(() {});
                                },
                              );
                            }
                          },
                          selectedImages: widget.data == false
                              ? imageFiles
                                  .validate()
                                  .map((e) => e.path.validate())
                                  .toList()
                              : null,
                          onFileSelected: (List<File> files) async {
                            imageFiles = files;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                16.height,
              ],
            ).onTap(() {
              FocusManager.instance.primaryFocus?.unfocus();
            }),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // if (!widget.isSlotAvailable.validate())
                //   AppButton(
                //     shapeBorder: RoundedRectangleBorder(
                //         borderRadius: radius(),
                //         side: BorderSide(color: context.primaryColor)),
                //     onTap: () {
                //       customStepperController.previousPage(
                //           duration: 200.milliseconds, curve: Curves.easeInOut);
                //     },
                //     text: language.lblPrevious,
                //     textColor: textPrimaryColorGlobal,
                //   ).expand(),
                // if (!widget.isSlotAvailable.validate()) 16.width,
                AppButton(
                  onTap: () async {
                    hideKeyboard(context);
                    if (formKey.currentState!.validate()) {
                      doIfLoggedIn(context, () async {
                        if (appStore.selectedPropertyAddress.isNotEmpty) {
                          await bookServices(); // Directly call the booking service
                        } else {
                          toast('Please select property.');
                          await Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => PropertyScreen()))
                              .then((value) {
                            setState(() {});
                          });
                        }
                      });
                    } else {
                      return;
                    }
                  },
                  text: (!appStore.isLoggedIn) ? 'Sign In' : 'Submit',
                  textColor: Colors.white,
                  width: context.width(),
                  color: context.primaryColor,
                ).expand(),
              ],
            ),
          ),
          Observer(
              builder: (context) => LoaderWidget().visible(appStore.isLoading))
        ],
      ),
    );
  }

  Future<void> bookServices() async {
    Map<String, dynamic> request;
    if (widget.isExist) {
      // Build the request payload similar to how it was done in the ConfirmBookingDialog.
      request = {
        'type_id': widget.typeId.toString(),
        'subtype_id': 0, // widget.subTypeId ?? 0,// Skipped the subtypeid because of this subtype screen is not coming now eg. home interior/exterior
        'category_id': widget.categoryId ?? 0,
        'subcategory_id': widget.subCategoryId ?? 0,
        'service_id': widget.data.serviceDetail!.id.toString(),
        'property_id': appStore.selectedPropertyAddressId.validate(),
        'provider_id': widget.data.provider!.id.validate().toString(),
        'customer_id': appStore.userId.toString(),
        'description': descriptionCont.text.toString(),
        'address': appStore.selectedPropertyAddress.validate(),
        'date': currentDateTime.toUtc().toString(), // Example of using date
        'amount': widget.data.serviceDetail!.price,
        'quantity': itemCount.toString(),
        'total_amount': bookingAmountModel.finalGrandTotalAmount.toString(),
        'coupon_id': appliedCouponData?.code ?? '',
        'attachment_count': imageFiles.length.toString(),
        'summary': summaryController.text.toString(),
        // Add other relevant fields as per your requirements
      };
    } else {
      // Build the request payload similar to how it was done in the ConfirmBookingDialog.
      request = {
        'service_id': widget.data.serviceDetail!.id.toString(),
        'property_id': appStore.selectedPropertyAddressId.validate(),
        'provider_id': widget.data.provider!.id.validate().toString(),
        'customer_id': appStore.userId.toString(),
        'description': descriptionCont.text.toString(),
        'address': appStore.selectedPropertyAddress.validate(),
        'date': currentDateTime.toUtc().toString(), // Example of using date
        'amount': widget.data.serviceDetail!.price,
        'quantity': itemCount.toString(),
        'total_amount': bookingAmountModel.finalGrandTotalAmount.toString(),
        'coupon_id': appliedCouponData?.code ?? '',
        'attachment_count': imageFiles.length.toString(),
        'summary': summaryController.text.toString(),
        // Add other relevant fields as per your requirements
      };
    }

    // If there's an applied booking model, append that to the request.
    request.addAll(bookingAmountModel.toJson());
  
    appStore.setLoading(true);

    try {
      // Call the API and handle success and error
      final response = await saveBooking(request, imageFile: imageFiles);
      appStore.setLoading(false);

      // Navigate to the dashboard or other screens based on response
      DashboardScreen(redirectToBooking: true).launch(context,
          isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
    } catch (e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    }
  }
}
