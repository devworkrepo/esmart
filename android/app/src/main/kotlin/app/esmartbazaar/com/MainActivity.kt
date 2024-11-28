package app.esmartbazaar.com

import `in`.credopay.payment.sdk.CredopayPaymentConstants
import `in`.credopay.payment.sdk.PaymentActivity
import `in`.credopay.payment.sdk.Utils
import android.content.Intent
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat
import app.esmartbazaar.com.R
import app.esmartbazaar.com.AppConstant.AEPS_SERVICE_METHOD_NAME
import app.esmartbazaar.com.AppConstant.BLUETOOTH_CHECK_ENABLE
import app.esmartbazaar.com.AppConstant.BLUETOOTH_CHECK_PAIRED
import app.esmartbazaar.com.AppConstant.CREDO_PAY_METHOD_NAME
import app.esmartbazaar.com.AppConstant.MATM_SERVICE_METHOD_NAME
import app.esmartbazaar.com.AppConstant.METHOD_CHANNEL
import app.esmartbazaar.com.AppConstant.RD_SERVICE_SERIAL_NUMBER
import app.esmartbazaar.com.AppConstant.ROOT_CHECKER_METHOD_NAME
import app.esmartbazaar.com.AppConstant.UPI_PAYMENT
import app.esmartbazaar.com.AppConstant.UPI_PAYMENT_RESULT_CODE
import app.esmartbazaar.com.AppConstant.DMT_TWO_AUTH_PID_DATA
import com.fingpay.microatmsdk.MicroAtmLoginScreen
import com.fingpay.microatmsdk.utils.Constants
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*


class MainActivity : FlutterFragmentActivity() {

