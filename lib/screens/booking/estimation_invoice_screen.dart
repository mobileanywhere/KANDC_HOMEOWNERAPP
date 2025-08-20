import 'package:homeowner/component/back_widget.dart';
import 'package:homeowner/model/line_item_response.dart';
import 'package:homeowner/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class EstimationInvoiceScreen extends StatefulWidget {
  final List<LineItemData> particulars;
  const EstimationInvoiceScreen({super.key, required this.particulars});

  @override
  State<EstimationInvoiceScreen> createState() =>
      _EstimationInvoiceScreenState();
}

class _EstimationInvoiceScreenState extends State<EstimationInvoiceScreen> {
  Widget paymentItem(
      {String? name, int? quantity, double? price, bool showQuantity = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$name${showQuantity ? ' x $quantity' : ''}'),
          Text('\$${price?.toStringAsFixed(2)}'),
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
          Text('-\$${totalAmount?.toStringAsFixed(2)}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: greenColor.withOpacity(0.6))),
        ],
      ),
    );
  }

  double calculateTotalInfo() {
    double totalAmount = 0;

    for (var element in widget.particulars) {
      if (element.qty! >= 1) {
        double itemTotal = element.qty! * double.parse(element.price ?? '0');
        totalAmount += itemTotal;
      }
    }

    return totalAmount;
  }

  double amountToPay() {
    double totalAmount = 0;

    for (var element in widget.particulars) {
      if (element.qty! >= 1) {
        double itemTotal = element.qty! * double.parse(element.price ?? '0');
        totalAmount += itemTotal;
      }
    }

    return (totalAmount - 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        'Line Items Invoice',
        color: context.primaryColor,
        textColor: Colors.white,
        showBack: true,
        backWidget: BackWidget(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Particulars', style: boldTextStyle(size: LABEL_TEXT_SIZE)),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var item in widget.particulars)
                      paymentItem(
                        name: item.name,
                        quantity: item.qty,
                        price: item.price.toDouble() *
                            num.parse(item.qty.toString()),
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
                        name: 'Item total',
                        quantity: 0,
                        price: calculateTotalInfo(),
                        showQuantity: false),
                    paymentItem(
                        name: 'Taxes and Fee',
                        quantity: 0,
                        price: 0,
                        showQuantity: false),
                  ],
                ),
              ),
            ],
          ),
          totalAmount(
            text: 'Amount Paid',
            totalAmount: 0,
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Amount to pay',
                      style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                  Text('\$${amountToPay().toStringAsFixed(2)}',
                      style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                ],
              ),
              Text(
                'Final amount may vary based on repair.',
                style: secondaryTextStyle(),
              ),
            ],
          ),
        ],
      ).paddingAll(16),
    );
  }
}
