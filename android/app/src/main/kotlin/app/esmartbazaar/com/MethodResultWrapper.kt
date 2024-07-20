package app.esmartbazaar.com

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodChannel
import java.lang.Exception


class MethodResultWrapper (private val methodResult : MethodChannel.Result): MethodChannel.Result {

    private var handler: Handler? = null

    init {
        handler = Handler(Looper.getMainLooper())
    }

    override fun success(result: Any?) {
        try{
            handler?.post {

                try{
                    methodResult.success(result)
                }catch (e : Exception){

                }

            }
        }catch (e : Exception){

        }
    }

    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
        try{
            handler?.post {
                try {
                    methodResult.error(errorCode, errorMessage, errorDetails)
                }catch (e : Exception){
                    android.util.Log.d("NativeAndroidException", "nativeError1: ${e.message.toString()}")
                }
            }
        }catch (e : Exception){
            android.util.Log.d("NativeAndroidException", "nativeError2: ${   e.message.toString()}")
        }
    }



    override fun notImplemented() {
        try{
            handler?.post {
                try{
                     methodResult.notImplemented()
                }catch (e : Exception){

                }
            }
        }catch (e : Exception){

        }

    }
}