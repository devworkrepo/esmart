# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

-keepattributes Signature
-keepattributes Annotation
-dontwarn sun.misc.**
-keep class com.fingpay.microatmsdk.data.** {
    <fields>;
    public <methods>;
}
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}


-keepclassmembernames interface * {
    @retrofit.http.* <methods>;
}
-keep class retrofit.** { *; }

-keepnames class * extends android.os.Parcelable
-keepnames class * extends java.io.Serializable

#okhttp3
-keepattributes Signature
-keepattributes *Annotation*
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-keep class org.xmlpull.v1.** { *;}
 -dontwarn org.xmlpull.v1.**

-dontwarn okhttp3.**


-dontwarn org.xmlpull.v1.XmlPullParser
-dontwarn org.xmlpull.v1.XmlSerializer
-keep class org.xmlpull.v1.* {*;}


#credopay
-keep class in.credopay.**{
<fields>;
public <methods>;
}
-keepclassmembers class in.credopay.** { <fields>; }
-keepclassmembers class in.credopay.payment.sdk.ApiRequest { <fields>;
}
-keepclassmembers class in.credopay.payment.sdk.ApiResponse { <fields>;
}
-keepclassmembers class in.credopay.payment.sdk.ApiRequest$IsoData {
<fields>; }
-keepclassmembers class in.credopay.payment.sdk.ApiResponse$IsoData {
<fields>; }
-keepclassmembers class in.credopay.payment.sdk.ApiResponse$IsoData {
<fields>; }
-keepclassmembers class in.credopay.payment.sdk.ApiErrorResponse {
<fields>; }
-keepclassmembers class in.credopay.payment.sdk.TransactionModel {
<fields>; }
-keepclassmembers class in.credopay.payment.sdk.TransactionResponse {
<fields>; }

-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
