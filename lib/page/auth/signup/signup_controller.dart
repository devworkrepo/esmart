import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/singup_repo.dart';
import 'package:esmartbazaar/data/repo_impl/singup_impl.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/singup/captcha_response.dart';
import 'package:esmartbazaar/model/singup/kyc_detail_response.dart';
import 'package:esmartbazaar/model/singup/kyc_otp_response.dart';
import 'package:esmartbazaar/model/singup/signup_state.dart';
import 'package:esmartbazaar/model/singup/verify_pan_response.dart';
import 'package:esmartbazaar/page/auth/signup/singup_success.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';
import 'package:esmartbazaar/util/picker_helper.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart' as dio;

import '../../../data/app_pref.dart';
import '../../../model/singup/final_signup_response.dart';
import '../../../widget/dialog/status_dialog.dart';

class SignupController extends GetxController with TransactionHelperMixin {
  AppPreference appPreference = Get.find();
  SignUpRepo repo = Get.find<SingUpRepoImpl>();

  String? selectedState;
  var mobileInputController = TextEditingController();
  var emailInputController = TextEditingController();
  var panInputController = TextEditingController();
  var cityInputController = TextEditingController();
  var pinCodeInputController = TextEditingController();
  var panInput2Controller = TextEditingController();
  var aadhaarInputController = TextEditingController();
  var mobileOtpController = TextEditingController();
  var emailOtpController = TextEditingController();
  var aadhaarOtpController = TextEditingController();
  var captchaController = TextEditingController();

  /*var docAadhaarController = TextEditingController();*/
  var docPanController = TextEditingController();
  var stepOneFormKey = GlobalKey<FormState>();

  var stepContactDetail = StepState.editing.obs;
  var stepMobileVerify = StepState.indexed.obs;
  var stepCaptchaVerify = StepState.indexed.obs;
  var stepAadhaarVerify = StepState.indexed.obs;
  var stepAadhaarDetail = StepState.indexed.obs;
  var stepPanVerification = StepState.indexed.obs;
  var stepUploadDoc = StepState.indexed.obs;

  var stepperCurrentIndex = 0.obs;

  var proceedButtonText = "Continue".obs;
  var captchaUrl = "".obs;
  var captchaUUID = "";
  var panName = "".obs;

  var detailFetched = false.obs;
  late SignUpKycDetailResponse aadhaarDetail;

  /* File? aadhaarFile;*/
  File? panFile;

  var stateListResponse = Resource
      .onInit(data: SignupStateListResponse())
      .obs;

  late List<SignupStateList> stateList;

