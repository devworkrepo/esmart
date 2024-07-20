import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/money_request/pg_payment_mode.dart';
import 'package:esmartbazaar/page/pg/payment_gateway_controller.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/obx_widget.dart';
import 'package:esmartbazaar/widget/common.dart';
import 'package:esmartbazaar/widget/common/amount_background.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../util/validator.dart';
import '../../widget/button.dart';
import '../../widget/drop_down.dart';
import '../../widget/text_field.dart';

class PaymentGatewayPage extends GetView<PaymentGatewayController> {
  const PaymentGatewayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PaymentGatewayController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() => Text((controller.isWebViewMode.value)
              ? "Payment Gateway"
              : "Add Fund Online")),
        ),
        body: ObsResourceWidget<PgPaymentModeResponse>(
            obs: controller.paymentModeResponseObs,
            childBuilder: (data) => Obx(() => (controller.isWebViewMode.value)
                ? _webViewWidget()
                : _formWidget(data))),
      ),
    );
  }

  _formWidget(PgPaymentModeResponse data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 24, right: 24, left: 24),
                child: SizedBox(
                  width: Get.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Text("Fill Details",
                          style: Get.textTheme.subtitle1
                              ?.copyWith(color: Get.theme.primaryColor)),
                      const SizedBox(
                        height: 16,
                      ),
                      AmountTextField(
                        controller: controller.amountController,
                        onChange: (value) => controller.onAmountChange(value),
                        validator: (value) => FormValidatorHelper.amount(value,
                            minAmount: 100, maxAmount: 1000000),
                      ),
                      AppTextField(
                        controller: controller.remarkController,
                        label: "Remark",
                        validator: (value) => FormValidatorHelper.empty(value),
                      ),
                      AppDropDown(
                        label: "Payment Mode",
                        list: controller.getPaymentListAsString(data.chglist),
                        onChange: (value) {
                          controller.onPaymentModeChange(value);
                        },
                        validator: (value) {
                          if (controller.paymentMode == null) {
                            return "Select Payment Mode";
                          } else {
                            return null;
                          }
                        },
                      ),
                      Obx(() => (!controller.validateCharge())
                          ? const SizedBox()
                          : Column(
                              children: [
                                const SizedBox(
                                  height: 12,
                                ),
                                AmountBackgroundWidget(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Charge",
                                          style: Get.textTheme.headline6,
                                        ),
                                        Text(
                                          " : ",
                                          style: Get.textTheme.headline6,
                                        ),
                                        Text(
                                          "₹ ${controller.pgChargeObs.value.charges.toString()}",
                                          style: Get.textTheme.headline6,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      const SizedBox(
                        height: 24,
                      ),
                      AppButton(
                          text: "Submit & Proceed",
                          onClick: controller.onSubmit)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _webViewWidget() {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,

        onPageStarted: (url) {
          if (url == "https://todo.in/Default.aspx" ||
              url == "https://todo.in/Default.aspx/" ||
              url == "https://todo.in" ||
              url == "https://todo.in/") {
            Get.offNamed(AppRoute.fundReportPage,
                arguments: {"is_pending": false});
          }
        },
        onWebViewCreated: (WebViewController webViewController) {
          controller.webViewController = webViewController;
        },
        initialUrl: controller.pgUrl,
        onPageFinished: (url) {});
  }
}
