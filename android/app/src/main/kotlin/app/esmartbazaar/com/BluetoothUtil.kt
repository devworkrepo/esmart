package app.esmartbazaar.com

import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.Intent


object BluetoothUtil {

    private var bluetoothAdapter: BluetoothAdapter? = null

    @SuppressLint("MissingPermission")
    fun isEnable(context: MainActivity): Boolean {
        initAdapter(context)
        val isEnable =  bluetoothAdapter!!.isEnabled
        return if(isEnable) true
        else{
            requestEnable(context)
            false
        }
    }


    @SuppressLint("MissingPermission")
    private fun requestEnable(context: MainActivity) {
        initAdapter(context)
        val intentBtEnabled = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
        context.startActivityForResult(
            intentBtEnabled,
            AppConstant.BLUETOOTH_LAUNCH_RESULT_CODE
        )
    }

    private fun initAdapter(context: Context) {
        if (bluetoothAdapter == null)
            bluetoothAdapter =
                (context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager).adapter

    }


    @SuppressLint("MissingPermission")
    fun isDevicePairedWithMachine(context : MainActivity): Boolean {
        initAdapter(context)
        val boundedDevices = bluetoothAdapter!!.bondedDevices
        boundedDevices.forEach {
            if (it.name.startsWith("VM30")) {
                return true
            }
        }
        return false
    }

}