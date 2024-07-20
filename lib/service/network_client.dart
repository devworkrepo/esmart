import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/util/api/exception.dart';
import 'package:esmartbazaar/util/app_constant.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/util/security/encription.dart';

class NetworkClient {
  late var dio = Dio();
  final Connectivity connectivity;
  final AppPreference appPreference;
  static const timeoutInSecond = 0;

  final _options = BaseOptions(
      baseUrl: AppConstant.baseUrl,
      connectTimeout: timeoutInSecond,
      receiveTimeout: timeoutInSecond,
      maxRedirects: 0,
      followRedirects: false,
      sendTimeout: timeoutInSecond,
      contentType: "application/x-www-form-urlencoded");

  NetworkClient(this.connectivity, this.appPreference) {
    dio.options = _options;

    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          logPrint: (value) => AppUtil.logger(value.toString())));
    }

    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        AppUtil.logger(response.data.toString());

        if (response.statusCode == 200) {
          if (response.data is List) {
            final mData = response.data;
            return handler.next(response
              ..data = {
                "code": 1,
                "status": "Success",
                "message": "List Found",
                "data": mData
              });
          }

          try {
            int status = response.data["code"];
            String? message = response.data["message"];
            if (status == 101) {
              throw SessionExpireException(
                  message:
                       "Session Key Expired, Please Login Again !.");
            } else {
              return handler.next(response);
            }
          } catch (e) {
            throw throw SessionExpireException(
                message: "Session Key Expired, Please Login Again !.");
          }
        } else {
          return handler.next(response);
        }
      },
      onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        var connectivityResult = await connectivity.checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          return handler.reject(
              DioError(requestOptions: options, error: NoInternetException()));
        }
        _options.headers = {
          "Authorization": "Bearer " + Encryption.encryptMPIN(appPreference.sessionKey),
          "Accept": "application/json"
        };
        return handler.next(options);
      },
    ));
  }

  Future<Response<T>> post<T>(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      bool isAdditionalData = true}) async {


    var additionalData = {
      "dvckey": await AppUtil.getDeviceID(),
      "sessionkey": Encryption.encryptMPIN(appPreference.sessionKey),
    };
    if (data == null) {
      data = additionalData;
    } else {
      if (data is Map) {
        if(isAdditionalData) data.addAll(additionalData);
      }
    }

    return dio.post(path,
        data: data,
        options: _getOptionWithToken(options),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return dio.get(path,
        queryParameters: queryParameters,
        options: _getOptionWithToken(options),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
  }

  _getOptionWithToken(Options? options) {
    var token = Encryption.encryptMPIN(appPreference.sessionKey);
    if (options != null) {
      options.headers?.addAll({"Authorization": "Bearer $token"});
    } else {
      options = Options(headers: {"Authorization": "Bearer $token"});
    }
    return options;
  }
}