  @override
  onInit(){
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _fetchStateList();
    });
  }

  _fetchStateList() async{
    try {
      stateListResponse.value = const Resource.onInit();
      final response =  await repo.getStateList();
      stateList = response.data;
    stateListResponse.value = Resource.onSuccess(response);
    } catch (e) {
    stateListResponse.value = Resource.onFailure(e);

    }
  }

  onContinue() {
    if (stepperCurrentIndex.value == 0) {
      bool result = stepOneFormKey.currentState!.validate();
      if (!result) {
        return;
      }

      stepContactDetail.value = StepState.complete;
      stepMobileVerify.value = StepState.editing;
      stepperCurrentIndex.value = 1;
      proceedButtonText.value = "Verify Mobile Number";
    } else if (stepperCurrentIndex.value == 1) {
      _verifyMobileNumber();
    } else if (stepperCurrentIndex.value == 2) {
      verifyCaptchaAndSendEKycOtp();
    } else if (stepperCurrentIndex.value == 3) {
      _verifyAadhaarOtp();
    } else if (stepperCurrentIndex.value == 4) {
      stepAadhaarDetail.value = StepState.complete;
      stepAadhaarDetail.value = StepState.editing;
      stepperCurrentIndex.value = 5;
      proceedButtonText.value = "";
    } else if (stepperCurrentIndex.value == 5) {
      stepPanVerification.value = StepState.complete;
      stepUploadDoc.value = StepState.editing;
      stepperCurrentIndex.value = 6;
      proceedButtonText.value = "   Submit   ";
    } else if (stepperCurrentIndex.value == 6) {


      /*if (aadhaarFile == null) {
        StatusDialog.alert(title: "Upload aadhaar file !");
        return;
      }*/
      if (panFile == null) {
        StatusDialog.alert(title: "Upload pan file !");
        return;
      }
      _finalSubmit();
    }
  }

  setCurrentStep() {}

  bool isStepperActive(int index) {
    return stepperCurrentIndex.value == index;
  }

  void _verifyMobileNumber() async {
    var mobileOtp = mobileOtpController.text.toString();
    if (mobileOtp.length != 6) {
      StatusDialog.alert(
          title: "Enter 6 digits valid Otp, sent to your mobile number");
      return;
    }

    var param = {
      "mobileno": mobileInputController.text.toString(),
      "otp": mobileOtpController.text.toString()
    };
    StatusDialog.progress(title: "Verifying...");
    try {
      CommonResponse response = await repo.verifyMobileOtp(param);
      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message).then((value) {
          stepMobileVerify.value = StepState.complete;
          stepCaptchaVerify.value = StepState.editing;
          stepperCurrentIndex.value = 2;
          proceedButtonText.value = "Verify Captcha";
          fetchCaptcha();
        });
      } else {
        StatusDialog.alert(title: response.message).then((value) {
          if (response.message.toLowerCase() == "mobile no already exists !") {
            stepContactDetail.value = StepState.editing;
            stepMobileVerify.value = StepState.disabled;
            stepperCurrentIndex.value = 0;
            proceedButtonText.value = "Continue";
          }
        });
      }
    } catch (e) {
      Get.back();
      StatusDialog.alert(
          title:
              "Something went wrong! please try again after sometime! thank you.");
    }
  }

  fetchCaptcha({bool reCaptcha = false}) async {
    //proceed
    StatusDialog.progress(title: "Fetching Captcha...");
    try {
      var mobileNumber = mobileInputController.text.toString();
      SignUpCaptchaResponse response = (reCaptcha)
          ? await repo
              .getReCaptcha({"mobileno": mobileNumber, "uuid": captchaUUID})
          : await repo.getCaptcha({"mobileno": mobileNumber});

      Get.back();
      if (response.code == 1) {
        captchaUUID = response.uuid ?? "";
        captchaUrl.value = response.captcha_img ?? "";
      } else {
        StatusDialog.alert(title: response.message);
      }
    } catch (e) {
      Get.back();
      StatusDialog.alert(
          title:
              "Something went wrong! please try again after sometime! thank you.");
    }
  }

  void sendMobileOtp() async {
    StatusDialog.progress(title: "Sending...");
    try {
      var mobileNumber = mobileInputController.text.toString();
      CommonResponse response =
          await repo.sendMobileOtp({"mobileno": mobileNumber});

      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message);
      } else {
        StatusDialog.alert(title: response.message);
      }
    } catch (e) {
      Get.back();
      StatusDialog.alert(
          title:
              "Something went wrong! please try again after sometime! thank you.");
    }
  }

  void verifyCaptchaAndSendEKycOtp({bool resendOtp = false}) async {
    var captcha = captchaController.text.toString();
    if (captcha.isEmpty) {
      StatusDialog.alert(title: "Please fill captcha");
      return;
    }

    var progressText =
        (resendOtp) ? "Resending Otp..." : "Verifying and Sending Otp";
    StatusDialog.progress(title: progressText);

    try {
      var param = {
        "mobileno": mobileInputController.text.toString(),
        "aadharno": aadhaarWithoutSymbol(aadhaarInputController),
        "captcha_txt": captchaController.text.toString(),
        "uuid": captchaUUID,
      };

      SignUpEKycResponse response = (resendOtp)
          ? await repo.resendEKycOtp(param)
          : await repo.sendEKycOtp(param);
      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message).then((value) {
          stepCaptchaVerify.value = StepState.complete;
          stepAadhaarVerify.value = StepState.editing;
          stepperCurrentIndex.value = 3;
          proceedButtonText.value = "Verify Aadhaar Otp";
        });
      } else {
        StatusDialog.alert(title: response.message);
      }
    } catch (e) {
      Get.back();
      StatusDialog.alert(
          title:
              "Something went wrong! please try again after sometime! thank you.");
    }
  }

  void _verifyAadhaarOtp() async {
    var aadhaarOtp = aadhaarOtpController.text.toString();
    if (aadhaarOtp.length != 6) {
      StatusDialog.alert(
          title:
              "Enter 6 digits aadhaar verification otp, sent to your register mobile number");
      return;
    }

    StatusDialog.progress(title: "Verifying OTP...");
    try {
      SignUpEKycResponse response = await repo.verifyEKycOtp({
        "mobileno": mobileInputController.text.toString(),
        "aadharno": aadhaarWithoutSymbol(aadhaarInputController),
        "uuid": captchaUUID,
        "otp": aadhaarOtpController.text.toString(),
      });

      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message).then((value) {
          captchaUUID = response.uuid ?? "";
          stepAadhaarVerify.value = StepState.complete;
          stepAadhaarDetail.value = StepState.editing;
          stepperCurrentIndex.value = 4;
          proceedButtonText.value = "";
          _fetchAadhaarDetail();
        });
      } else {
        StatusDialog.alert(title: response.message);
      }
    } catch (e) {
      Get.back();
      StatusDialog.alert(
          title:
              "Something went wrong! please try again after sometime! thank you.");
    }
  }

  verifyPanNumber() async {
    var aadhaarOtp = panInput2Controller.text.toString();
    if (aadhaarOtp.length != 10) {
      StatusDialog.alert(title: "Enter 10 characters valid PAN Number!");
      return;
    }

    StatusDialog.progress(title: "Verifying Pan...");
    try {
      SignUpVerifyPanResponse response = await repo.verifyPan({
        "panno": panInput2Controller.text.toString(),
      });

      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message).then((value) {
          panName.value = response.pan_name ?? "";
          proceedButtonText.value = "Continue";
        });
      } else {
        StatusDialog.alert(title: response.message);
      }
    } catch (e) {
      Get.back();
      StatusDialog.alert(
          title:
              "Something went wrong! please try again after sometime! thank you.");
    }
  }

  _fetchAadhaarDetail() async {
    StatusDialog.progress(title: "Fetching User Details");
    try {
      var response = await repo.getKycDetail({
        "mobileno": mobileInputController.text.toString(),
        "uuid": captchaUUID
      });
      Get.back();
      if (response.code == 1) {
        aadhaarDetail = response;
        proceedButtonText.value = "Continue";
        detailFetched.value = true;
      } else {
        StatusDialog.alert(title: response.message);
      }
    } catch (e) {
      Get.back();
      StatusDialog.alert(
          title:
              "Something went wrong! please try again after sometime! thank you.");
    }
  }

  showImagePickerBottomSheetDialog(SignUpFileType type) async {
    ImagePickerHelper.pickImageWithCrop((File? image) {
      /*  if (type == SignUpFileType.aadhaar) {
        aadhaarFile = image;
        if (image == null) {
          docAadhaarController.text = "";
        } else {
          var fileName = aadhaarFile!.path.split("/").last;
          var fileExtension = path.extension(fileName);
          docAadhaarController.text =
              "aadhaar_${DateTime.now().millisecondsSinceEpoch}" +
                  fileExtension;
        }
      }
      */
      // else {
      panFile = image;
      if (image == null) {
        docPanController.text = "";
      } else {
        var fileName = panFile!.path.split("/").last;
        var fileExtension = path.extension(fileName);
        docPanController.text =
            "pan_${DateTime.now().millisecondsSinceEpoch}" + fileExtension;
      }
      //}
    }, () {
      /*if (type == SignUpFileType.aadhaar) {
        aadhaarFile = null;
        docAadhaarController.text = "Uploading please wait...";
      } else {*/
      panFile = null;
      docPanController.text = "Uploading please wait...";
      //}
    });
  }

  _finalSubmit() async {
    StatusDialog.progress(title: "Submitting...");

    try {

     String picName = aadhaarDetail.picname.toString();
      picName =
          picName.replaceAll("https://todo.in//commonimg//user//", "");
      picName =
          picName.replaceAll("https://esmartbazaar.in//commonimg//user/", "");
      picName = picName.replaceAll("https://todo.in//commonimg/user/", "");
      picName = picName.replaceAll("https://todo.in/commonimg/user/", "");
      picName = picName.trim();

      String panNumber = panInput2Controller.text.toString();
      if (panNumber.isEmpty) panNumber = panInputController.text.toString();

      var state = stateList.firstWhere((element) => element.name == selectedState!);

      var param = {
        "mobileno": mobileInputController.text.toString(),
        "fullname": aadhaarDetail.name.toString(),
        "address": aadhaarDetail.address.toString(),
        "emailid": emailInputController.text.toString(),
        "gender": aadhaarDetail.gender.toString(),
        "dob": AppUtil.changeDateToMMDDYYYY(aadhaarDetail.dob ?? ""),
        "pan_no": panNumber,
        "aadhar_no": aadhaarWithoutSymbol(aadhaarInputController),
        "picname": picName,
        "stateid": state.id.toString(),
        "statename": state.name.toString(),
        "cityname": cityInputController.text.toString(),
        "pincode": pinCodeInputController.text.toString(),
      };

      var multiParam = dio.FormData.fromMap(param);

      SignUpResponse response = await repo.signUpUser(multiParam);
      Get.back();
      if (response.code == 1) {
        await Future.wait<CommonResponse?>([
         // _uploadAadhaarImage(response.regid),
          _uploadPanImage(response.regid)
        ]);

        Get.dialog(const SingUpSuccessDialog()).then((value) {
          Get.offAllNamed(AppRoute.loginPage);
        });
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {

      Get.back();
      StatusDialog.alert(
          title:
              "Something went wrong! please try again after sometime! thank you.");
    }
  }

  /*Future<CommonResponse?> _uploadAadhaarImage(String? regid) async {
    try {
      var filePath = aadhaarFile!.path;
      var fileName = docAadhaarController.text.toString();

      dio.MultipartFile? filePart =
          await dio.MultipartFile.fromFile(filePath, filename: fileName);

      var param = {"image1": filePart, "regid": regid.toString()};
      var multiParam = dio.FormData.fromMap(param);

      CommonResponse response = await repo.updateAadhaarImage(multiParam);
      return response;
    } catch (e) {
      return null;
    }
  }*/

  Future<CommonResponse?> _uploadPanImage(String? regid) async {
    try {
      var filePath = panFile!.path;
      var fileName = docPanController.text.toString();

      dio.MultipartFile? filePart =
          await dio.MultipartFile.fromFile(filePath, filename: fileName);

      String panNumber = panInput2Controller.text.toString();
      if (panNumber.isEmpty) panNumber = panInputController.text.toString();

      var param = {
        "image2": filePart,
        "regid": regid.toString(),
        "pan_no" : panNumber,
        "pan_name": panName.value
      };
      var multiParam = dio.FormData.fromMap(param);

      CommonResponse response = await repo.updatePanImage(multiParam);
      return response;
    } catch (e) {
      return null;
    }
  }
}

enum SignUpFileType { aadhaar, pan }
