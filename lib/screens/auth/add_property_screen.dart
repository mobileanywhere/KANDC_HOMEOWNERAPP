import 'package:homeowner/component/back_widget.dart';
import 'package:homeowner/main.dart';
import 'package:homeowner/model/property_model.dart';
import 'package:homeowner/utils/colors.dart';
import 'package:homeowner/utils/common.dart';
import 'package:homeowner/utils/images.dart';
import 'package:homeowner/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/loader_widget.dart';
import '../../model/city_list_model.dart';
import '../../model/state_list_model.dart';
import '../../network/rest_apis.dart';
import '../../utils/constant.dart';
import '../../utils/model_keys.dart';
import '../dashboard/dashboard_screen.dart';

class AddPropertyScreen extends StatefulWidget {
  final bool fromProfile;
  final PropertyData? propertyData;
  const AddPropertyScreen(
      {super.key, this.fromProfile = false, this.propertyData});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController? propertyName;
  TextEditingController? propertyAddress;
  TextEditingController? propertySize;
  TextEditingController? levels;
  TextEditingController? zipCode;
  TextEditingController? bedRooms;
  TextEditingController? gateCode;

  FocusNode focusPropertyName = FocusNode();
  FocusNode focusPropertyAddress = FocusNode();
  FocusNode focusPropertySize = FocusNode();
  FocusNode focusLevels = FocusNode();
  FocusNode focusZipCode = FocusNode();
  FocusNode focusBedRooms = FocusNode();
  FocusNode focusGateCode = FocusNode();

  List<StateListResponse> stateList = [];
  List<CityListResponse> cityList = [];

  StateListResponse? selectedState;
  CityListResponse? selectedCity;

  int stateId = 0;
  int cityId = 0;

  bool pool = false;
  bool dogs = false;

  @override
  void initState() {
    propertyName = TextEditingController(text: widget.propertyData?.name ?? '');
    propertyAddress =
        TextEditingController(text: widget.propertyData?.address ?? '');
    propertySize = TextEditingController(text: widget.propertyData?.size ?? '');
    zipCode = TextEditingController(text: widget.propertyData?.zipCode ?? '');
    bedRooms = TextEditingController(text: widget.propertyData?.bedrooms ?? '');
    levels = TextEditingController(text: widget.propertyData?.levels ?? '');
    gateCode = TextEditingController(text: widget.propertyData?.gateCode ?? '');
    pool = ((widget.propertyData?.pool ?? 0) == 0) ? false : true;
    dogs = ((widget.propertyData?.isDogs ?? 0) == 0) ? false : true;
    super.initState();
    getStates();
  }

  void showState() {
    stateId = widget.propertyData?.stateId ?? 231;
    setState(() {
      selectedState = stateList.firstWhere((element) => element.id == stateId);
    });
    getCity(stateId);
  }

  void showCity() {
    cityId = widget.propertyData?.cityId ?? 0;
    setState(() {
      selectedCity = cityList.firstWhere((element) => element.id == cityId);
    });
  }

  Future<void> getStates() async {
    appStore.setLoading(true);
    Map req = {UserKeys.countryId: 231};
    await getStateList(req).then((value) async {
      stateList.clear();
      stateList.addAll(value);
      log(stateList);
      value.forEach((e) {
        if (e.id == getIntAsync(STATE_ID)) {
          selectedState = e;
        }
      });
      setState(() {});
      if (widget.propertyData != null) showState();
    }).catchError((e) {
      // toast('$e', print: true);
      debugPrint('$e');
    });
    appStore.setLoading(false);
  }

  Future<void> getCity(int stateId) async {
    appStore.setLoading(true);

    await getCityList({UserKeys.stateId: stateId}).then((value) async {
      cityList.clear();
      cityList.addAll(value);
      value.forEach((e) {
        if (e.id == getIntAsync(CITY_ID)) {
          selectedCity = e;
        }
      });
      setState(() {});
      if (widget.propertyData != null) showCity();
    }).catchError((e) {
      // toast('$e', print: true);
      debugPrint('$e');
    });
    appStore.setLoading(false);
  }

