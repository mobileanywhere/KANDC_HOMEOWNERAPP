import 'package:homeowner/main.dart';
import 'package:homeowner/model/main_types_model.dart';
import 'package:homeowner/screens/booking/book_service_screen.dart';
import 'package:homeowner/screens/dashboard/component/sub_category_component.dart';
import 'package:homeowner/screens/service/sub_types_screen.dart';
import 'package:homeowner/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class TypeComponent extends StatefulWidget {
  final List<MainTypesData>? categoryList;

  TypeComponent({this.categoryList});

  @override
  CategoryComponentState createState() => CategoryComponentState();
}

class CategoryComponentState extends State<TypeComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categoryList.validate().isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ViewAllLabel(
        //   label: language.category,
        //   list: widget.categoryList!,
        //   onTap: () {
        //     CategoryScreen().launch(context).then((value) {
        //       setStatusBarColor(Colors.transparent);
        //     });
        //   },
        // ).paddingSymmetric(horizontal: 16),
        Text(
          'Welcome${appStore.userLastName == '' ? ' Homeowner' : ' ${appStore.userLastName} Homeowner'}',
          textAlign: TextAlign.center,
          style: primaryTextStyle(
              size: 20, weight: FontWeight.bold, color: black.withOpacity(0.8)),
        ).paddingOnly(left: 16, right: 16, top: 16).center(),
        Text(
          'Select how may we assist you?',
          textAlign: TextAlign.center,
          style: primaryTextStyle(size: 20, color: black.withOpacity(0.8)),
        ).paddingOnly(left: 16, right: 16, top: 5, bottom: 16).center(),
        // GridView.builder(
        //   shrinkWrap: true,
        //   physics: NeverScrollableScrollPhysics(),
        //   itemCount: widget.categoryList!.length,
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 2,
        //     childAspectRatio: 1.0,
        //   ),
        //   itemBuilder: (context, index) {
        //     MainTypesData data = widget.categoryList![index];
        //     return SubCategoryComponentTwo(
        //       categoryImage: data.typeImage.validate(),
        //       categoryName: '${data.name}',
        //       onTap: () {
        //         ViewAllServiceScreen(
        //                 categoryId: data.id.validate(),
        //                 categoryName: data.name,
        //                 isFromCategory: true)
        //             .launch(context);
        //       },
        //     );
        //   },
        // )
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.categoryList!.length,
            reverse: true,
            itemBuilder: (context, index) {
              MainTypesData data = widget.categoryList![index];
              return SubCategoryComponentTwo(
                isListTypeView: true,
                categoryImage: data.typeImage.validate(),
                categoryName: '${data.name}',
                onTap: () {
                  debugPrint('Type ID: ${data.id}');
                  var exists = data.isExist ?? false;
                  if (exists) {
                    setState(() {
                      typeId = data.id;
                    });
                    SubTypesScreen(
                      typeId: data.id.validate(),
                      categoryName: data.name,
                      isFromCategory: true,
                    ).launch(context);
                  } else {
                    // toastLong('No services available for ${data.name}');
                    BookServiceScreen(
                      serviceId: 57,
                      typeId: data.id,
                      isExists: true,
                    ).launch(context).then((value) {
                      setStatusBarColor(transparentColor);
                    });
                  }
                },
              );
            }),
      ],
    );
  }
}
