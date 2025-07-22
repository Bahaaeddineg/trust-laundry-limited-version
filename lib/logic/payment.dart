import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/my_address.dart';
import '../models/product.dart';
import '../constants/strings.dart';
import '../models/order.dart';
import '../ui/home/home_screen.dart';
import '../widgets/snack_bar.dart';

import '../constants/colors.dart';
import '../generated/l10n.dart';
import '../ui/payment/payment_webview.dart';

class PaymentService {
  static const String chargeUrl = 'https://api.tap.company/v2/charges';

  static Future<void> createCharge({
    required PaymentFor paymentFor,
    required double amount,
    required String currency,
    MyAddress? address,
    required String description,
    required BuildContext context,
    UserOrder? order,
    List<MyProduct>? prods,
    double? get,
  }) async {
    final dio = Dio();
    dio.options.headers = {
      'Authorization': 'Bearer ${await ApiKeyManager.decryptKey(apii)}',
      'accept': 'application/json',
      'content-type': 'application/json',
    };
    try {
      final response = await dio.post(
        chargeUrl,
        data: {
          "amount": amount,
          "currency": "KWD",
          "customer": {
            "first_name": "test",
            "middle_name": "test",
            "last_name": "test",
            "email": "test@test.com",
            "phone": {"country_code": 965, "number": 51234567}
          },
          "source": {"id": "src_all"},
          "redirect": {
            "url":
                "https://docs.google.com/document/d/1XeAWwlpdY5JaL8M7wu-bhRIlmkBcP_BEYn0k2ch8mWU/edit?usp=sharing"
          }
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final transactionUrl = responseData["transaction"]['url'];
        final transactionId = responseData['id'];

        if (transactionUrl != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentWebView(
                paymentUrl: transactionUrl,
                paymentFor: paymentFor,
                txnId: transactionId,
                get: get,
                address: address,
                pay: amount,
                prods: prods,
                order: order,
              ),
            ),
          );
        }
      } else {
        CustomSnackBar.show(context, S.of(context).tryAgain, AppColors.kRed);
      }
    } catch (error) {}
  }
}
