import 'package:homeowner/component/image_border_component.dart';
import 'package:homeowner/component/selected_item_widget.dart';
import 'package:homeowner/main.dart';
import 'package:homeowner/model/user_data_model.dart';
import 'package:homeowner/utils/common.dart';
import 'package:homeowner/utils/constant.dart';
import 'package:homeowner/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/empty_error_state_widget.dart';

class FilterProviderComponent extends StatefulWidget {
  final List<UserData> providerList;

  const FilterProviderComponent({super.key, required this.providerList});

  @override
  State<FilterProviderComponent> createState() => _FilterProviderComponentState();
}

class _FilterProviderComponentState extends State<FilterProviderComponent> {
  @override
  Widget build(BuildContext context) {
    if (widget.providerList.isEmpty) {
      return NoDataWidget(
        title: language.noProviderFound,
        imageWidget: EmptyStateWidget(),
      );
    }

    return AnimatedListView(
      slideConfiguration: sliderConfigurationGlobal,
      itemCount: widget.providerList.length,
      listAnimationType: ListAnimationType.FadeIn,
      fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
      itemBuilder: (context, index) {
        UserData data = widget.providerList[index];

        return Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              ImageBorder(
                src: data.profileImage.validate(),
                height: 45,
              ),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(data.displayName.validate(), style: boldTextStyle()).flexible(),
                      4.width,
                      Image.asset(ic_star_fill, color: getRatingBarColor(data.providersServiceRating.validate().toInt(), showRedForZeroRating: true), height: 10),
                    ],
                  ),
                  4.height,
                  Text('${language.lblMemberSince} ${DateFormat(YEAR).format(DateTime.parse(data.createdAt.validate()))}', style: secondaryTextStyle()),
                ],
              ).expand(),
              SelectedItemWidget(isSelected: data.isSelected),
            ],
          ),
        ).onTap(() {
          if (data.isSelected) {
            data.isSelected = false;
          } else {
            data.isSelected = true;
          }
          setState(() {});
        });
      },
    );
  }
}
