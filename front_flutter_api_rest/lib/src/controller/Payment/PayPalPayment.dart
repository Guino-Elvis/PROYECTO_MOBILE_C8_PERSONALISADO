import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:front_flutter_api_rest/src/components/UiHelper.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';

import 'package:front_flutter_api_rest/src/services/payKey.dart';

class PayPalButton extends StatelessWidget {
  final String clientId = PaypalKey.YOUR_PAYPAL_CLIENT_ID;
  final String secret = PaypalKey.YOUR_PAYPAL_SECRET;
  final String retorno = PaypalKey.returnURL;
  final String cancelar = PaypalKey.cancelURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('hola'),
        ),
        body: Center(
          child: TextButton(
              onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => UsePaypal(
                          sandboxMode: true,
                          clientId: clientId,
                          secretKey: secret,
                          returnURL: retorno,
                          cancelURL: cancelar,
                          transactions: const [
                            {
                              "amount": {
                                "total": '10.12',
                                "currency": "USD",
                                "details": {
                                  "subtotal": '10.12',
                                  "shipping": '0',
                                  "shipping_discount": 0
                                }
                              },
                              "description":
                                  "The payment transaction description.",
                              // "payment_options": {
                              //   "allowed_payment_method":
                              //       "INSTANT_FUNDING_SOURCE"
                              // },
                              "item_list": {
                                "items": [
                                  {
                                    "name": "A demo product",
                                    "quantity": 1,
                                    "price": '10.12',
                                    "currency": "USD"
                                  }
                                ],

                                // shipping address is not required though
                                "shipping_address": {
                                  "recipient_name": "Jane Foster",
                                  "line1": "Travis County",
                                  "line2": "",
                                  "city": "Austin",
                                  "country_code": "US",
                                  "postal_code": "73301",
                                  "phone": "+00000000",
                                  "state": "Texas"
                                },
                              }
                            }
                          ],
                          note: "Contact us for any questions on your order.",
                          onSuccess: (Map params) async {
                            print("onSuccess: $params");
                            UiHelper.ShowAlertDialog(
                              'El pago fue Exitoso. Felicidades',
                              title: 'Exitoso',
                              buttonTitle: 'Ir al inicio',
                              navigateTo: AppRoutes.paySuccessRoute,
                            );
                          },
                          onError: (error) {
                            print("onError: $error");
                            UiHelper.ShowAlertDialog(
                              'Hubo un error con el pago. Inténtalo nuevamente.',
                              title: 'Error',
                              buttonTitle: 'Ok',
                              navigateTo: AppRoutes.pasarelaRoute,
                            );
                          },
                          onCancel: (params) {
                            print('cancelled: $params');
                            UiHelper.ShowAlertDialog(
                              'El pago fue cancelado',
                              title: 'Cancelado',
                              buttonTitle: 'Ok',
                              navigateTo: AppRoutes.pasarelaRoute,
                            );
                          },
                        ),
                      ),
                    )
                  },
              child: const Text("Make Payment")),
        ));
  }
}
