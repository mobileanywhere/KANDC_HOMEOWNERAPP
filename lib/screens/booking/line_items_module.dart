import 'package:homeowner/component/loader_widget.dart';
import 'package:homeowner/main.dart';
import 'package:homeowner/model/estimation_response_details.dart';
import 'package:homeowner/model/line_item_response.dart';
import 'package:homeowner/network/rest_apis.dart';
import 'package:homeowner/screens/booking/estimation_invoice_screen.dart';
import 'package:homeowner/utils/colors.dart';
import 'package:homeowner/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class LineItemsModule extends StatefulWidget {
  final String bookingId;
  final String serviceId;
  final String customerId;
  const LineItemsModule({
    super.key,
    required this.bookingId,
    required this.serviceId,
    required this.customerId,
  });

  @override
  State<LineItemsModule> createState() => _LineItemsModuleState();
}

class _LineItemsModuleState extends State<LineItemsModule> {
  //endregion
  List<LineItemData> comingDataList = [];
  Map<String, dynamic>? totalInfo;
  List<EstimationLineItemData> listOfLineItems = [];
  EstimationDetailsResponse? estimationDetailResponse;

  @override
  void initState() {
    super.initState();
    estimationDetailsData();
  }

  Widget paymentItem({String? name, int? quantity, double? price}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$name x $quantity'),
          Text('\$${price?.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget totalAmount({double? totalAmount}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('\$${totalAmount?.toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  double calculateTotalInfo() {
    double totalAmount = 0;

    for (var element in comingDataList) {
      if (element.qty! >= 1) {
        double itemTotal = element.qty! * double.parse(element.price ?? '0');
        totalAmount += itemTotal;
      }
    }

    return totalAmount;
  }

  List<Map<String, String>> populateSList() {
    List<Map<String, String>> s = [];
    for (var lineItem in comingDataList) {
      Map<String, String> lineItemMap = {
        "line_item_id": lineItem.id?.toString() ?? "",
        "line_item_name": lineItem.name ?? "",
        "line_item_qty": lineItem.qty?.toString() ?? "0",
        "line_item_price": lineItem.price ?? "0",
      };
      setState(() {
        s.add(lineItemMap);
      });
    }
    return s;
  }

  void estimationDetailsData() async {
    Map req = {
      "customer_id": widget.customerId,
      "booking_id": widget.bookingId
    };
    try {
      var res = await estimationDetails(req);
      setState(() {
        comingDataList.clear();
        listOfLineItems.clear();
        estimationDetailResponse = res;
        listOfLineItems.addAll(res.lineitemData ?? []);
        addLineItemsToList(listOfLineItems);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void addLineItemsToList(List<EstimationLineItemData> listOfLineItems) {
    for (EstimationLineItemData estimationLineItem in listOfLineItems) {
      LineItemData lineItemData = LineItemData(
        id: estimationLineItem.lineItemId,
        name: estimationLineItem.lineItemName,
        price: estimationLineItem.lineItemPrice,
        qty: estimationLineItem.lineItemQty,
      );
      setState(() {
        comingDataList.add(lineItemData);
      });
    }
  }

  void approveEstimationData() async {
    appStore.setLoading(true);
    Map req = {
      "customer_id": widget.customerId,
      "booking_id": widget.bookingId
    };
    try {
      await approveEstimation(req).then((value) {
        estimationDetailsData();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    appStore.setLoading(false);
  }

  void declineEstimationData() async {
    appStore.setLoading(true);
    Map req = {
      "customer_id": widget.customerId,
      "booking_id": widget.bookingId
    };
    try {
      await declineEstimation(req).then((value) {
        estimationDetailsData();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    appStore.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return (comingDataList.isEmpty ||
            estimationDetailResponse?.estimation?.status == 0)
        ? SizedBox()
        : Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Line Items',
                          style: boldTextStyle(size: LABEL_TEXT_SIZE))),
                  if (comingDataList.isNotEmpty)
                    SizedBox(
                      height: 10,
                    ),
                  if (comingDataList.isNotEmpty)
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var item in comingDataList)
                            paymentItem(
                              name: item.name,
                              quantity: item.qty,
                              price: item.price.toDouble() *
                                  num.parse(item.qty.toString()),
                            ),
                          Divider(),
                          totalAmount(totalAmount: calculateTotalInfo()),
                        ],
                      ),
                    ),
                  if (comingDataList.isNotEmpty)
                    if (estimationDetailResponse?.estimation?.status == 1)
                      SizedBox(
                        height: 10,
                      ),
                  Row(
                    children: [
                      if (estimationDetailResponse?.estimation?.status == 3)
                        SizedBox(
                          width: 20,
                        ),
                      if (estimationDetailResponse?.estimation?.status == 1 ||
                          estimationDetailResponse?.estimation?.status == 3)
                        Expanded(
                          child: AppButton(
                            onTap: () async {
                              if (estimationDetailResponse
                                      ?.estimation?.status ==
                                  3) {
                              } else {
                                declineEstimationData();
                              }
                            },
                            width: context.width(),
                            color: primaryColor,
                            text:
                                estimationDetailResponse?.estimation?.status ==
                                        3
                                    ? 'Declined'
                                    : 'Decline',
                          ),
                        ),
                      SizedBox(
                        width: 20,
                      ),
                      if (estimationDetailResponse?.estimation?.status ==
                          1) // add this to if condition for view invoice || estimationDetailResponse?.estimation?.status == 2
                        Expanded(
                          child: AppButton(
                            onTap: () async {
                              if (estimationDetailResponse
                                      ?.estimation?.status ==
                                  2) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        EstimationInvoiceScreen(
                                          particulars: comingDataList,
                                        )));
                              } else {
                                approveEstimationData();
                              }
                            },
                            width: context.width(),
                            color: primaryColor,
                            text:
                                estimationDetailResponse?.estimation?.status ==
                                        2
                                    ? 'View Invoice'
                                    : 'Approve',
                          ),
                        ),
                      if (estimationDetailResponse?.estimation?.status == 2)
                        SizedBox(
                          width: 20,
                        ),
                    ],
                  ),
                  if (estimationDetailResponse?.estimation?.status == 2)
                    Visibility(
                      visible: false,
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                  if (estimationDetailResponse?.estimation?.status == 2)
                    Visibility(
                      visible: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: AppButton(
                          onTap: () async {},
                          width: context.width(),
                          color: greenColor.withOpacity(0.7),
                          text: 'Pay Now',
                        ),
                      ),
                    ),
                  Divider(height: 32, color: context.dividerColor),
                ],
              ),
              Positioned.fill(
                child: appStore.isLoading
                    ? Center(child: LoaderWidget())
                    : SizedBox(),
              ),
            ],
          );
  }
}
