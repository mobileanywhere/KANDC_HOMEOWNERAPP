import 'package:homeowner/component/back_widget.dart';
import 'package:homeowner/component/loader_widget.dart';
import 'package:homeowner/main.dart';
import 'package:homeowner/model/invoice_data_model.dart';
import 'package:homeowner/network/rest_apis.dart';
import 'package:homeowner/screens/booking/component/invoice_request_dialog_component.dart';
import 'package:homeowner/services/stripe_service_singleton.dart';
import 'package:homeowner/utils/colors.dart';
import 'package:homeowner/utils/common.dart';
import 'package:homeowner/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class FinalInvoiceScreen extends StatefulWidget {
  final int bookingId;
  const FinalInvoiceScreen({super.key, required this.bookingId});

  @override
  State<FinalInvoiceScreen> createState() => _FinalInvoiceScreenState();
}

class _FinalInvoiceScreenState extends State<FinalInvoiceScreen> {
  InvoiceDataModel? invoiceDataModel;
  final StripeService _stripeService = StripeService();

  Widget paymentItem(
      {String? name, int? quantity, double? price, bool showQuantity = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$name${showQuantity ? ' x $quantity' : ''}'),
          Text('\$${(price ?? 0) * (quantity ?? 0)}'),
        ],
      ),
    );
  }

  Widget totalAmount({String? text, double? totalAmount}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text ?? 'Total Amount',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text('\$${totalAmount?.toStringAsFixed(2)}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: greenColor.withOpacity(0.6))),
        ],
      ),
    );
  }

  @override
  void initState() {
    generateInvoice();
    super.initState();
  }

// Usage example with error handling in a UI context
  void handlePayment(BuildContext context, String amount, String currency,
      String userEmail, String userName, String paymentType) async {
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
          'booking_id': '${widget.bookingId}',
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
          await savePayment(req).then((v) {
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
                        generateInvoice();
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

  Future<void> generateInvoice() async {
    setState(() {
      appStore.setLoading(true);
    });
    try {
      appStore.setLoading(true);
      var request = {
        "customer_id": appStore.userId,
        "booking_id": "${widget.bookingId}"
      };
      var response = await getInvoice(request);
      setState(() {
        invoiceDataModel = response;
      });
    } finally {
      appStore.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        'Final Invoice',
        color: context.primaryColor,
        textColor: Colors.white,
        showBack: true,
        backWidget: BackWidget(),
      ),
      body: appStore.isLoading
          ? Center(
              child: LoaderWidget(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          invoiceDataModel?.bookingData?.booking?.serviceName ?? '',
                          style: boldTextStyle(size: 16)),
                      Text(
                          '\$${invoiceDataModel?.bookingData?.booking?.amount ?? 0}',
                          style: boldTextStyle(size: 16)),
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                      invoiceDataModel?.bookingData?.booking?.date != null ? '(${formatDate(invoiceDataModel?.bookingData?.booking?.date.validate())})' : '',
                      style: secondaryTextStyle(
                          size: 12, fontStyle: FontStyle.italic)),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Particulars',
                          style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (invoiceDataModel?.lineitemData == null ||
                                invoiceDataModel!.lineitemData!.isEmpty)
                              Text('No Items Found!'),
                            for (var item in invoiceDataModel?.lineitemData ??
                                <InvoiceLineItemData>[])
                              paymentItem(
                                name: item.lineItemName,
                                quantity: item.lineItemQty,
                                price: item.lineItemPrice.toDouble(),
                                // price: item.price.toDouble() * num.parse(item.qty.toString()),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payment Summary',
                          style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // for (var item in paymentSummaryList)
                            paymentItem(
                                name: 'Sub Total',
                                quantity: 1,
                                price: (invoiceDataModel?.bookingData?.booking
                                            ?.finalSubTotal ??
                                        0)
                                    .toDouble(),
                                showQuantity: false),
                            paymentItem(
                                name: 'Taxes and Fee',
                                quantity: 1,
                                price: (invoiceDataModel?.bookingData?.booking
                                            ?.finalTotalTax ??
                                        0)
                                    .toDouble(),
                                showQuantity: false),
                            totalAmount(
                                totalAmount: (invoiceDataModel?.bookingData
                                            ?.booking?.totalAmount ??
                                        0)
                                    .toDouble()),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (invoiceDataModel?.bookingData?.payment?.paymentStatus ==
                          'succeeded' ||
                      invoiceDataModel?.bookingData?.payment?.paymentStatus ==
                          'processing')
                    Divider(),
                  if (invoiceDataModel?.bookingData?.payment?.paymentStatus ==
                          'succeeded' ||
                      invoiceDataModel?.bookingData?.payment?.paymentStatus ==
                          'processing')
                    Text('Payment Paid Successfully',
                            style: boldTextStyle(
                                size: LABEL_TEXT_SIZE, color: greenColor))
                        .center()
                        .paddingSymmetric(vertical: 10),
                  if (invoiceDataModel?.bookingData?.payment?.paymentStatus ==
                          'succeeded' ||
                      invoiceDataModel?.bookingData?.payment?.paymentStatus ==
                          'processing')
                    Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  if ((invoiceDataModel?.bookingData?.booking?.totalAmount ?? 0)
                          .toDouble() >
                      0)
                    if (!(invoiceDataModel
                                ?.bookingData?.payment?.paymentStatus ==
                            'succeeded' ||
                        invoiceDataModel?.bookingData?.payment?.paymentStatus ==
                            'processing'))
                      AppButton(
                        onTap: () async {
                          handlePayment(
                              context,
                              '${invoiceDataModel?.bookingData?.booking?.totalAmount ?? '0'}',
                              'usd',
                              appStore.userEmail,
                              appStore.userFullName,
                              'order');
                        },
                        width: context.width(),
                        color: primaryColor,
                        text: 'Pay Now',
                      ),
                  if (!(invoiceDataModel?.bookingData?.payment?.paymentStatus ==
                          'succeeded' ||
                      invoiceDataModel?.bookingData?.payment?.paymentStatus ==
                          'processing'))
                    SizedBox(height: 20),
                  AppButton(
                    onTap: () async {
                      bool? res = await showInDialog(
                        context,
                        contentPadding: EdgeInsets.zero,
                        dialogAnimation: DialogAnimation.SLIDE_TOP_BOTTOM,
                        barrierDismissible: false,
                        builder: (_) => InvoiceRequestDialogComponent(
                            bookingId: widget.bookingId),
                      );

                      if (res ?? false) {
                        // isSentInvoiceOnEmail = res.validate();

                        // init();
                        // setState(() {});
                      }
                    },
                    width: context.width(),
                    color: primaryColor,
                    text: 'Request Invoice',
                  ),
                ],
              ).paddingAll(16),
            ),
    );
  }
}
