import 'package:homeowner/component/base_scaffold_widget.dart';
import 'package:homeowner/component/loader_widget.dart';
import 'package:homeowner/screens/booking/book_service_screen.dart';
import 'package:homeowner/store/filter_store.dart';
import 'package:homeowner/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/cached_image_widget.dart';
import '../../component/empty_error_state_widget.dart';
import '../../main.dart';
import '../../model/category_model.dart';
import '../../model/service_data_model.dart';
import '../../network/rest_apis.dart';
import '../../utils/common.dart';
import '../../utils/constant.dart';
import '../../utils/images.dart';
import 'component/service_component.dart';

class CategoryAndServicesScreen extends StatefulWidget {
  final int? typeId;
  final int? subTypeId;
  final String? subTypeName;
  final String isFeatured;
  final bool isFromProvider;
  final bool isFromCategory;
  final int? providerId;

  CategoryAndServicesScreen({
    this.typeId,
    this.subTypeId,
    this.subTypeName = '',
    this.isFeatured = '',
    this.isFromProvider = true,
    this.isFromCategory = false,
    this.providerId,
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryAndServicesScreen> createState() =>
      _CategoryAndServicesScreenState();
}

class _CategoryAndServicesScreenState extends State<CategoryAndServicesScreen> {
  Future<List<CategoryData>>? futureCategory;
  List<CategoryData> categoryList = [];

  Future<List<ServiceData>>? futureService;
  List<ServiceData> serviceList = [];

  FocusNode myFocusNode = FocusNode();
  TextEditingController searchCont = TextEditingController();

  int? subCategory;

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
    filterStore = FilterStore();
  }

  void init() async {
    fetchAllServiceData();

    if (widget.subTypeId != null) {
      fetchCategoryList();
    }
  }

  void fetchCategoryList() async {
    futureCategory = getSubCategoryListAPI(catId: widget.subTypeId!);
  }

  Future<void> fetchAllServiceData() async {
    futureService = searchServiceAPI(
      page: page,
      list: serviceList,
      categoryId: widget.subTypeId != null
          ? widget.subTypeId.validate().toString()
          : filterStore.categoryId.join(','),
      subCategory: subCategory != null ? subCategory.validate().toString() : '',
      providerId: widget.providerId != null
          ? widget.providerId.toString()
          : filterStore.providerId.join(","),
      isPriceMin: filterStore.isPriceMin,
      isPriceMax: filterStore.isPriceMax,
      search: searchCont.text,
      latitude: filterStore.latitude,
      longitude: filterStore.longitude,
      lastPageCallBack: (p0) {
        isLastPage = p0;
      },
      isFeatured: widget.isFeatured,
    );
    await futureService?.then((v) {
      serviceList = v;
      setState(() {});
    });
  }

  String get setSearchString {
    if (!widget.subTypeName.isEmptyOrNull) {
      return widget.subTypeName!;
    } else if (widget.isFeatured == "1") {
      return language.lblFeatured;
    } else {
      return language.allServices;
    }
  }

  Widget subCategoryWidget() {
    return SnapHelperWidget<List<CategoryData>>(
      future: futureCategory,
      initialData: cachedSubcategoryList
          .firstWhere((element) => element?.$1 == widget.subTypeId.validate(),
              orElse: () => null)
          ?.$2,
      loadingWidget: Offstage(),
      onSuccess: (list) {
        if (list.length == 1) return Offstage();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 16.height,
            // Text(language.lblSubcategories,
            //         style: boldTextStyle(size: LABEL_TEXT_SIZE))
            //     .paddingLeft(16),
            HorizontalList(
              itemCount: list.validate().length - 1,
              padding: EdgeInsets.only(left: 16, right: 16),
              runSpacing: 8,
              spacing: 12,
              itemBuilder: (_, adjustedIndex) {
                int index = adjustedIndex + 1;
                CategoryData data = list[index];

                return Observer(
                  builder: (_) {
                    bool isSelected =
                        filterStore.selectedSubCategoryId == index;

                    return GestureDetector(
                      onTap: () async {
                        filterStore.setSelectedSubCategory(catId: index);

                        subCategory = data.id;
                        page = 1;

                        appStore.setLoading(true);
                        await fetchAllServiceData();
                        setState(() {});
                        debugPrint('ServiceList data: ${serviceList.isEmpty}');
                        if (serviceList.isEmpty) {
                          BookServiceScreen(
                            typeId: widget.typeId,
                            serviceId: 57,
                            categoryId: widget.subTypeId,
                            subCategoryId: subCategory,
                            isExists: true,
                          ).launch(context).then((value) {
                            setStatusBarColor(transparentColor);
                          });
                        }
                      },
                      child: SizedBox(
                        width: context.width() / 4 - 20,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Column(
                              children: [
                                16.height,
                                // if (index == 0)
                                //   Container(
                                //     height: CATEGORY_ICON_SIZE,
                                //     width: CATEGORY_ICON_SIZE,
                                //     decoration: BoxDecoration(
                                //         color: context.cardColor,
                                //         shape: BoxShape.circle,
                                //         border: Border.all(color: grey)),
                                //     alignment: Alignment.center,
                                //     child: Text(data.name.validate(),
                                //         style: boldTextStyle(size: 12)),
                                //   ),
                                // if (index != 0)
                                data.categoryImage.validate().endsWith('.svg')
                                    ? Container(
                                        width: CATEGORY_ICON_SIZE,
                                        height: CATEGORY_ICON_SIZE,
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: context.cardColor,
                                            shape: BoxShape.circle),
                                        child: SvgPicture.network(
                                          data.categoryImage.validate(),
                                          height: CATEGORY_ICON_SIZE,
                                          width: CATEGORY_ICON_SIZE,
                                          // ignore: deprecated_member_use
                                          color: appStore.isDarkMode
                                              ? Colors.white
                                              : data.color
                                                  .validate(value: '000')
                                                  .toColor(),
                                          placeholderBuilder: (context) =>
                                              PlaceHolderWidget(
                                                  height: CATEGORY_ICON_SIZE,
                                                  width: CATEGORY_ICON_SIZE,
                                                  color: transparentColor),
                                        ),
                                      )
                                    : Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                            color: context.cardColor,
                                            shape: BoxShape.circle),
                                        child: CachedImageWidget(
                                          url: data.categoryImage.validate(),
                                          fit: BoxFit.fitWidth,
                                          width: SUBCATEGORY_ICON_SIZE,
                                          height: SUBCATEGORY_ICON_SIZE,
                                          circle: true,
                                        ),
                                      ),
                                // 4.height,
                                // if (index == 0)
                                //   Text(language.lblViewAll,
                                //       style: boldTextStyle(size: 12),
                                //       textAlign: TextAlign.center,
                                //       maxLines: 1),
                                // if (index != 0)
                                Marquee(
                                    child: Text('${data.name.validate()}',
                                        style: boldTextStyle(size: 12),
                                        textAlign: TextAlign.center,
                                        maxLines: 1)),
                              ],
                            ),
                            Positioned(
                              top: 14,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: boxDecorationDefault(
                                    color: context.primaryColor),
                                child: Icon(Icons.done,
                                    size: 16, color: Colors.white),
                              ).visible(isSelected),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            16.height,
          ],
        );
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    filterStore.clearFilters();
    myFocusNode.dispose();
    filterStore.setSelectedSubCategory(catId: 0);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: setSearchString,
      child: SizedBox(
        height: context.height(),
        width: context.width(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  AppTextField(
                    textFieldType: TextFieldType.OTHER,
                    focus: myFocusNode,
                    controller: searchCont,
                    suffix: CloseButton(
                      onPressed: () {
                        page = 1;
                        searchCont.clear();
                        filterStore.setSearch('');

                        appStore.setLoading(true);
                        fetchAllServiceData();
                        setState(() {});
                      },
                    ).visible(searchCont.text.isNotEmpty),
                    onFieldSubmitted: (s) {
                      page = 1;

                      filterStore.setSearch(s);
                      appStore.setLoading(true);

                      fetchAllServiceData();
                      setState(() {});
                    },
                    decoration: inputDecoration(context).copyWith(
                      hintText: "${language.lblSearchFor} $setSearchString",
                      prefixIcon: ic_search.iconImage(size: 10).paddingAll(14),
                      hintStyle: secondaryTextStyle(size: 15),
                    ),
                  ).expand(),
                  // 16.width,
                  // Container(
                  //   padding: EdgeInsets.all(10),
                  //   decoration:
                  //       boxDecorationDefault(color: context.primaryColor),
                  //   child: CachedImageWidget(
                  //     url: ic_filter,
                  //     height: 26,
                  //     width: 26,
                  //     color: Colors.white,
                  //   ),
                  // ).onTap(() {
                  //   hideKeyboard(context);

                  //   FilterScreen(
                  //           isFromProvider: widget.isFromProvider,
                  //           isFromCategory: widget.isFromCategory)
                  //       .launch(context)
                  //       .then((value) {
                  //     if (value != null) {
                  //       page = 1;
                  //       appStore.setLoading(true);

                  //       fetchAllServiceData();
                  //       setState(() {});
                  //     }
                  //   });
                  // }, borderRadius: radius())
                ],
              ),
            ),
            AnimatedScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              onSwipeRefresh: () {
                page = 1;

                appStore.setLoading(true);
                fetchAllServiceData();
                setState(() {});

                return Future.value(false);
              },
              onNextPage: () {
                if (!isLastPage) {
                  page++;

                  appStore.setLoading(true);
                  fetchAllServiceData();
                  setState(() {});
                }
              },
              children: [
                if (widget.subTypeId != null) subCategoryWidget(),
                16.height,
                SnapHelperWidget(
                  future: futureService,
                  loadingWidget: LoaderWidget(),
                  errorBuilder: (p0) {
                    return NoDataWidget(
                      title: p0,
                      retryText: language.reload,
                      imageWidget: ErrorStateWidget(),
                      onRetry: () {
                        page = 1;
                        appStore.setLoading(true);

                        fetchAllServiceData();
                        setState(() {});
                      },
                    );
                  },
                  onSuccess: (data) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(language.service,
                                style: boldTextStyle(size: LABEL_TEXT_SIZE))
                            .paddingSymmetric(horizontal: 16),
                        // AnimatedListView(
                        //   itemCount: serviceList.length,
                        //   listAnimationType: ListAnimationType.FadeIn,
                        //   fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                        //   physics: NeverScrollableScrollPhysics(),
                        //   shrinkWrap: true,
                        //   emptyWidget: NoDataWidget(
                        //     title: language.lblNoServicesFound,
                        //     subTitle: (searchCont.text.isNotEmpty || filterStore.providerId.isNotEmpty || filterStore.categoryId.isNotEmpty) ? language.noDataFoundInFilter : null,
                        //     imageWidget: EmptyStateWidget(),
                        //   ),
                        //   itemBuilder: (_, index) {
                        //     return ServiceComponent(serviceData: serviceList[index]).paddingAll(8);
                        //   },
                        // ).paddingAll(8),
                        16.height,
                        Container(
                          margin: EdgeInsets.only(left: 16, right: 16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  3, // Number of elements in a single row
                              crossAxisSpacing:
                                  28, // Horizontal spacing between elements
                              mainAxisSpacing:
                                  8, // Vertical spacing between elements
                            ),
                            itemCount: serviceList
                                .length, // Replace with the actual list length
                            itemBuilder: (BuildContext context, int index) {
                              return ServiceComponent(
                                typeId: widget.typeId,
                                subTypeId: widget.subTypeId,
                                serviceData: serviceList[index],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ).expand(),
          ],
        ),
      ),
    );
  }
}
