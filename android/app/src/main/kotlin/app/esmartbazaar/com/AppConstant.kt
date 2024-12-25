package app.esmartbazaar.com

object AppConstant {


    const val METHOD_CHANNEL = "app.esmartbazaar.com"
    const val AEPS_SERVICE_METHOD_NAME = "launch_aeps_service"
    const val LAUNCH_FACE_CAPTURE = "launch_face_capture"
    const val RD_SERVICE_SERIAL_NUMBER = "rd_service_serial_number"
    const val AEPS_TRAMO_RESULT_CODE = 1000
    const val AEPS_COMMON_RESULT_CODE = 2000
    const val AEPS_AIRTEL_RESULT_CODE = 1400
    const val MATM_SERVICE_METHOD_NAME = "launch_matm_service"
    const val MATM_LAUNCH_RESULT_CODE = 1100
    const val UPI_PAYMENT_RESULT_CODE = 1500
    const val ROOT_CHECKER_METHOD_NAME= "root_checker_service"
    const val CREDO_PAY_METHOD_NAME= "credo_pay_service"
    const val CREDO_PAY_LAUNCH_RESULT_CODE = 1200
    const val BLUETOOTH_LAUNCH_RESULT_CODE = 1300
    const val BLUETOOTH_CHECK_ENABLE = "bluetooth_check_enable"
    const val BLUETOOTH_CHECK_PAIRED = "bluetooth_check_paired"
    const val UPI_PAYMENT = "upi_payment"
    const val DMT_TWO_AUTH_PID_DATA = "dmt_two_auth_pid_data"
    const val DMT_TWO_AUTH_PID_DATA_REQUEST_CODE = 2000
    const val FACE_CAPTURE_RESULT_CODE = 1800




    object Aeps {
        const val PID_OPTION = """<PidOptions ver="1.0">
       <Opts env="P" fCount="1" fType="2" format="0" iCount="0" iType="0" pCount="0" pType="0" pidVer="2.0" posh="UNKNOWN" timeout="10000"/>
    </PidOptions>"""
        const val INTENT_ACTION = "in.gov.uidai.rdservice.fp.CAPTURE"

        const val PID_OPTION_KYC = """
        <PidOptions ver="1.0"><Opts env="P" fCount="1" fType="2" iCount="0" format="0" pidVer="2.0" timeout="15000" wadh="E0jzJ/P8UopUHAieZn8CKqS4WPMi5ZSYXgfnlfkWjrc=" posh="UNKNOWN" /></PidOptions>
    """

        const val PID_OPTION_DMT_AUTH = """
        <PidOptions ver="1.0"><Opts env="P" fCount="1" fType="2" iCount="0" format="0" pidVer="2.0" timeout="15000" wadh="18f4CEiXeXcfGXvgWA/blxD+w2pw7hfQPY45JMytkPw=" posh="UNKNOWN" /></PidOptions>
    """


    }


}