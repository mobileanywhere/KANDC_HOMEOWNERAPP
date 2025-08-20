import 'package:homeowner/component/base_scaffold_widget.dart';
import 'package:homeowner/screens/booking/book_service_screen.dart';
import 'package:homeowner/screens/dashboard/component/sub_category_component.dart';
import 'package:homeowner/screens/service/category_and_services_screen.dart';
import 'package:homeowner/store/filter_store.dart';
import 'package:homeowner/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/empty_error_state_widget.dart';
import '../../main.dart';
import '../../model/category_model.dart';
import '../../model/service_data_model.dart';
import '../../network/rest_apis.dart';
import '../../utils/common.dart';
import '../../utils/images.dart';
import 'component/service_component.dart';

class SubTypesScreen extends StatefulWidget {
  final int? typeId;
  final String? categoryName;
  final String isFeatured;
  final bool isFromProvider;
  final bool isFromCategory;
  final bool isFromSearch;
  final int? providerId;

  const SubTypesScreen({
    this.typeId,
    this.categoryName = '',
    this.isFeatured = '',
    this.isFromProvider = true,
    this.isFromCategory = false,
    this.isFromSearch = false,
    this.providerId,
    super.key,
  });

  @override
  State<SubTypesScreen> createState() => _SubTypesScreenState();
}

class _SubTypesScreenState extends State<SubTypesScreen> {
  Future<List<CategoryData>>? futureCategory;
  List<CategoryData> categoryList = [];

  String globalTextField = '';
  Future<List<ServiceData>>? futureService;
  List<ServiceData> filteredServiceList = [];

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
    await fetchCategoryList();
    filterServices("");
  }

  void filterServices(String searchText) {
    if (searchText.isEmpty) {
      globalTextField = '';
      filteredServiceList = [];
    } else {
      filteredServiceList =
          globalServiceResponse!.serviceList!.where((service) {
        return service.name!.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    }
  }

  Future<void> fetchCategoryList() async {
    var categoryResponse =
        await getCategoryList(id: widget.typeId!, perPage: 'all');
    setState(() {
      categoryList = categoryResponse.categoryList ?? [];
    });
  }

  void fetchAllServiceData() async {
    futureService = searchServiceAPI(
      page: page,
      list: globalServiceResponse!.serviceList!,
      categoryId: widget.typeId != null
          ? widget.typeId.validate().toString()
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
  }

  String get setSearchString {
    if (!widget.categoryName.isEmptyOrNull) {
      return widget.categoryName!;
    } else if (widget.isFeatured == "1") {
      return language.lblFeatured;
    } else {
      return language.allServices;
    }
  }

  Widget gridSubCategoryWidget() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: categoryList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) {
        CategoryData data = categoryList[index];
        return SubCategoryComponentTwo(
          categoryImage: data.categoryImage.toString(),
          categoryName: data.name.toString(),
          crossAxisCount: 3,
          onTap: () {
            var exists = data.isExist ?? false;
            if (exists) {
              CategoryAndServicesScreen(
                typeId: widget.typeId,
                subTypeId: data.id.validate(),
                subTypeName: data.name,
                isFromCategory: true,
              ).launch(context);
            } else {
              // toastLong('No services available for ${data.name}');
              BookServiceScreen(
                isExists: true,
                serviceId: 57,
                typeId: widget.typeId,
                categoryId: data.id.validate(),// subType will work as category because home interior/exterior screen skips
              ).launch(context).then((value) {
                setStatusBarColor(transparentColor);
              });
            }
          },
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
                        filterServices("");
                        setState(() {});
                      },
                    ).visible(searchCont.text.isNotEmpty),
                    onFieldSubmitted: (s) {
                      page = 1;
                      filterStore.setSearch(s);
                      globalTextField = s;
                      filterServices(s);
                      setState(() {});
                    },
                    decoration: inputDecoration(context).copyWith(
                      hintText: "${language.lblSearchFor} $setSearchString",
                      prefixIcon: ic_search.iconImage(size: 10).paddingAll(14),
                      hintStyle: secondaryTextStyle(size: 15),
                    ),
                  ).expand(),
                ],
              ),
            ),
            AnimatedScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              onSwipeRefresh: () {
                page = 1;
                setState(() {});
                return Future.value(false);
              },
              onNextPage: () {
                if (!isLastPage) {
                  page++;
                }
              },
              children: [
                if (!widget.isFromSearch)
                  filteredServiceList.isEmpty
                      ? gridSubCategoryWidget()
                      : Container(),
                16.height,
                if (globalTextField != '' && filteredServiceList.isEmpty)
                  NoDataWidget(
                    title: language.lblNoServicesFound,
                    subTitle: (searchCont.text.isNotEmpty ||
                            filterStore.providerId.isNotEmpty ||
                            filterStore.categoryId.isNotEmpty)
                        ? language.noDataFoundInFilter
                        : null,
                    imageWidget: EmptyStateWidget(),
                  ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedListView(
                      itemCount: filteredServiceList.length,
                      listAnimationType: ListAnimationType.FadeIn,
                      fadeInConfiguration:
                          FadeInConfiguration(duration: 2.seconds),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        return ServiceComponent(
                                serviceData: filteredServiceList[index])
                            .paddingAll(8);
                      },
                    ).paddingAll(8),
                  ],
                )
              ],
            ).expand(),
          ],
        ),
      ),
    );
  }
}
