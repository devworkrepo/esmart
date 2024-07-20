import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/route/route_name.dart';

class SingUpSuccessDialog extends StatelessWidget {
  const SingUpSuccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(64.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

            Container(
              height: 60,
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(width: 1, color: Colors.green)
              ),
              child: Icon(Icons.check,color: Colors.green,size: 42,),
            ),
              SizedBox(height: 12,),
              Text("You have successfully registered with us! Thank you for your time.",
              style: Get.textTheme.subtitle1?.copyWith(
                fontWeight: FontWeight.bold
              ),textAlign: TextAlign.center,),
              SizedBox(height: 8,),
              Text("Your login details has been sent to your registered mobile number through SMS.",
                style: Get.textTheme.caption?.copyWith(
                    fontWeight: FontWeight.w500
                ),textAlign: TextAlign.center,),
              
              const SizedBox(height: 12,),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.green
                ),
                onPressed: (){
                  Get.back();
                  Get.offAllNamed(AppRoute.loginPage);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children:  [
                    Text("Login Now"),
                    const Icon(Icons.chevron_right_outlined)
                  ],),
              )

          ],),
        ),
      ),
    );
  }
}
