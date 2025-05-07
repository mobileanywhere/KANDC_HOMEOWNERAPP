import 'package:homeowner/component/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SubCategoryComponentTwo extends StatelessWidget {
  final String categoryImage;
  final String categoryName;
  final int crossAxisCount;
  final void Function()? onTap;
  final bool isListTypeView;
  SubCategoryComponentTwo(
      {super.key,
      required this.categoryImage,
      required this.categoryName,
      this.crossAxisCount = 2,
      this.onTap,
      this.isListTypeView = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: !isListTypeView
          ? Container(
              margin: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    crossAxisCount == 2 ? 30.height : 16.height,
                    SizedBox(
                      height: crossAxisCount == 2 ? 50 : 32,
                      width: crossAxisCount == 2 ? 50 : 32,
                      child: CachedImageWidget(
                        url: '$categoryImage',
                        height: crossAxisCount == 2 ? 50 : 32,
                        width: crossAxisCount == 2 ? 50 : 32,
                        fit: BoxFit.fitWidth,
                        placeHolderImage: '',
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '$categoryName',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: crossAxisCount == 2 ? 20 : 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ).paddingOnly(left: 8, right: 8),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              margin: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    12.height,
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: CachedImageWidget(
                        url: '$categoryImage',
                        height: crossAxisCount == 2 ? 50 : 32,
                        width: crossAxisCount == 2 ? 50 : 32,
                        fit: BoxFit.fitWidth,
                        placeHolderImage: '',
                      ),
                    ),
                    12.height,
                    Center(
                      child: Text(
                        '$categoryName',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ).paddingOnly(left: 8, right: 8),
                    ),
                    12.height,
                  ],
                ),
              ),
            ),
    );
  }
}
