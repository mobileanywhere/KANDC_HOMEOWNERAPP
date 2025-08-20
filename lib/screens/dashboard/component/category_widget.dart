import 'package:homeowner/component/cached_image_widget.dart';
import 'package:homeowner/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryData categoryData;
  final double? width;
  final bool? isFromCategory;
  final bool? isOdd;

  const CategoryWidget(
      {super.key, required this.categoryData,
      this.width,
      this.isFromCategory,
      this.isOdd});

  @override
  Widget build(BuildContext context) {
    // return SizedBox(
    //   width: width ?? context.width() / 4 - 24,
    //   child: Column(
    //     children: [
    //       categoryData.categoryImage.validate().endsWith('.svg')
    //           ? Container(
    //               width: CATEGORY_ICON_SIZE,
    //               height: CATEGORY_ICON_SIZE,
    //               padding: EdgeInsets.all(8),
    //               decoration: BoxDecoration(color: context.cardColor, shape: BoxShape.circle),
    //               child: SvgPicture.network(
    //                 categoryData.categoryImage.validate(),
    //                 height: CATEGORY_ICON_SIZE,
    //                 width: CATEGORY_ICON_SIZE,
    //                 color: appStore.isDarkMode ? Colors.white : categoryData.color.validate(value: '000').toColor(),
    //                 placeholderBuilder: (context) => PlaceHolderWidget(
    //                   height: CATEGORY_ICON_SIZE,
    //                   width: CATEGORY_ICON_SIZE,
    //                   color: transparentColor,
    //                 ),
    //               ).paddingAll(10),
    //             )
    //           : Container(
    //               padding: EdgeInsets.all(14),
    //               decoration: BoxDecoration(color: appStore.isDarkMode ? Colors.white24 : context.cardColor, shape: BoxShape.circle),
    //               child: CachedImageWidget(
    //                 url: categoryData.categoryImage.validate(),
    //                 fit: BoxFit.cover,
    //                 width: 40,
    //                 height: 40,
    //                 circle: true,
    //                 placeHolderImage: '',
    //               ),
    //             ),
    //       4.height,
    //       Marquee(
    //         directionMarguee: DirectionMarguee.oneDirection,
    //         child: Text(
    //           '${categoryData.name.validate()}',
    //           style: primaryTextStyle(size: 12),
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    // return Stack(
    //   children: [
    //     Container(
    //       height: 150.0,
    //       width: context.width() * 0.89,
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.all(Radius.circular(15)),
    //         image: DecorationImage(
    //           image: AssetImage(
    //               '${categoryData.categoryImage}'), // Replace with your image path
    //           fit: BoxFit.cover,
    //         ),
    //       ),
    //     ),
    //     Container(
    //       height: 150.0,
    //       width: context.width() * 0.89,
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.all(Radius.circular(15)),
    //         color:
    //             Colors.black.withOpacity(0.5), // Adjust the opacity as needed
    //       ),
    //     ),
    //     Positioned.fill(
    //       child: Center(
    //         child: Text(
    //           '${categoryData.name}',
    //           style: TextStyle(
    //             color: Colors.white,
    //             fontSize: 24.0,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );

    return Container(
      margin: EdgeInsets.all(5),
      width: context.width() * 0.87,
      height: context.height() * 0.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        color: white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: isOdd == true
            ? [
                Container(
                  width: context.width() * 0.32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12)),
                    color: Color(0xffefefef),
                  ),
                  child: Center(
                    child: categoryData.categoryImage
                            .validate()
                            .endsWith('.svg')
                        ? SvgPicture.network(
                            categoryData.categoryImage.validate(),
                            height: 50,
                            width: 50,
                            placeholderBuilder: (context) => PlaceHolderWidget(
                              height: 50,
                              width: 50,
                              color: transparentColor,
                            ),
                          )
                        : CachedImageWidget(
                            url: categoryData.categoryImage.validate(),
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                            placeHolderImage: '',
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        categoryData.name.toString(),
                        textAlign: TextAlign.center,
                        style:
                            primaryTextStyle(size: 18, weight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ]
            : [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        categoryData.name.toString(),
                        textAlign: TextAlign.center,
                        style:
                            primaryTextStyle(size: 18, weight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: context.width() * 0.32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                    color: Color(0xffefefef),
                  ),
                  child: Center(
                    child: categoryData.categoryImage
                            .validate()
                            .endsWith('.svg')
                        ? SvgPicture.network(
                            categoryData.categoryImage.validate(),
                            height: 50,
                            width: 50,
                            placeholderBuilder: (context) => PlaceHolderWidget(
                              height: 50,
                              width: 50,
                              color: transparentColor,
                            ),
                          )
                        : CachedImageWidget(
                            url: categoryData.categoryImage.validate(),
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                            placeHolderImage: '',
                          ),
                  ),
                ),
              ],
      ),
    );
  }
}

// return Container(
//       width: context.width() * 0.89,
//       height: context.height() * 0.32,
//       decoration: BoxDecoration(
//         color: redColor,
//         borderRadius: BorderRadius.all(
//           Radius.circular(10),
//         ),
//       ),
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//             child: Image.asset(
//               categoryData.categoryImage.validate().toString(),
//               fit: BoxFit.cover,
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             child: Container(
//               width: context.width() * 0.89,
//               padding: EdgeInsets.all(8.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(10),
//                     bottomRight: Radius.circular(10)),
//                 color: Colors.black.withOpacity(0.8),
//               ),
//               child: Text(
//                 categoryData.name.toString(),
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
