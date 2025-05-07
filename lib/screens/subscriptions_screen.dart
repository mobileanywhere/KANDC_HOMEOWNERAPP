import 'package:homeowner/component/base_scaffold_widget.dart';
import 'package:homeowner/main.dart';
import 'package:homeowner/model/PurchasePlanModel.dart';
import 'package:homeowner/model/base_response_model.dart';
import 'package:homeowner/model/plan_model.dart';
import 'package:homeowner/model/property_model.dart';
import 'package:homeowner/network/rest_apis.dart';
import 'package:homeowner/services/stripe_service_singleton.dart';
import 'package:homeowner/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class SubscriptionsScreen extends StatefulWidget {
  @override
  _SubscriptionsScreenState createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  final StripeService _stripeService = StripeService();
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white, statusBarBrightness: Brightness.light));
    getPlanListData();
  }

  List<PlanData> planDataList = [];
  PlanModel planModel = PlanModel();
  List<String> selectedPropertyIds = [];

  void getPlanListData() async {
    try {
      var res = await getPlanList();

      try {
        setState(() {
          planModel = res;
          planDataList.clear();
          debugPrint("length of plan list: ${res.data.toString()}");
          planDataList.addAll(res.data ?? []);
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<PurchasePlanModel> purchaseSubscribePlan(
      String planId, List<String> propertyIds) async {
    setState(() {
      appStore.setLoading(true);
    });
    var request = {
      "customer_id": "${appStore.userId}",
      "plan_id": "$planId",
      'property_id': propertyIds
    };
    PurchasePlanModel? purchasePlanModel;
    try {
      await purchasePlan(request: request).then((value) {
        getPlanListData();
        purchasePlanModel = value;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      appStore.setLoading(false);
    });
    return purchasePlanModel ?? PurchasePlanModel();
  }

  Future<BaseResponseModel> updatePaymentSubscription({
    required List<int>? bookingId,
    required int? totalAmount,
    required String? dateTime,
    required String? txnId,
    required String? paymentStatus,
    required String? paymentType,
  }) async {
    Map req = {
      'booking_id': bookingId ?? [],
      'customer_id': appStore.userId ?? '',
      'total_amount': totalAmount ?? 0,
      'datetime': dateTime ?? '',
      'txn_id': txnId ?? '',
      'payment_status': paymentStatus ?? '',
      'payment_type': paymentType ?? 'Card',
      'other_transaction_detail': '',
      'discount': 0,
    };
    try {
      return await updatePayment(req);
    } catch (e) {
      throw e;
    }
  }

  // Usage example with error handling in a UI context
  void handlePayment(
      BuildContext context,
      String amount,
      String currency,
      String userEmail,
      String userName,
      String paymentType,
      PurchasePlanModel purchasePlanModel) async {
    try {
      final paymentResult = await _stripeService.stripePay(
        context: context,
        amount: amount,
        currency: currency,
        userEmail: userEmail,
        userName: userName,
      );

      if (paymentResult['status'] == 'success' ||
          paymentResult['status'] == 'processing') {
        // Handle successful payment
        Map req = {
          'booking_id': purchasePlanModel.bookingId,
          'customer_id': '${appStore.userId}',
          'total_amount': '${paymentResult['amount']}',
          'datetime': '${paymentResult['datetime']}',
          'txn_id': '${paymentResult['transactionId']}',
          'payment_status': '${paymentResult['status']}',
          'payment_type': '${paymentResult['paymentType']}',
          'other_transaction_detail': '',
          'discount': '0',
        };

        try {
          await updatePayment(req).then((v) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Payment Success'),
                  content: Text(v.message ??
                      'Transaction ID: ${paymentResult['transactionId']}'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        getPlanListData();
                        Navigator.pop(context);
                      },
                      child: Text('Okay'),
                    ),
                  ],
                );
              },
            );
          });
        } catch (e) {
          toast('Something went wrong');
        }
      } else {
        // Handle payment error
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Payment Failed'),
              content: Text('Error: ${paymentResult['error']}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Okay'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle general errors
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Payment Failed'),
            content: Text('Error: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Okay'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _showPropertySelectionDialog(
      BuildContext context,
      List<PropertyData> properties,
      String planId,
      num totalAmount,
      List<String> propertyIds) async {
    final selectedPropertyIds = await showDialog<List<int>>(
      context: context,
      builder: (context) {
        return PropertySelectionDialog(properties: properties);
      },
    );

    if (selectedPropertyIds != null && selectedPropertyIds.isNotEmpty) {
      var selectedIds = selectedPropertyIds.map((e) => e.toString()).toList();
      var purchasePlanModel = await purchaseSubscribePlan(planId, selectedIds);
      print('Selected property IDs: $selectedIds');

      print('properties length: ${selectedIds.length}');
      for (var i = 0; i < selectedIds.length; i++) {
        print('properties length id: ${selectedIds[i]}');
      }
      print('price : ${totalAmount}');
      print(
          'properties length: ${properties.length > 1 ? (totalAmount * selectedIds.length) : totalAmount}');

      handlePayment(
          context,
          '${properties.length > 1 ? (totalAmount * selectedIds.length) : totalAmount}',
          'usd',
          appStore.userEmail,
          appStore.userFullName,
          'order',
          purchasePlanModel);
    } else {
      print('No property selected');
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.lblSubscriptions,
      child:
          // appStore.isLoading? LoaderWidget():
          AnimatedScrollView(
        crossAxisAlignment: CrossAxisAlignment.center,
        listAnimationType: ListAnimationType.FadeIn,
        padding: EdgeInsets.symmetric(horizontal: 16),
        fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
        children: [
          16.height,
          Text(
            'Don\'t settle for less when you can have the best. Level up your journey with our premium upgrade!',
            textAlign: TextAlign.center,
            style: secondaryTextStyle(size: 14, color: black),
          ),
          36.height,
          ListView.builder(
            itemCount: planDataList.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              PlanData plan = planDataList[index];
              return Column(
                children: [
                  subscriptionContainer(
                      isSubscribed: plan.active == 0 ? false : true,
                      planTitle: plan.title ?? "",
                      planDescription: plan.description ?? "",
                      price: (plan.amount ?? 0).toDouble(),
                      planId: plan.id.toString()),
                  SizedBox(
                    height: context.height() * 0.04,
                  ),
                ],
              );
            },
          ),
          25.height,
        ],
      ),
    );
  }

  Widget subscriptionContainer({
    required bool isSubscribed,
    required String planTitle,
    required String planDescription,
    required double price,
    required String planId,
  }) {
    return Container(
      width: context.width(),
      decoration: BoxDecoration(
        color: isSubscribed ? Color(0xffB5AB9F) : Colors.white,
        border: Border.all(color: Color(0xffB5AB9F)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Text(
              planTitle,
              textAlign: TextAlign.left,
              style: secondaryTextStyle(
                  color: isSubscribed ? white : black,
                  weight: FontWeight.bold,
                  size: 18),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              planDescription,
              textAlign: TextAlign.left,
              style: secondaryTextStyle(
                  color: isSubscribed ? white : black,
                  size: 14,
                  weight: isSubscribed ? FontWeight.bold : FontWeight.normal),
            ),
            SizedBox(
              height: 16,
            ),
            AppButton(
              width: context.width(),
              onTap: () async {
                // if (planModel.subscription == 1) {
                // } else {
                //   if (isSubscribed) {
                //   } else {
                //     // await purchaseSubscribePlan(planId);
                //     final properties = await getAllPropertiesBySubscription(
                //         {'customer_id': appStore.userId, 'plan_id': planId});
                //     await _showPropertySelectionDialog(context, properties);
                //   }
                // }
                final properties = await getAllPropertiesBySubscription(
                    {'customer_id': appStore.userId, 'plan_id': planId});
                await _showPropertySelectionDialog(
                    context, properties, planId, price, selectedPropertyIds);
              },
              text: isSubscribed ? 'Subscribed' : 'Subscribe Now',
              color: isSubscribed ? white : primaryColor,
              textColor: isSubscribed ? primaryColor : white,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              '\$ ${price.toStringAsFixed(2)}',
              style: secondaryTextStyle(
                  color: isSubscribed ? white : black,
                  weight: FontWeight.bold,
                  size: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class PropertySelectionDialog extends StatefulWidget {
  final List<PropertyData> properties;

  PropertySelectionDialog({required this.properties});

  @override
  _PropertySelectionDialogState createState() =>
      _PropertySelectionDialogState();
}

class _PropertySelectionDialogState extends State<PropertySelectionDialog> {
  List<int> selectedPropertyIds = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Properties'),
      content: Container(
        width: double.minPositive,
        child: widget.properties.isEmpty
            ? Text('No property found that satisfy subscription plan.')
            : ListView.builder(
                shrinkWrap: true,
                itemCount: widget.properties.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    value: selectedPropertyIds
                        .contains(widget.properties[index].id),
                    title: Text(
                      '${widget.properties[index].name} '
                      '${widget.properties[index].size == null || widget.properties[index].size!.isEmpty ? '' : '(Square Ft. ${widget.properties[index].size})'}',
                    ),
                    subtitle:
                        Text('Address: ${widget.properties[index].address}'),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedPropertyIds.add(widget.properties[index].id!);
                        } else {
                          selectedPropertyIds
                              .remove(widget.properties[index].id);
                        }
                      });
                    },
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (widget.properties.length == 0) {
              Navigator.pop(context, null);
            } else {
              Navigator.pop(context, selectedPropertyIds);
            }
          },
          child: Text('Okay'),
        ),
      ],
    );
  }
}