    private var result: MethodChannel.Result? = null;


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            METHOD_CHANNEL
        ).setMethodCallHandler { call, rawResult ->

            result = MethodResultWrapper(rawResult)

            when {
                call.method.equals(AEPS_SERVICE_METHOD_NAME) -> {
                    captureAepsPidData(call)
                }
                call.method.equals(MATM_SERVICE_METHOD_NAME) -> {
                    tramoMatm(call)
                }
                call.method.equals(ROOT_CHECKER_METHOD_NAME) -> {
                    rootCheck()
                }
                call.method.equals(RD_SERVICE_SERIAL_NUMBER) -> {

                    val mData =
                        XmPidParser.getDeviceSerialNumber(
                            call.argument<String>("pidData") ?: ""
                        )
                    result!!.success(mData)

                }
                call.method.equals(CREDO_PAY_METHOD_NAME) -> {
                    credoPayMatm(call)
                }

                call.method.equals(BLUETOOTH_CHECK_ENABLE) -> {
                    bluetoothCheckEnable(call)
                }

                call.method.equals(BLUETOOTH_CHECK_PAIRED) -> {
                    bluetoothCheckPaired(call)
                }

                call.method.equals(UPI_PAYMENT) -> {
                    upiPayment(call)
                }
                call.method.equals(DMT_TWO_AUTH_PID_DATA) -> {
                    captureDmtTwoAuthPidData(call)
                }


            }
        }
    }

    private fun bluetoothCheckEnable(call: MethodCall) {

        val isEnableEnable = BluetoothUtil.isEnable(this)
        result?.success(isEnableEnable)

    }

    private fun bluetoothCheckPaired(call: MethodCall) {
        val isPaired = BluetoothUtil.isDevicePairedWithMachine(this)
        result?.success(isPaired)
    }

    private fun rootCheck() {
        val isRooted = RootChecker.isDeviceRooted
        result?.success(isRooted)
    }

    private fun tramoMatm(call: MethodCall) {
        try {
            val merchantUserId = call.argument<String>("merchantUserId")
            val merchantPassword = call.argument<String>("merchantPassword")
            val superMerchantId = call.argument<String>("superMerchantId")
            val amount = call.argument<String>("amount")
            val remark = call.argument<String>("remark")
            val mobileNumber = call.argument<String>("mobileNumber")
            val txnId = call.argument<String>("txnId")
            val imei = call.argument<String>("imei")
            val latitude = call.argument<Double>("latitude")
            val longitude = call.argument<Double>("longitude")
            val type = call.argument<Int>("type")


            val intent = Intent(
                this@MainActivity,
                MicroAtmLoginScreen::class.java
            ).apply {
                putExtra(Constants.MERCHANT_USERID, merchantUserId)
                putExtra(Constants.MERCHANT_PASSWORD, merchantPassword)
                putExtra(Constants.SUPER_MERCHANTID, superMerchantId)
                putExtra(Constants.AMOUNT, amount)
                putExtra(Constants.REMARKS, remark)
                putExtra(Constants.MOBILE_NUMBER, mobileNumber)
                putExtra(Constants.AMOUNT_EDITABLE, false)
                putExtra(Constants.TXN_ID, txnId)

                putExtra(Constants.IMEI, imei)
                putExtra(Constants.LATITUDE, latitude)
                putExtra(Constants.LONGITUDE, longitude)
                putExtra(Constants.TYPE, type?.toInt())
            }
            startActivityForResult(intent, AppConstant.MATM_LAUNCH_RESULT_CODE)
        } catch (e: Exception) {
        }
    }

    private fun credoPayMatm(call: MethodCall) {
        try {

            val loginId = call.argument<String>("loginId")
            val password = call.argument<String>("password")
            val transactionType = call.argument<String>("transactionType")
            val amount = call.argument<Int>("amount")
            val tid = call.argument<String>("tid")
            val crnU = call.argument<String>("crnU")
            val mobileNumber = call.argument<String>("mobileNumber")
            val debugMode = call.argument<Boolean>("debugMode")
            val production = call.argument<Boolean>("production")


            AppUtil.logD("Request Param CredoPay : " + loginId)
            AppUtil.logD("Request Param CredoPay : " + password)
            AppUtil.logD("Request Param CredoPay : " + amount)
            AppUtil.logD("Request Param CredoPay : " + tid)
            AppUtil.logD("Request Param CredoPay : " + mobileNumber)
            AppUtil.logD("Request Param CredoPay : " + debugMode.toString())
            AppUtil.logD("Request Param CredoPay : " + production.toString())


            val mTxnType = when (transactionType?.uppercase()) {
                "MATM" -> CredopayPaymentConstants.MICROATM
                "BE" -> CredopayPaymentConstants.BALANCE_ENQUIRY
                "PURCHASE" -> CredopayPaymentConstants.PURCHASE
                "CASH_AT_POS" -> CredopayPaymentConstants.CASH_AT_POS
                "UPI" -> CredopayPaymentConstants.UPI
                "VOID" -> CredopayPaymentConstants.VOID
                else -> 0
            }


            val intent = Intent(
                this@MainActivity,
                PaymentActivity::class.java
            ).apply {


                putExtra("TRANSACTION_TYPE", mTxnType)
                putExtra("DEBUG_MODE", debugMode)
                putExtra("PRODUCTION", production)
                putExtra("AMOUNT", amount)
                putExtra("LOGIN_ID", loginId)
                putExtra("LOGIN_PASSWORD", password)
                putExtra("TID", tid)
                putExtra("CRN_U", crnU)
                putExtra("CUSTOM_FIELD1", crnU)
                putExtra("MOBILE_NUMBER", mobileNumber)
                putExtra(
                    "LOGO", Utils.getVariableImage(
                        ContextCompat.getDrawable(
                            applicationContext,
                            R.drawable.splash
                        )
                    )
                )
            }
            startActivityForResult(intent, AppConstant.CREDO_PAY_LAUNCH_RESULT_CODE)
        } catch (e: Exception) {

            AppUtil.logD("CredoPay Exception : " + e.stackTrace)
        }
    }

    private fun captureAepsPidData(call: MethodCall) {

        val rdServicePackageUrl = call.argument<String>("packageUrl")
        val isTransaction = call.argument<Boolean>("isTransaction") ?: true
        val provider = call.argument<String>("provider") ?: "tramo"
        try {
            val intent = Intent()
            intent.setPackage(rdServicePackageUrl)
            intent.action = AppConstant.Aeps.INTENT_ACTION
            intent.putExtra(
                "PID_OPTIONS",
                if (isTransaction) AppConstant.Aeps.PID_OPTION else AppConstant.Aeps.PID_OPTION_KYC
            )
            var resultCode = AppConstant.AEPS_TRAMO_RESULT_CODE
            if (provider == "airtel") resultCode = AppConstant.AEPS_AIRTEL_RESULT_CODE
            else if(provider == "common") resultCode = AppConstant.AEPS_COMMON_RESULT_CODE

            startActivityForResult(intent, resultCode)
        } catch (e: Exception) {

        }
    }

    private fun captureDmtTwoAuthPidData(call: MethodCall) {

        val rdServicePackageUrl = call.argument<String>("packageUrl")

        try {
            val intent = Intent()
            intent.setPackage(rdServicePackageUrl)
            intent.action = AppConstant.Aeps.INTENT_ACTION
            intent.putExtra("PID_OPTIONS", AppConstant.Aeps.PID_OPTION_DMT_AUTH)
            val resultCode = AppConstant.DMT_TWO_AUTH_PID_DATA_REQUEST_CODE
            startActivityForResult(intent, resultCode)
        } catch (e: Exception) {

        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)


        if (AppConstant.CREDO_PAY_LAUNCH_RESULT_CODE == requestCode) {
            handleCredoPaymentResult(
                requestCode, resultCode, data
            )
        }

        if (resultCode != RESULT_CANCELED && data != null && resultCode == RESULT_OK) {
            when (requestCode) {
                AppConstant.AEPS_TRAMO_RESULT_CODE -> handleTramoRDResult(
                    requestCode,
                    resultCode,
                    data
                )

                AppConstant.DMT_TWO_AUTH_PID_DATA_REQUEST_CODE -> handleDmtTwoAuthPidDataResult(
                    requestCode,
                    resultCode,
                    data
                )

                AppConstant.AEPS_COMMON_RESULT_CODE -> handleCommonAEPSResult(
                    requestCode,
                    resultCode,
                    data
                )
                AppConstant.AEPS_AIRTEL_RESULT_CODE -> handleAirtelRDResult(
                    requestCode,
                    resultCode,
                    data
                )
                AppConstant.MATM_LAUNCH_RESULT_CODE -> handleMatmResult(
                    requestCode,
                    resultCode,
                    data
                )

            }
        } else {
            result?.error("101", "Result delivered with black response", "data is null");
        }

        if (requestCode == UPI_PAYMENT_RESULT_CODE) handUpiResult(data, resultCode)


    }

    private fun handUpiResult(data: Intent?, resultCode: Int) {
        result?.success(
            hashMapOf(
                "code" to 1,
                "message" to "Transaction",
            )
        )
    }


    private fun handleCredoPaymentResult(requestCode: Int, resultCode: Int, data: Intent?) {


        fun onTransactionCompleted() {
            if (data != null) {
                AppUtil.logD("CredoPay Response Result Code: ${data!!.toString()}")
                val rrn: String = data.getStringExtra("rrn") ?: ""
                val transactionId: String = data.getStringExtra("transaction_id") ?: ""
                val maskedPan: String = data.getStringExtra("masked_pan") ?: ""
                val tc: String = data.getStringExtra("tc") ?: ""
                val tvr: String = data.getStringExtra("tvr") ?: ""
                val tsi: String = data.getStringExtra("tsi") ?: ""
                val approvalCode: String = data.getStringExtra("approval_code") ?: ""
                val network: String = data.getStringExtra("network") ?: ""
                val cardApplicationName: String = data.getStringExtra("card_application_name") ?: ""
                val cardHolderName: String = data.getStringExtra("card_holder_name") ?: ""
                val appVersion: String = data.getStringExtra("app_version") ?: ""
                val cardType: String = data.getStringExtra("card_type") ?: ""
                val accountBalance: String = data.getStringExtra("account_balance") ?: ""
                val transactionType: String = data.getStringExtra("transaction_type") ?: ""
                val customFieldOne: String = data.getStringExtra("custom_field_1") ?: ""

                result?.success(
                    hashMapOf(
                        "code" to 1,
                        "message" to "Transaction Success",
                        "rrn" to rrn,
                        "transactionId" to transactionId,
                        "maskedPan" to maskedPan,
                        "tc" to tc,
                        "tvr" to tvr,
                        "tsi" to tsi,
                        "approvalCode" to approvalCode,
                        "network" to network,
                        "cardApplicationName" to cardApplicationName,
                        "cardHolderName" to cardHolderName,
                        "appVersion" to appVersion,
                        "cardType" to cardType,
                        "accountBalance" to accountBalance,
                        "transactionType" to transactionType,
                        "custom_field_1" to customFieldOne,
                    )
                )
            } else {
                result?.success(
                    hashMapOf(
                        "code" to 3,
                        "message" to "Transaction InProgress"
                    )
                )
            }
        }

        fun onTransactionFailed() {
            val error: String = data?.getStringExtra("error") ?: "Transaction Failure"
            result?.success(
                hashMapOf(
                    "code" to 2,
                    "message" to error
                )
            )
        }

        fun onPasswordChanged() {
            result?.success(
                hashMapOf(
                    "code" to 0,
                    "type" to "CHANGE_PASSWORD",
                    "message" to "On password changed !"
                )
            )
        }

        fun onPasswordChangeFailed() {
            result?.success(
                hashMapOf(
                    "code" to 0,
                    "type" to "PASSWORD_CHANGE_FAILED",
                    "message" to "On password change failed !"
                )
            )
        }

        fun onLoginFailed() {
            result?.success(
                hashMapOf(
                    "code" to 0,
                    "type" to "LOGIN_FAILED",
                    "message" to "Login failed !"
                )
            )
        }


        when (resultCode) {
            CredopayPaymentConstants.TRANSACTION_COMPLETED -> onTransactionCompleted()
            CredopayPaymentConstants.TRANSACTION_CANCELLED -> onTransactionFailed()
            CredopayPaymentConstants.VOID_CANCELLED -> onTransactionFailed()
            CredopayPaymentConstants.CHANGE_PASSWORD -> onPasswordChanged()
            CredopayPaymentConstants.CHANGE_PASSWORD_SUCCESS -> onPasswordChanged()
            CredopayPaymentConstants.CHANGE_PASSWORD_FAILED -> onPasswordChangeFailed()
            CredopayPaymentConstants.LOGIN_FAILED -> onLoginFailed()
        }

        AppUtil.logD("CredoPay Response RequestCode: $requestCode")
        AppUtil.logD("CredoPay Response Result Code: $resultCode")


    }

    private fun handleTramoRDResult(requestCode: Int, resultCode: Int, data: Intent?) {

        val exceptionMessage = "Captured failed, please check biometric device is connected!";
        val mData = data!!.getStringExtra("PID_DATA")
        if (mData != null) {
            try {
                val respString = XmPidParser.parse(mData)
                if (respString[0].equals("0", ignoreCase = true)) {
                    result!!.success(mData)
                } else {
                    result!!.error("99", exceptionMessage, respString[1])
                }
            } catch (e: java.lang.Exception) {
                result!!.error("99", exceptionMessage, "parsing failed")
            }
        } else {
            result!!.error("99", exceptionMessage, "result is null")
        }
    }

    private fun handleDmtTwoAuthPidDataResult(requestCode: Int, resultCode: Int, data: Intent?) {

        val exceptionMessage = "Captured failed, please check biometric device is connected!";
        val mData = data!!.getStringExtra("PID_DATA")
        if (mData != null) {
            try {
                val respString = XmPidParser.parse(mData)
                if (respString[0].equals("0", ignoreCase = true)) {
                    result!!.success(mData)
                } else {
                    result!!.error("99", exceptionMessage, respString[1])
                }
            } catch (e: java.lang.Exception) {
                result!!.error("99", exceptionMessage, "parsing failed")
            }
        } else {
            result!!.error("99", exceptionMessage, "result is null")
        }
    }

    private fun handleCommonAEPSResult(requestCode: Int, resultCode: Int, data: Intent?) {

        val exceptionMessage = "Captured failed, please check biometric device is connected!";
        val mData = data!!.getStringExtra("PID_DATA")
        if (mData != null) {
            try {
                result!!.success(mData)
            } catch (e: java.lang.Exception) {
                result!!.error("99", exceptionMessage, "parsing failed")
            }
        } else
            result!!.error("99", exceptionMessage, "result is null")

    }

    private fun handleAirtelRDResult(requestCode: Int, resultCode: Int, data: Intent?) {

        val exceptionMessage = "Captured failed, please check biometric device is connected!";
        val mData = data!!.getStringExtra("PID_DATA")
        if (mData != null) {
            try {
                Log.d("AirtelTesting", "PidData: $mData")
                val resultMap = XmPidParser.parseAirtelData(mData)
                if (resultMap == null)
                    result!!.error("99", exceptionMessage, "parsing failed")
                else {
                    Log.d("AirtelTesting", "handleAirtelRDResult: $resultMap")
                    result!!.success(resultMap)
                }

            } catch (e: java.lang.Exception) {
                result!!.error("99", exceptionMessage, "parsing failed")
            }
        } else
            result!!.error("99", exceptionMessage, "result is null")

    }

    private fun handleMatmResult(requestCode: Int, resultCode: Int, data: Intent?) {
        val exceptionMessage =
            "Unable to parse result data for micro-atm activity, please contact with admin!";

        try {
            val status: Boolean = data?.getBooleanExtra(Constants.TRANS_STATUS, false) ?: false
            val transAmount: Double = data?.getDoubleExtra(Constants.TRANS_AMOUNT, 0.0) ?: 0.0
            val balAmount: Double = data?.getDoubleExtra(Constants.BALANCE_AMOUNT, 0.0) ?: 0.0
            val bankRrn: String = data?.getStringExtra(Constants.RRN) ?: ""
            val bankName: String = data?.getStringExtra(Constants.BANK_NAME) ?: ""
            val cardNumber: String = data?.getStringExtra(Constants.CARD_NUM) ?: ""
            val message: String = data?.getStringExtra(Constants.MESSAGE) ?: ""
            val time: String = data?.getStringExtra(Constants.TIME_STAMP) ?: ""


            result?.success(
                hashMapOf(
                    "status" to status,
                    "transAmount" to transAmount,
                    "balAmount" to balAmount,
                    "bankRrn" to bankRrn,
                    "bankName" to bankName,
                    "cardNumber" to cardNumber,
                    "message" to message,
                    "time" to time,
                )
            )
        } catch (e: Exception) {

            result?.error(
                "99",
                exceptionMessage,
                "Result not available, please contact with admin"
            )
        }
    }


    private fun upiPayment(call: MethodCall) {


        try {
            val refId = call.argument<String>("refId")
            val amount = call.argument<String>("amount")
            val mobileNumber = call.argument<String>("mobile")
            val shopName = call.argument<String>("shopName")

            val uri = Uri.parse("upi://pay").buildUpon()
                .appendQueryParameter("pa", "20220330383551@yesbank")
                .appendQueryParameter("pn", "E-Smart Bazaar TECHNOLOGY PRIVATE LIMITED")
                .appendQueryParameter("tn", "$shopName - $mobileNumber")
                .appendQueryParameter("am", amount)
                .appendQueryParameter("cu", "INR")
                .appendQueryParameter("tr", "101012")
                .build()

            val upiPayIntent = Intent(Intent.ACTION_VIEW)
            upiPayIntent.data = uri
            val chooser = Intent.createChooser(upiPayIntent, "Pay with")
            if (null != chooser.resolveActivity(packageManager))
                startActivityForResult(chooser, UPI_PAYMENT_RESULT_CODE)
            else showToast("No UPI app found, please install one to continue")
        } catch (e: Exception) {
            AppUtil.logD("Upi payment result : exception ${e.stackTraceToString()}")
        }
    }

