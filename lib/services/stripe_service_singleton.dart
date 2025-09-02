import 'dart:async';
import 'dart:convert';
import 'package:homeowner/utils/configs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

class StripeService {
  // Singleton Pattern
  static final StripeService _instance = StripeService._internal();
  factory StripeService() => _instance;
  StripeService._internal();

  // Testing and Live Configuration
  bool isTesting = true;
  String get publishableKey => isTesting
      ? 'pk_test_LPjdxKFqlCMe3PJaOTqGtIZV'
      : 'pk_live_M8SBRAvXKV6kP2H6PFmYHGxO';

  String get secretKey => isTesting
      ? 'sk_test_RSlgCmcPTrrzoHSSlw9EsZ7x'
      : 'sk_live_t2vJYsL3oSacpM1lmD8ftQ8w';
  String get merchantId =>
      isTesting ? 'merchant.flutter.stripe.test' : 'merchant.kandc';

  // Initialization
  Future<void> init() async {
    try {
      Stripe.publishableKey = publishableKey;
      Stripe.merchantIdentifier = merchantId;
      await Stripe.instance.applySettings();
    } catch (e) {
      debugPrint('Stripe initialization failed: $e');
      throw Exception('Failed to initialize Stripe: $e');
    }
  }

  // Create Payment Intent on Backend
  Future<Map<String, dynamic>> _createPaymentIntent(
      {required String amount,
      required String currency,
      required String userEmail,
      required String userName,
      required String paymentType}) async {
    try {
      final url = Uri.parse('${BASE_URL}create-payment-intent');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": userEmail,
          "name": userName,
          "amount": (double.parse(amount) * 100).toInt(),
          "currency": currency,
          "payment_method_types": [
            paymentType == 'card' ? 'card' : 'us_bank_account'
          ],
        }),
      );

      debugPrint('Payment Intent Response: ${response.body}');
      if (response.statusCode != 200) {
        throw Exception('Failed to create Payment Intent');
      }
      return jsonDecode(response.body);
    } catch (e) {
      debugPrint('Error creating Payment Intent: $e');
      throw Exception('Failed to create Payment Intent: $e');
    }
  }

  // Open AlertDialog to Choose Payment Method
  Future<String?> _choosePaymentMethod(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Payment Method'),
          content: const Text('Please select your payment method.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'card'),
              child: const Text('Card'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'ach'),
              child: const Text('ACH Direct Debit'),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> stripePay({
    required BuildContext context,
    required String amount,
    required String currency,
    required String userName,
    required String userEmail,
  }) async {
    try {
      Map<String, dynamic> paymentIntentData;
      PaymentIntent? finalPaymentIntent;

      // Step 1: Show Payment Method Choice Dialog
      final paymentType = await _choosePaymentMethod(context);

      // Handle dismissal of the dialog
      if (paymentType == null) {
        debugPrint('Payment method selection was canceled.');
        toast('You have canceled the payment.');
        return {
          'status': 'failed',
          'error': 'Payment method selection was canceled.',
        };
      } else {
// Step 2: Create Payment Intent with Selected Method
        paymentIntentData = await _createPaymentIntent(
          amount: amount,
          currency: currency,
          userEmail: userEmail,
          userName: userName,
          paymentType: paymentType,
        );

        // Step 3: Handle Payment Based on Selected Method
        if (paymentType == 'card') {
          // Step 3a: Handle Card Payment
          await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData['clientSecret'],
              merchantDisplayName: APP_NAME,
              customerId: paymentIntentData['customer'],
              customerEphemeralKeySecret: paymentIntentData['ephemeralKey'],
            ),
          );
          await Stripe.instance.presentPaymentSheet();
        } else if (paymentType == 'ach') {
          // Step 3b: Handle ACH Direct Debit Payment
          final achDetails = await showACHDetailsDialog(
            context: context,
            userName: userName,
            userEmail: userEmail,
          );

          if (achDetails == null) {
            debugPrint('ACH details input canceled');
            toast('ACH details input canceled');
            return {
              'status': 'failed',
              'error': 'Payment process exit.',
            };
          } else {
            // Proceed with payment using the entered ACH details
            final billingDetails = BillingDetails(
              name: achDetails['billingDetails']['name'],
              email: achDetails['billingDetails']['email'],
            );

            final paymentMethodParams = PaymentMethodParams.usBankAccount(
              paymentMethodData: PaymentMethodDataUsBank(
                accountNumber: achDetails['accountNumber'],
                routingNumber: achDetails['routingNumber'],
                accountHolderType:
                    achDetails['accountHolderType'] == 'individual'
                        ? BankAccountHolderType.Individual
                        : BankAccountHolderType.Company,
                billingDetails: billingDetails,
              ),
            );

            String? descriptorCode;

            await Stripe.instance
                .confirmPayment(
              paymentIntentClientSecret: paymentIntentData['clientSecret'],
              data: paymentMethodParams,
            )
                .then((confirmPaymentIntent) async {
              descriptorCode = await showDialog<String>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      TextEditingController otpController =
                          TextEditingController();
                      return AlertDialog(
                        title: Text("Verify Bank Account OTP"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: otpController,
                              maxLength: 6,
                              decoration: InputDecoration(
                                labelText: "Enter 6-digit OTP",
                                counterText: "",
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Validate OTP
                              if (otpController.text.length == 6) {
                                Navigator.of(context)
                                    .pop(otpController.text); // Return the OTP
                              } else {
                                // Show error if OTP is invalid
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Invalid OTP. Please enter a valid 6-digit code.")),
                                );
                              }
                            },
                            child: Text("Submit"),
                          ),
                        ],
                      );
                    },
                  ) ??
                  '';
            });

            // write the code for open alert dialouge to enter otp of six digit code with validation and after when we enter the descripterCode get final payment intent for further process
            if (descriptorCode!.isNotEmpty) {
              finalPaymentIntent =
                  await Stripe.instance.verifyPaymentIntentWithMicrodeposits(
                isPaymentIntent: true,
                clientSecret: paymentIntentData['clientSecret'],
                params:
                    VerifyMicroDepositsParams(descriptorCode: descriptorCode),
              );
            } else {
              return {
                'status': 'failed',
                'transactionId': paymentIntentData['id'],
                'amount': amount,
                'datetime': DateTime.now().toIso8601String(),
                'paymentType': paymentType,
                'error': 'Payment cancelled due to invalid OTP'
              };
            }

            debugPrint('final payment intent: $finalPaymentIntent');
          }
        }

        if (finalPaymentIntent?.status == PaymentIntentsStatus.Succeeded) {
          debugPrint('payment is succeeded: finalPaymentIntent?.Succeeded');
          return {
            'status': 'success',
            'transactionId': finalPaymentIntent?.id,
            'amount': amount,
            'datetime': DateTime.now().toIso8601String(),
            'paymentType': paymentType,
          };
        } else if (finalPaymentIntent?.status ==
            PaymentIntentsStatus.Processing) {
          debugPrint('payment is processing: finalPaymentIntent?.Processing');
          return {
            'status': 'processing',
            'transactionId': paymentIntentData['id'],
            'amount': amount,
            'datetime': DateTime.now().toIso8601String(),
            'paymentType': paymentType,
          };
        } else {
          debugPrint('payment is failed: finalPaymentIntent?.failed');
          return {
            'status': 'failed',
            'transactionId': paymentIntentData['id'],
            'amount': amount,
            'datetime': DateTime.now().toIso8601String(),
            'paymentType': paymentType,
            'error': finalPaymentIntent?.description ?? 'Something went wrong'
          };
        }
      }
    } catch (e) {
      String errorMessage = "An unknown error occurred.";

      if (e is StripeException) {
        errorMessage = e.error.localizedMessage ?? "An unknown error occurred.";
      }

      debugPrint('Payment failed: $errorMessage');
      return {
        'status': 'failed',
        'error': errorMessage,
      };
    }
  }

  Future<Map<String, dynamic>?> showACHDetailsDialog({
    required BuildContext context,
    required String userName,
    required String userEmail,
  }) async {
    final accountNumberController = TextEditingController();
    final routingNumberController = TextEditingController();
    final accountHolderTypeController = ValueNotifier<String>('individual');
    final billingNameController = TextEditingController(text: userName);
    final billingEmailController = TextEditingController(text: userEmail);

    final formKey = GlobalKey<FormState>();
    final ValueNotifier<bool> isSubmitting = ValueNotifier<bool>(false);

    return await showDialog<Map<String, dynamic>?>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter ACH Details'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Account Number For Testing: '000123456789'
                  TextFormField(
                    controller: accountNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Account Number',
                      hintText: 'Enter your account number',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Account number is required';
                      }
                      if (value.length < 8) {
                        return 'Account number must be at least 8 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  // Routing Number For Testing '110000000'
                  TextFormField(
                    controller: routingNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Routing Number',
                      hintText: 'Enter your routing number',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Routing number is required';
                      }
                      if (value.length != 9) {
                        return 'Routing number must be 9 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  // Account Holder Type
                  DropdownButtonFormField<String>(
                    value: accountHolderTypeController.value,
                    decoration: const InputDecoration(
                      labelText: 'Account Holder Type',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'individual',
                        child: Text('Individual'),
                      ),
                      DropdownMenuItem(
                        value: 'company',
                        child: Text('Company'),
                      ),
                    ],
                    onChanged: (value) {
                      accountHolderTypeController.value = value ?? 'individual';
                    },
                  ),
                  const SizedBox(height: 10),
                  // Optional Billing Details (Name)
                  TextFormField(
                    controller: billingNameController,
                    decoration: const InputDecoration(
                      labelText: 'Billing Name (Optional)',
                      hintText: 'Leave blank to use default',
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Optional Billing Details (Email)
                  TextFormField(
                    controller: billingEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Billing Email (Optional)',
                      hintText: 'Leave blank to use default',
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final emailRegex = RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
                        if (!emailRegex.hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isSubmitting,
              builder: (context, loading, child) {
                return ElevatedButton(
                  onPressed: loading
                      ? null
                      : () async {
                          if (formKey.currentState?.validate() ?? false) {
                            isSubmitting.value = true;
                            await Future.delayed(
                                const Duration(seconds: 2)); // Simulate delay
                            isSubmitting.value = false;
                            Navigator.of(context).pop({
                              'accountNumber': accountNumberController.text,
                              'routingNumber': routingNumberController.text,
                              'accountHolderType':
                                  accountHolderTypeController.value,
                              'billingDetails': {
                                'name': billingNameController.text.isNotEmpty
                                    ? billingNameController.text
                                    : userName,
                                'email': billingEmailController.text.isNotEmpty
                                    ? billingEmailController.text
                                    : userEmail,
                              },
                            });
                          }
                        },
                  child: loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Submit'),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
