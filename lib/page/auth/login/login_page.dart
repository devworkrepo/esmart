import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/util/hex_color.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/check_box.dart';
import 'package:esmartbazaar/widget/common/background_image.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/page/auth/login/login_controller.dart';
import 'package:esmartbazaar/page/update_widget.dart';

import '../../../route/route_name.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());

    return const AppBackgroundImage(
      child: AppUpdateWidget(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _LoginForm(),
        ),
      ),
    );
  }
}

class _LoginForm extends GetView<LoginController> {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(32),
      child: SingleChildScrollView(
        child: Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                _appLogo(),

                Form(
                    key: controller.loginFormKey,
                    child: Column(
                      children: [
                        MobileTextField(
                          controller: controller.mobileController,
                        ),
                        PasswordTextField(
                          controller: controller.passwordController,
                        ),
                        AppCheckBox(
                            title: "Remember Login",
                            value: controller.isLoginCheck.value,
                            onChange: (value) {
                              controller.isLoginCheck.value = value;
                            }),
                        const SizedBox(
                          height: 16,
                        ),

                        Row(children: [

                          Expanded(child: SizedBox(
                            height: 40,
                            child: ElevatedButton(

                              onPressed: (){
                              controller.login();
                            }, child: Text("Login",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                fontSize: 13
                              ),),),
                          )),
                          // const SizedBox(width: 4,),
                          // Expanded(child: SizedBox(
                          //     height: 40,
                          //     child: ElevatedButton(onPressed: (){
                          //       controller.login(subRetailerLogin: true);
                          //     }, child: Text("Sub-Merchant Login",
                          //       style: TextStyle(
                          //           fontWeight: FontWeight.w400,
                          //         fontSize: 13
                          //       ),),
                          //       style: ElevatedButton.styleFrom(
                          //           primary: Colors.blue
                          //       ),))),
                        ],),
                        SizedBox(height: 24,)

                        // Padding(
                        //   padding: const EdgeInsets.only(top: 24,bottom: 5),
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //        Text("Don't have Sub-Merchant account? ",style: TextStyle(
                        //         fontSize: 12,
                        //         color: Colors.grey[600]
                        //       ),),
                        //        SizedBox(height: 3,),
                        //        GestureDetector(
                        //          onTap: ()=>Get.dialog(const _SingUpDetailDialog()),
                        //          child: Text("Sign Up Now",style: Get.textTheme.subtitle2?.copyWith(
                        //           fontWeight: FontWeight.w500,
                        //            color: Colors.blue[600],
                        //            fontSize: 12
                        //       ),),
                        //        )
                        //     ],
                        //   ),
                        // )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoginTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      child: Text(
        "The Future of Fintech",
        textAlign: TextAlign.center,
        style: Get.textTheme.bodyText1?.copyWith(
            color: Get.theme.primaryColor, fontWeight: FontWeight.w600),
      ),
    );
  }

  _appLogo() => Container(
        color: Colors.transparent,
        child: Image.asset(
          "assets/icon/logo3.png",
          height: 120,
          width: 140,
          fit: BoxFit.fill,
        ),
      );
}

class _SingUpDetailDialog extends StatelessWidget {
  const _SingUpDetailDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Image.asset("assets/image/logo.png",height: 50,),
              ),
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
               Text(
                 "Singup & Get Started!",
                 style: Get.textTheme.headline1?.copyWith(
                     fontWeight: FontWeight.bold, color: Colors.black),
               ),

               Text(
                 "Open your merchant account in seconds.",
                 style:
                 Get.textTheme.subtitle1?.copyWith(color: Colors.grey[700],fontWeight: FontWeight.w500),
               ),
             ],),
              const SizedBox(
                height: 16
              ),
              _buildItem(
                  title: "Fast Execution : ",
                  subTitle:
                      "99.9% of our transfers are ready with in 2-3 sec."),
              _buildItem(
                  title: "Guide & Support : ",
                  subTitle:
                      "24*7 dedicated support through Calls, Emails, and Live Chat."),
              _buildItem(
                  title: "Financial Secure :  ",
                  subTitle:
                      "We use industry leading technology to protect your money."),


              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(children: [
                    Text("By clicking Sing Up, you agree to our",style: Get.textTheme.caption,),
                    Text("Terms and Conditions",
                    style: Get.textTheme.caption?.copyWith(fontWeight: FontWeight.w500,
                    color: Colors.blue),),
                  ],),
                ),
              ),

              SizedBox(height: 12,),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green
                  ),
                  onPressed: (){
                    Get.back();
                    Get.toNamed(AppRoute.signupPage);
                  },
                  child: const Text("SignUp Now"),),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem({required String title, required String subTitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 10,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: title,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' $subTitle',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.grey[600],
                          height: 1.4)),
                    ],
                  ),
                ),
              )
            ],
          ),
          Divider(indent: 0,color: Colors.grey.shade300,)
        ],
      ),
    );
  }
}
