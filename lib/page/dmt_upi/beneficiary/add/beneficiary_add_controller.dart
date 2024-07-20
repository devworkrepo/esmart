import 'package:esmartbazaar/model/dmt/upi_mobile_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/upi_repo.dart';
import 'package:esmartbazaar/data/repo_impl/upi_repo_impl.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

import '../../../../model/dmt/response.dart';
import '../../../../model/dmt/upi_bank_list.dart';
import '../../../../util/api/resource/resource.dart';
import '../../../../util/validator.dart';

class UpiBeneficiaryAddController extends GetxController {
  UpiRepo repo = Get.find<UpiRepoImpl>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyAddUpiLinkedMobile = GlobalKey<FormState>();
  var senderMobile = Get.arguments["mobile"];
  var upiIdController = TextEditingController();
  var upiNameController = TextEditingController();
  var mobileController = TextEditingController();
  var isVerify = false.obs;
  var verifiedDetail = {"name": "", "upi": "", "extension": ""};

  Rx<PaymentMethod?> selectedMethod = PaymentMethod.bankUpi.obs;
  Rx<UpiBank?> selectedUpiBank = Rx<UpiBank?>(null);

  final RxList<UpiBank> selectedUpiList = <UpiBank>[].obs;

  var upiBankListResponseObs = Resource.onInit(data: UpiBankListResponse()).obs;

  var _upiBankList = <UpiBank>[];

  var selectedTab = AddQRTab.addUpiId.obs;

  Rx<UpiMobileUpiResponse?> searchResultObs = Rx<UpiMobileUpiResponse?>(null);



  var qrResultObs = {
    "isVerified" : false,
    "isScanned" : false,
    "name" : "",
    "upiId" : "",
  }.obs;



  @override
  void onInit() {
    super.onInit();

    selectedMethod.listen((method) {
      selectedUpiList.clear();
      selectedUpiBank.value = null;
      _setupUpiBankList(method);
      _setVerifyUpi();
    });

    _fetchUpiBankList();

    upiIdController.addListener(() {
      _setVerifyUpi();
    });
  }

  _setVerifyUpi() {
    if (upiIdController.text.toString() == verifiedDetail["upi"] &&
        selectedUpiBank.value!.upi_name! == verifiedDetail["extension"] &&
        upiIdController.text.toString().isNotEmpty &&
        selectedUpiBank.value != null) {
      isVerify.value = true;
    } else {
      isVerify.value = false;
    }
  }

  _fetchUpiBankList() async {
    upiBankListResponseObs.value = const Resource.onInit();
    try {
      final response = await repo.upiBankList();
      List<UpiBank>? bankUpiList = response.bankList
          ?.where((value) => value.bankname == "Bank")
          .toList();
      if (bankUpiList != null) {
        selectedUpiList.addAll(bankUpiList);
        _upiBankList = response.bankList!;
        selectedUpiBank.value = _upiBankList.first;
      }
      upiBankListResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      upiBankListResponseObs.value = Resource.onFailure(e);
    }
  }

  _setupUpiBankList(PaymentMethod? method) async {
    var bankName = "Bank";
    if (method == PaymentMethod.bankUpi) {
      bankName = "Bank";
    } else if (method == PaymentMethod.phonePe) {
      bankName = "Phonepe";
    } else if (method == PaymentMethod.googlePay) {
      bankName = "Google Pay";
    } else if (method == PaymentMethod.paytm) {
      bankName = "Paytm";
    } else if (method == PaymentMethod.amazonPay) {
      bankName = "Amazon Pay";
    }
    List<UpiBank>? bankUpiList =
        _upiBankList.where((value) => value.bankname == bankName).toList();
    selectedUpiList.value = bankUpiList;
    selectedUpiBank.value = bankUpiList.first;
  }

  @override
  void dispose() {
    upiIdController.dispose();
    upiNameController.dispose();
    selectedMethod.close();

    super.dispose();
  }

  void verifyUpiId() async {
    if (!formKey.currentState!.validate()) return;

    try {
      StatusDialog.progress();
      final transactionNumberResult = await repo.fetchTransactionNumber();
      final upiId = upiIdController.text.toString() +
          selectedUpiBank.value!.upi_name.toString();

      final param = {
        "beneid": "0",
        "remitter_mobile": senderMobile,
        "upiid": upiId,
        "transno": transactionNumberResult.transactionNumber
      };

      final response = await repo.verifyAccount(param);
      Get.back();
      if (response.code == 1) {
        verifiedDetail = {
          "name": response.beneficiaryName.toString(),
          "upi": upiIdController.text.toString(),
          "extension": selectedUpiBank.value!.upi_name.toString()
        };
        isVerify.value = true;
        StatusDialog.success(title: "Beneficiary Verified");
      } else {
        verifiedDetail = {
          "name": "",
          "upi": "",
          "extension": "",
        };
        isVerify.value = false;
        StatusDialog.alert(title: response.message);
      }
    } catch (e) {
      isVerify.value = false;
      Get.back();
      StatusDialog.alert(title: "Something went wrong!");
    }
  }

