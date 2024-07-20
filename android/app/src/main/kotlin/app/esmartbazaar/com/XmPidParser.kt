package app.esmartbazaar.com


import org.xmlpull.v1.XmlPullParser
import org.xmlpull.v1.XmlPullParserException
import org.xmlpull.v1.XmlPullParserFactory
import java.io.IOException
import java.io.StringReader


object XmPidParser {

    const val TAG = "XMLTESTING"

    @Throws(XmlPullParserException::class, IOException::class)
    fun parse(xml: String?): Array<String> {


        val factory = XmlPullParserFactory.newInstance()
        factory.isNamespaceAware = true
        val xmlPullParser = factory.newPullParser()
        xmlPullParser.setInput(StringReader(xml))
        val respStrings = arrayOf("na", "na")
        var eventType = xmlPullParser.eventType
        while (eventType != XmlPullParser.END_DOCUMENT) {
            if (eventType == XmlPullParser.START_DOCUMENT) {
                println("Start document")
            }
            else if (eventType == XmlPullParser.START_TAG) {
                if (xmlPullParser.name.equals("Resp", ignoreCase = true)) {
                    val count = xmlPullParser.attributeCount
                    for (i in 0 until count) {
                        val attributeName = xmlPullParser.getAttributeName(i)
                        println(attributeName)
                        if (attributeName.equals("errCode", ignoreCase = true)) {
                            respStrings[0] = xmlPullParser.getAttributeValue(i)
                            println("errCode : " + xmlPullParser.getAttributeValue(i))
                        }
                        if (attributeName.equals("errInfo", ignoreCase = true)) {
                            respStrings[1] = xmlPullParser.getAttributeValue(i)
                            println("errInfo : " + xmlPullParser.getAttributeValue(i))
                        }
                    }
                }
            }
            eventType = xmlPullParser.next()
        }
        return respStrings
    }

    fun getDeviceSerialNumber(data: String): String {

        var serialNumber = ""
        try {
            val factory =
                XmlPullParserFactory.newInstance()
            factory.isNamespaceAware = true
            val xpp = factory.newPullParser()
            xpp.setInput(StringReader(data))
            var eventType = xpp.eventType

            var isPidDataTag = false

            while (eventType != XmlPullParser.END_DOCUMENT) {
                when (eventType) {
                    XmlPullParser.START_DOCUMENT -> {

                    }
                    XmlPullParser.START_TAG -> {
                        if (xpp.name == "Data") isPidDataTag = true
                    }
                    XmlPullParser.END_TAG -> {
                        if (xpp.name == "Param") {
                            val name = xpp.getAttributeValue(null, "name")
                            if (name == "srno") {
                                serialNumber = xpp.getAttributeValue(null, "value");
                            }
                        }

                    }
                    XmlPullParser.TEXT -> {
                        /*if(isPidDataTag) {
                            AppLog.d("pidata : ${xpp.text}")
                            isPidDataTag = !isPidDataTag
                        }*/
                    }
                }
                eventType = xpp.next()
            }

        } catch (e: XmlPullParserException) {
            e.printStackTrace()
        } catch (e: IOException) {
            e.printStackTrace()
        } finally {
            return serialNumber
        }
    }


    fun parseAirtelData(data: String): HashMap<String, String>? {

        try {
            val factory = XmlPullParserFactory.newInstance()
            factory.isNamespaceAware = true
            val xpp = factory.newPullParser()
            xpp.setInput(StringReader(data))
            var eventType = xpp.eventType


            var hMac: String? = null
            var pidData: String? = null
            var deviceCode: String? = null
            var modelId: String? = null
            var providerCode: String? = null
            var certificateCode: String? = null
            var serviceId: String? = null
            var deviceVersion: String? = null
            var sKey: String? = null
            var sKeyCI: String? = null
            var sKeyNMPoints: String? = null
            var sKeyQScore: String? = null
            var deviceSerialNumber: String? = null

            var isPidTagFound = false
            var isHmacTagFound = false
            var isSkeyTagFound = false

            while (eventType != XmlPullParser.END_DOCUMENT) {
                when (eventType) {
                    XmlPullParser.START_DOCUMENT -> {}
                    XmlPullParser.START_TAG -> {
                        if (xpp.name == "DeviceInfo") {
                            deviceCode = deviceCode ?: xpp.getAttributeValue(null, "dc")
                            modelId = modelId ?: xpp.getAttributeValue(null, "mi")
                            providerCode = providerCode ?: xpp.getAttributeValue(null, "dpId")
                            certificateCode = certificateCode ?: xpp.getAttributeValue(null, "mc")
                            serviceId = serviceId ?: xpp.getAttributeValue(null, "rdsId")
                            deviceVersion = deviceVersion ?: xpp.getAttributeValue(null, "rdsVer")
                        }
                        if (xpp.name == "Param") {
                            val name = xpp.getAttributeValue(null, "name")
                            if (name == "srno")
                                deviceSerialNumber =
                                    deviceSerialNumber ?: xpp.getAttributeValue(null, "value");

                        }
                        if (xpp.name == "Skey") sKeyCI = sKeyCI ?: xpp.getAttributeValue(null, "ci")
                        if (xpp.name == "Resp") sKeyNMPoints = sKeyNMPoints ?: xpp.getAttributeValue(null, "nmPoints")
                        if (xpp.name == "Resp") sKeyQScore = sKeyQScore ?: xpp.getAttributeValue(null, "qScore")
                        if (xpp.name == "Data") isPidTagFound = true
                        if (xpp.name == "Hmac") isHmacTagFound = true
                        if (xpp.name == "Skey") isSkeyTagFound = true

                    }
                    XmlPullParser.END_TAG -> {}
                    XmlPullParser.TEXT -> {
                        if (isPidTagFound) pidData = pidData ?: xpp.text
                        if (isHmacTagFound) hMac = hMac ?: xpp.text
                        if (isSkeyTagFound) sKey = sKey ?: xpp.text
                    }
                }
                eventType = xpp.next()
            }

            println("mPidDataInfo -----> "+data)

            return hashMapOf(
                "hMac" to (hMac ?: ""),
                "pidData" to (pidData ?: ""),
                "deviceCode" to (deviceCode ?: ""),
                "modelId" to (modelId ?: ""),
                "providerCode" to (providerCode ?: ""),
                "certificateCode" to (certificateCode ?: ""),
                "serviceId" to (serviceId ?: ""),
                "deviceVersion" to (deviceVersion ?: ""),
                "sKey" to (sKey ?: ""),
                "sKeyCI" to (sKeyCI ?: ""),
                "sKeyNMPoints" to (sKeyNMPoints ?: ""),
                "sKeyQScore" to (sKeyQScore ?: ""),
                "deviceSerialNumber" to (deviceSerialNumber ?: ""),
            )

        } catch (e: XmlPullParserException) {
            e.printStackTrace()
        } catch (e: IOException) {
            e.printStackTrace()
        }
        return null
    }

}