/*    private fun handUpiResult(data: Intent?, resultCode: Int) {
        AppUtil.logD("onUpiPaymentResult : result code : $resultCode")
        if (data == null) return
        val resposne = data.getStringExtra("response")
        //Log.d("UPI", "onActivityResult: " + trxt);
        //Log.d("UPI", "onActivityResult: " + trxt);
        val dataList: ArrayList<String?> = ArrayList()
        AppUtil.logD("UpiPaymentResponse : $resposne")
        dataList.add(resposne)
        upiPaymentDataOperation(dataList);

    }

    private fun upiPaymentDataOperation(data: ArrayList<String?>) {

        var str = data[0]
        var paymentCancel = ""
        if (str == null) str = "discard"
        var status = ""
        var approvalRefNo = ""
        val response = str.split("&").toTypedArray()
        for (i in response.indices) {
            val equalStr = response[i].split("=").toTypedArray()
            if (equalStr.size >= 2) {
                if (equalStr[0].lowercase(Locale.getDefault()) == "Status".lowercase(Locale.getDefault())) {
                    status = equalStr[1].lowercase(Locale.getDefault())
                } else if (equalStr[0].lowercase(Locale.getDefault()) == "ApprovalRefNo".lowercase(
                        Locale.getDefault()
                    ) || equalStr[0].lowercase(Locale.getDefault()) == "txnRef".lowercase(
                        Locale.getDefault()
                    )
                ) {
                    approvalRefNo = equalStr[1]
                }
            } else {
                paymentCancel = "Payment cancelled by user."
            }
        }
        if (status == "success") {
            showToast("Transaction successful")
        } else if ("Payment cancelled by user." == paymentCancel) {
            showToast("Payment cancelled by user.")
        } else {
            showToast("Transaction failed")
        }
    }*/

}