  void addBeneficiary() async {
    final param = {
      "remitter_mobile": senderMobile,
      "upiid": verifiedDetail["upi"]!.toString()+verifiedDetail["extension"]!.toString(),
      "name": verifiedDetail["name"],
      "validate_status" : "Success"
    };

    try {
      StatusDialog.progress();
      final response = await repo.addBeneficiary(param);
      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message)
            .then((value) => Get.back(result: true));
      } else {
        StatusDialog.alert(title: response.message);
      }
    } catch (e) {
      Get.back();
      StatusDialog.alert(title: "Something went wrong!");
    }
  }

  getUpiSelectedIcon(PaymentMethod method) {
    iconPath(name) {
      return "assets/upi_icons/$name.png";
    }

    switch (method) {
      case PaymentMethod.bankUpi:
        return iconPath("allbanks");
      case PaymentMethod.amazonPay:
        return iconPath("amazon");
      case PaymentMethod.googlePay:
        return iconPath("gpay");
      case PaymentMethod.paytm:
        return iconPath("paytm");
      case PaymentMethod.phonePe:
        return iconPath("phonepe");
      default:
        return iconPath("allbanks");
    }
  }

  onBankSelect(String value) {
    var data = selectedUpiList.firstWhere((element) => element.upi_name == value);
    selectedUpiBank.value = data;
    _setVerifyUpi();
  }

  onTabClick(AddQRTab tab) {
    selectedTab.value = tab;
  }

  String getTabTitle(AddQRTab tab) {
    switch(tab){
      case AddQRTab.addUpiId:
        return "Add UPI Id";
      case AddQRTab.addUpiIdLinkedMobile:
        return "UPI Linked Mobile";
      case AddQRTab.scanQR:
        return "Scan QR Code";
      default :
        return "Add UPI Id";
    }
  }

  void searchMobile() async{

    if(!formKeyAddUpiLinkedMobile.currentState!.validate()) return;
    searchResultObs.value = null;

    try{
      StatusDialog.progress();
      final transactionNumberResult = await repo.fetchTransactionNumber();
      final param = {
        "remitter_mobile" : senderMobile,
        "upi_mobile" : mobileController.text.toString(),
        "transno" : transactionNumberResult.transactionNumber};

      final result = await repo.searchUpiListWithMobile(param);
      Get.back();

      if(result.code ==1){
        searchResultObs.value = result;
      }
      else{
        searchResultObs.value = UpiMobileUpiResponse();
        StatusDialog.alert(title: result.message);
      }
    }catch(e){
      Get.back();
    }


  }
  void addBeneficiaries() async{

    final mList = searchResultObs.value?.upiList?.where((element) => element.isSelected);
    if(mList == null || mList.isEmpty){
      StatusDialog.alert(title: "Please select at least one upi id!");
      return;
    }

    StatusDialog.progress();
    var anySuccess = false;
    for (var element in mList) {
       final result =  await addBeneficiary2(element.vpa_name,searchResultObs.value!.bene_name);
       if(!anySuccess && result) anySuccess = true;
    }

    Get.back();

   if(anySuccess){
     StatusDialog.success(title: "Success").then((value) => Get.back(result: true));
   }
   else{
     StatusDialog.alert(title: "Something went wrong");
   }

  }

  Future<bool> addBeneficiary2(upiId,name) async {
    final param = {
      "remitter_mobile": senderMobile,
      "upiid": upiId,
      "name": name,
      "validate_status" : "Success"
    };

    try {
      final response = await repo.addBeneficiary(param);
      if (response.code == 1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
     return false;
    }
  }

  void verifyQRUpiId() async{
    try {
      StatusDialog.progress();
      final transactionNumberResult = await repo.fetchTransactionNumber();


      final param = {
        "beneid": "0",
        "remitter_mobile": senderMobile,
        "upiid": qrResultObs["upiId"],
        "transno": transactionNumberResult.transactionNumber
      };

      final response = await repo.verifyAccount(param);
      Get.back();
      if (response.code == 1) {
        qrResultObs.value = {
          "isVerified" : true,
          "isScanned" : true,
          "name" : response.beneficiaryName.toString(),
          "upiId" : qrResultObs["upiId"].toString(),
        };
        StatusDialog.success(title: "Beneficiary Verified");
      } else {

        StatusDialog.alert(title: response.message);
      }
    } catch (e) {
      Get.back();
      StatusDialog.alert(title: "Something went wrong!");
    }
  }

  void addQRUpiId() async{
    final param = {
      "remitter_mobile": senderMobile,
      "upiid": qrResultObs["upiId"],
      "name": qrResultObs["name"],
      "validate_status" : "Success"
    };

    try {
      StatusDialog.progress();
      final response = await repo.addBeneficiary(param);
      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message)
            .then((value) => Get.back(result: true));
      } else {
        StatusDialog.alert(title: response.message);
      }
    } catch (e) {
      Get.back();
      StatusDialog.alert(title: "Something went wrong!");
    }
  }
}

enum PaymentMethod { phonePe, paytm, googlePay, amazonPay, bankUpi }
enum  AddQRTab { addUpiId,addUpiIdLinkedMobile,scanQR }
