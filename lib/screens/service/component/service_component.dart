import 'package:homeowner/component/cached_image_widget.dart';
import 'package:homeowner/model/package_data_model.dart';
import 'package:homeowner/model/service_data_model.dart';
import 'package:homeowner/screens/booking/book_service_screen.dart';
import 'package:homeowner/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceComponent extends StatefulWidget {
  final ServiceData? serviceData;
  final BookingPackage? selectedPackage;
  final double? width;
  final bool? isBorderEnabled;
  final VoidCallback? onUpdate;
  final bool isFavouriteService;
  final int? typeId;
  final int? subTypeId;

  const ServiceComponent(
      {super.key, this.serviceData,
      this.width,
      this.isBorderEnabled,
      this.isFavouriteService = false,
      this.onUpdate,
      this.selectedPackage,
      this.typeId,
      this.subTypeId});

  @override
  ServiceComponentState createState() => ServiceComponentState();
}

class ServiceComponentState extends State<ServiceComponent> {
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
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
        // ServiceDetailScreen(
        //         service: widget.serviceData,
        //         serviceId: widget.isFavouriteService
        //             ? widget.serviceData!.serviceId.validate().toInt()
        //             : widget.serviceData!.id.validate())
        //     .launch(context)
        //     .then((value) {
        //   setStatusBarColor(context.primaryColor);
        // });
        BookServiceScreen(
          typeId: widget.typeId,
          // subTypeId: widget.subTypeId,
          serviceId: widget.serviceData?.id ?? 57,
          categoryId: widget.serviceData?.categoryId,
        ).launch(context).then((value) {
          setStatusBarColor(transparentColor);
        });
      },
      child: SizedBox(
        width: context.width() / 4 - 20,
        child: Column(
          children: [
            if (widget.serviceData?.attachments == null ||
                widget.serviceData!.attachments!.isEmpty)
              PlaceHolderWidget(
                  height: CATEGORY_ICON_SIZE,
                  width: CATEGORY_ICON_SIZE,
                  color: Colors.grey.withOpacity(0.1))
            else
              (widget.serviceData!.attachments!.first
                      .validate()
                      .endsWith('.svg'))
                  ? Container(
                      width: CATEGORY_ICON_SIZE,
                      height: CATEGORY_ICON_SIZE,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: context.cardColor, shape: BoxShape.circle),
                      child: SvgPicture.network(
                        widget.isFavouriteService
                            ? widget.serviceData!.serviceAttachments
                                    .validate()
                                    .isNotEmpty
                                ? widget.serviceData!.serviceAttachments!.first
                                    .validate()
                                : ''
                            : widget.serviceData!.attachments
                                    .validate()
                                    .isNotEmpty
                                ? widget.serviceData!.attachments!.first
                                    .validate()
                                : '',
                        height: CATEGORY_ICON_SIZE,
                        width: CATEGORY_ICON_SIZE,
                        placeholderBuilder: (context) => PlaceHolderWidget(
                            height: CATEGORY_ICON_SIZE,
                            width: CATEGORY_ICON_SIZE,
                            color: transparentColor),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: context.cardColor, shape: BoxShape.circle),
                      child: CachedImageWidget(
                        url: widget.isFavouriteService
                            ? widget.serviceData!.serviceAttachments
                                    .validate()
                                    .isNotEmpty
                                ? widget.serviceData!.serviceAttachments!.first
                                    .validate()
                                : ''
                            : widget.serviceData!.attachments
                                    .validate()
                                    .isNotEmpty
                                ? widget.serviceData!.attachments!.first
                                    .validate()
                                : '',
                        fit: BoxFit.fitWidth,
                        width: SUBCATEGORY_ICON_SIZE,
                        height: SUBCATEGORY_ICON_SIZE,
                        circle: true,
                      ),
                    ),
            8.height,
            Marquee(
                child: Text(widget.serviceData?.name?.validate() ?? '',
                    style: boldTextStyle(size: 12),
                    textAlign: TextAlign.center,
                    maxLines: 1))
          ],
        ),
      ),

      // child: Container(
      //   decoration: boxDecorationWithRoundedCorners(
      //     borderRadius: radius(),
      //     backgroundColor: context.cardColor,
      //     border: widget.isBorderEnabled.validate(value: false)
      //         ? appStore.isDarkMode
      //             ? Border.all(color: context.dividerColor)
      //             : null
      //         : null,
      //   ),
      //   width: widget.width,
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       SizedBox(
      //         height: 205,
      //         width: context.width(),
      //         child: Stack(
      //           clipBehavior: Clip.none,
      //           children: [
      //             CachedImageWidget(
      //               url: widget.isFavouriteService
      //                   ? widget.serviceData!.serviceAttachments
      //                           .validate()
      //                           .isNotEmpty
      //                       ? widget.serviceData!.serviceAttachments!.first
      //                           .validate()
      //                       : ''
      //                   : widget.serviceData!.attachments.validate().isNotEmpty
      //                       ? widget.serviceData!.attachments!.first.validate()
      //                       : '',
      //               fit: BoxFit.cover,
      //               height: 180,
      //               width: context.width(),
      //               circle: false,
      //             ).cornerRadiusWithClipRRectOnly(
      //                 topRight: defaultRadius.toInt(),
      //                 topLeft: defaultRadius.toInt()),
      //             Positioned(
      //               top: 12,
      //               left: 12,
      //               child: Container(
      //                 padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      //                 constraints:
      //                     BoxConstraints(maxWidth: context.width() * 0.3),
      //                 decoration: boxDecorationWithShadow(
      //                   backgroundColor: context.cardColor.withOpacity(0.9),
      //                   borderRadius: radius(24),
      //                 ),
      //                 child: Marquee(
      //                   directionMarguee: DirectionMarguee.oneDirection,
      //                   child: Text(
      //                     "${widget.serviceData!.subCategoryName.validate().isNotEmpty ? widget.serviceData!.subCategoryName.validate() : widget.serviceData!.categoryName.validate()}"
      //                         .toUpperCase(),
      //                     style: boldTextStyle(
      //                         color: appStore.isDarkMode ? white : primaryColor,
      //                         size: 12),
      //                   ).paddingSymmetric(horizontal: 8, vertical: 4),
      //                 ),
      //               ),
      //             ),
      //             if (widget.isFavouriteService)
      //               Positioned(
      //                 top: 8,
      //                 right: 0,
      //                 child: Container(
      //                   padding: EdgeInsets.all(8),
      //                   margin: EdgeInsets.only(right: 8),
      //                   decoration: boxDecorationWithShadow(
      //                       boxShape: BoxShape.circle,
      //                       backgroundColor: context.cardColor),
      //                   child: widget.serviceData!.isFavourite == 0
      //                       ? ic_fill_heart.iconImage(
      //                           color: favouriteColor, size: 18)
      //                       : ic_heart.iconImage(
      //                           color: unFavouriteColor, size: 18),
      //                 ).onTap(() async {
      //                   if (widget.serviceData!.isFavourite == 0) {
      //                     widget.serviceData!.isFavourite = 1;
      //                     setState(() {});

      //                     await removeToWishList(
      //                             serviceId: widget.serviceData!.serviceId
      //                                 .validate()
      //                                 .toInt())
      //                         .then((value) {
      //                       if (!value) {
      //                         widget.serviceData!.isFavourite = 0;
      //                         setState(() {});
      //                       }
      //                     });
      //                   } else {
      //                     widget.serviceData!.isFavourite = 0;
      //                     setState(() {});

      //                     await addToWishList(
      //                             serviceId: widget.serviceData!.serviceId
      //                                 .validate()
      //                                 .toInt())
      //                         .then((value) {
      //                       if (!value) {
      //                         widget.serviceData!.isFavourite = 1;
      //                         setState(() {});
      //                       }
      //                     });
      //                   }
      //                   widget.onUpdate?.call();
      //                 }),
      //               ),
      //             // Positioned(
      //             //   bottom: 12,
      //             //   right: 8,
      //             //   child: Container(
      //             //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      //             //     decoration: boxDecorationWithShadow(
      //             //       backgroundColor: primaryColor,
      //             //       borderRadius: radius(24),
      //             //       border: Border.all(color: context.cardColor, width: 2),
      //             //     ),
      //             //     child: PriceWidget(
      //             //       price: widget.serviceData!.price.validate(),
      //             //       isHourlyService: widget.serviceData!.isHourlyService,
      //             //       color: Colors.white,
      //             //       hourlyTextColor: Colors.white,
      //             //       size: 14,
      //             //       isFreeService: widget.serviceData!.type.validate() ==
      //             //           SERVICE_TYPE_FREE,
      //             //     ),
      //             //   ),
      //             // ),
      //             Positioned(
      //               bottom: 0,
      //               left: 16,
      //               child: DisabledRatingBarWidget(
      //                   rating: widget.serviceData!.totalRating.validate(),
      //                   size: 14),
      //             ),
      //           ],
      //         ),
      //       ),
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           8.height,
      //           Marquee(
      //             directionMarguee: DirectionMarguee.oneDirection,
      //             child: Text(widget.serviceData!.name.validate(),
      //                     style: boldTextStyle())
      //                 .paddingSymmetric(horizontal: 16),
      //           ),
      //           // 8.height,
      //           // Row(
      //           //   children: [
      //           //     ImageBorder(
      //           //         src: widget.serviceData!.providerImage.validate(),
      //           //         height: 30),
      //           //     8.width,
      //           //     if (widget.serviceData!.providerName.validate().isNotEmpty)
      //           //       Text(
      //           //         widget.serviceData!.providerName.validate(),
      //           //         style: secondaryTextStyle(
      //           //             size: 12,
      //           //             color: appStore.isDarkMode
      //           //                 ? Colors.white
      //           //                 : appTextSecondaryColor),
      //           //         maxLines: 2,
      //           //         overflow: TextOverflow.ellipsis,
      //           //       ).expand()
      //           //   ],
      //           // ).onTap(() async {
      //           //   if (widget.serviceData!.providerId !=
      //           //       appStore.userId.validate()) {
      //           //     await ProviderInfoScreen(
      //           //             providerId:
      //           //                 widget.serviceData!.providerId.validate())
      //           //         .launch(context);
      //           //     setStatusBarColor(Colors.transparent);
      //           //   } else {
      //           //     //
      //           //   }
      //           // }).paddingSymmetric(horizontal: 16),
      //           16.height,
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
