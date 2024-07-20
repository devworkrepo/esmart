import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:esmartbazaar/page/investment/component/balance.dart';
import 'package:esmartbazaar/page/investment/create/create_investment_controller.dart';
import 'package:esmartbazaar/page/investment/review/review_investment_controller.dart';
import 'package:esmartbazaar/util/app_constant.dart';
import 'package:esmartbazaar/util/security/app_config.dart';
import 'package:esmartbazaar/widget/check_box.dart';
import 'package:esmartbazaar/widget/drop_down.dart';
import 'package:esmartbazaar/widget/text_field.dart';

class ReviewInvestmentPage extends GetView<ReviewInvestmentController> {
  const ReviewInvestmentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ReviewInvestmentController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review And Confirm"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              InvestmentBalanceWidget(controller.balance,showPanWarning: false,),
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children:  [
                            Expanded(
                              child: _TitleValue(
                                title: "Amount",
                                value: AppConstant.rupeeSymbol + (controller.amount),
                              ),
                            ),

                            Expanded(
                              child: _TitleValue(
                                title: "Tenure Duration",
                                value: controller.tenureDuration + " "+controller.tenureType,
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 8,),
                        Divider(indent: 0,),
                        SizedBox(height: 8,),
                        Row(
                          children:  [
                            Expanded(
                              child: _TitleValue(
                                title: "Interest Rate",
                                value: controller.calc.intrate.toString() + " %",
                              ),
                            ),

                            Expanded(
                              child: _TitleValue(
                                title: "Total Interest Amt.",
                                value: AppConstant.rupeeSymbol+ (controller.calc.intamt.toString()),
                              ),
                            ),

                          ],
                        ),
                        Divider(indent: 0,),
                        SizedBox(height: 8,),
                        Row(
                          children: [
                            Expanded(
                              child: _TitleValue(
                                title: "Maturity date",
                                value: controller.calc.maturedate.toString(),
                              ),
                            ),

                            Expanded(
                              child: _TitleValue(
                                title: "Maturity Amount",
                                value: AppConstant.rupeeSymbol+ (controller.calc.matureamt.toString()),
                                color: Colors.green,
                                fontSize: 22,
                              ),
                            ),

                          ],
                        ),
                        Divider(indent: 0,),
                        SizedBox(height: 16,),

                        MPinTextField(

                            label: "MPIN",
                            controller: controller.pinController),
                        SizedBox(height: 16,),
                        SizedBox(
                          height: 42,
                          child: SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                                onPressed: (){
                                  controller.onSubmit();
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.green
                                ),
                                child: Text("Submit")),
                          ),
                        )

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _TitleValue extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final int fontSize;
  const _TitleValue({required this.title, required this.value, this.color = Colors.black87,
    this.fontSize = 14,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Text(title,style: Get.textTheme.caption?.copyWith(fontWeight: FontWeight.w500),),
        Text(value,style: Get.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold,
        color: color,fontSize: fontSize.toDouble()),),
      ],
    );
  }
}