  void addUserProperty() async {
    hideKeyboard(context);

    if (appStore.isLoading) return;

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      Map req = {
        'customer_id': appStore.userId,
        'name': propertyName?.text,
        'address': propertyAddress?.text,
        'size': propertySize?.text,
        'state_id': stateId,
        'city_id': cityId,
        'zip_code': zipCode?.text,
        'bedrooms': bedRooms?.text,
        'levels': levels?.text,
        'gate_code': gateCode?.text,
        'pool': pool ? 1 : 0,
        'is_dogs': dogs ? 1 : 0,
      };
      await addProperty(req);
      if (!widget.fromProfile) {
        DashboardScreen().launch(context, isNewTask: true);
      }

      if (widget.fromProfile) {
        Navigator.of(context).pop(true);
      }
    }
  }

  void editUserProperty() async {
    hideKeyboard(context);

    if (appStore.isLoading) return;

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      Map req = {
        'property_id': widget.propertyData?.id,
        'name': propertyName?.text,
        'address': propertyAddress?.text,
        'size': propertySize?.text,
        'state_id': stateId,
        'city_id': cityId,
        'zip_code': zipCode?.text,
        'bedrooms': bedRooms?.text,
        'levels': levels?.text,
        'gate_code': gateCode?.text,
        'pool': pool ? 1 : 0,
        'is_dogs': dogs ? 1 : 0,
      };
      await editProperty(req);

      if (widget.fromProfile) {
        Navigator.of(context).pop(true);
      }
    }
  }

  //region Widget
  Widget _buildTopWidget() {
    return Column(
      children: [
        Text('Add Property', style: boldTextStyle(size: 22)).center(),
        16.height,
        Text(language.lblSignUpSubTitle,
                style: secondaryTextStyle(size: 14),
                textAlign: TextAlign.center)
            .center()
            .paddingSymmetric(horizontal: 32),
      ],
    );
  }

  @override
  void dispose() {
    propertyName?.dispose();
    propertyAddress?.dispose();
    propertySize?.dispose();
    zipCode?.dispose();
    levels?.dispose();
    bedRooms?.dispose();
    gateCode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            widget.fromProfile ? primaryColor : context.scaffoldBackgroundColor,
        leading: widget.fromProfile ? BackWidget() : SizedBox(),
        title: widget.fromProfile
            ? Text(
                widget.propertyData != null ? 'Edit Property' : 'Add Property',
                style: primaryTextStyle(
                    color: white, size: 20, weight: FontWeight.bold),
              )
            : null,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness:
                appStore.isDarkMode ? Brightness.light : Brightness.dark,
            statusBarColor: context.scaffoldBackgroundColor),
      ),
      body: SizedBox(
        width: context.width(),
        child: Stack(
          children: [
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (!widget.fromProfile) _buildTopWidget(),
                    if (!widget.fromProfile) 30.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: propertyName,
                      focus: focusPropertyName,
                      nextFocus: focusPropertyAddress,
                      errorThisFieldRequired: language.requiredText,
                      decoration:
                          inputDecoration(context, labelText: 'Property Name'),
                      suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
                    ),
                    if (stateList.isNotEmpty) 16.height,
                    if (stateList.isNotEmpty)
                      Row(
                        children: [
                          DropdownButtonFormField<StateListResponse>(
                            decoration:
                                inputDecoration(context, labelText: 'State'),
                            isExpanded: true,
                            dropdownColor: context.cardColor,
                            value: selectedState,
                            items: stateList.map((StateListResponse e) {
                              return DropdownMenuItem<StateListResponse>(
                                value: e,
                                child: Text(
                                  e.name!,
                                  style: primaryTextStyle(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (StateListResponse? value) async {
                              hideKeyboard(context);
                              selectedCity = null;
                              selectedState = value;
                              stateId = value!.id!;
                              await getCity(value.id!);
                              setState(() {});
                            },
                          ).expand(),
                          8.width.visible(cityList.isNotEmpty),
                          if (cityList.isNotEmpty)
                            DropdownButtonFormField<CityListResponse>(
                              decoration:
                                  inputDecoration(context, labelText: 'City'),
                              isExpanded: true,
                              value: selectedCity,
                              dropdownColor: context.cardColor,
                              items: cityList.map((CityListResponse e) {
                                return DropdownMenuItem<CityListResponse>(
                                  value: e,
                                  child: Text(e.name!,
                                      style: primaryTextStyle(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                );
                              }).toList(),
                              onChanged: (CityListResponse? value) async {
                                hideKeyboard(context);
                                selectedCity = value;
                                cityId = value!.id!;
                                setState(() {});
                              },
                            ).expand(),
                        ],
                      ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: zipCode,
                      focus: focusZipCode,
                      errorThisFieldRequired: language.requiredText,
                      decoration:
                          inputDecoration(context, labelText: 'Zip Code'),
                      suffix: ic_info.iconImage(size: 10).paddingAll(14),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.MULTILINE,
                      controller: propertyAddress,
                      focus: focusPropertyAddress,
                      nextFocus: focusPropertySize,
                      errorThisFieldRequired: language.requiredText,
                      decoration:
                          inputDecoration(context, labelText: 'Address'),
                      suffix: ic_location.iconImage(size: 10).paddingAll(14),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: propertySize,
                      focus: focusPropertySize,
                      keyboardType: TextInputType.numberWithOptions(),
                      errorThisFieldRequired: language.requiredText,
                      decoration:
                          inputDecoration(context, labelText: 'Square footage'),
                      suffix: ic_info.iconImage(size: 10).paddingAll(14),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: levels,
                      focus: focusLevels,
                      errorThisFieldRequired: language.requiredText,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: inputDecoration(context, labelText: 'Levels'),
                      suffix:
                          ic_slider_status.iconImage(size: 10).paddingAll(14),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: bedRooms,
                      focus: focusBedRooms,
                      errorThisFieldRequired: language.requiredText,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration:
                          inputDecoration(context, labelText: 'Bedrooms'),
                      suffix: ic_category.iconImage(size: 10).paddingAll(14),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: gateCode,
                      focus: focusGateCode,
                      errorThisFieldRequired: language.requiredText,
                      decoration:
                          inputDecoration(context, labelText: 'Gate Code'),
                      suffix: ic_about_us.iconImage(size: 10).paddingAll(14),
                    ),
                    30.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pool (Y/N)',
                          style: primaryTextStyle(weight: FontWeight.bold),
                        ).paddingOnly(left: 6),
                        Switch.adaptive(
                          value: pool,
                          onChanged: (v) {
                            setState(() {
                              pool = v;
                            });
                          },
                        ).withHeight(24),
                      ],
                    ),
                    30.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Is Dogs (Y/N)',
                          style: primaryTextStyle(weight: FontWeight.bold),
                        ).paddingOnly(left: 6),
                        Switch.adaptive(
                          value: dogs,
                          onChanged: (v) {
                            setState(() {
                              dogs = v;
                            });
                          },
                        ).withHeight(24),
                      ],
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            Observer(
                builder: (_) =>
                    LoaderWidget().center().visible(appStore.isLoading)),
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: AppButton(
                text: widget.propertyData != null
                    ? 'Update Property'
                    : 'Add Property',
                color: primaryColor,
                textColor: Colors.white,
                width: context.width() - context.navigationBarHeight,
                onTap: () {
                  if (widget.propertyData != null) {
                    editUserProperty();
                  } else {
                    addUserProperty();
                  }
                },
              ).paddingOnly(left: 16, right: 16),
            )
          ],
        ),
      ),
    );
  }
}
