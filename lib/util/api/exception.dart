import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/exception_page.dart';

class _BaseException implements Exception {
  _BaseException({this.msg = "Error occurred"});

  String msg;

  @override
  String toString() => msg;
}

class CancellationException extends _BaseException {
  CancellationException({this.message = "Request cancellation"})
      : super(msg: message);
  String message;
}

class TimeoutException extends _BaseException {
  TimeoutException({this.message = "Timeout"}) : super(msg: message);
  String message;
}

class NoInternetException extends _BaseException {
  NoInternetException(
      {this.message =
          "No connection available, please check network connection"})
      : super(msg: message);
  String message;
}

class UatUpdateException extends _BaseException {
  UatUpdateException(
      {this.message =
          "You will receive new app update with in a hour, we are working on it. Meanwhile please use our smart bazaar web portal."})
      : super(msg: message);
  String message;
}

class LocalApkException extends _BaseException {
  LocalApkException(
      {this.message =
          "Please uninstall and install smart bazaar application from google play console"})
      : super(msg: message);
  String message;
}

class ResponseException extends _BaseException {
  final int? code;
  String? message;

  ResponseException({required this.code, this.message})
      : super(msg: message ?? "Response exception");
}

class SocketException extends _BaseException {
  SocketException({this.message = "Connection has been interrupted"})
      : super(msg: message);
  String message;
}

class FormatException extends _BaseException {
  FormatException(
      {this.message = "Invalid format (Unable to process the data)"})
      : super(msg: message);
  String message;
}

class InternalServerException extends _BaseException {
  InternalServerException(
      {this.message = "Internal server error, Please contact with admin"})
      : super(msg: message);
  String message;
}

class UnableToProcessResponseException extends _BaseException {
  UnableToProcessResponseException(
      {this.message = "Unable to process : Not type of;"})
      : super(msg: message);
  String message;
}

class UnknownException extends _BaseException {
  UnknownException({this.message = "Unknown exception"}) : super(msg: message);
  String message;
}

class UnauthorizedException extends _BaseException {
  UnauthorizedException(
      {this.message =
          "Unauthorized Access! Session has expired please login again."})
      : super(msg: message);
  String message;
}

class BadRequestException extends _BaseException {
  BadRequestException({this.message = "Bad Api Request"}) : super(msg: message);
  String message;
}

class SessionExpireException extends _BaseException {
  SessionExpireException(
      {this.message = "Session Key Expired, Please Login Again !."})
      : super(msg: message);
  String message;
}

getDioException(error) {
  if (error is Exception) {
    try {
      Exception e;
      if (error is DioError) {
        if ((error.response?.statusCode ?? 0) == 401) {
          return UnauthorizedException();
        }

        if ((error.response?.statusCode ?? 0) == 400) {
          return BadRequestException();
        }

        switch (error.type) {
          case DioErrorType.cancel:
            e = CancellationException();
            break;
          case DioErrorType.connectTimeout:
            e = TimeoutException();
            break;
          case DioErrorType.other:
            if (error.error is NoInternetException) {
              e = NoInternetException();
            } else if (error.error is SessionExpireException) {
              e = SessionExpireException(message: error.message);
            } else {
              e = SocketException();
            }
            break;
          case DioErrorType.receiveTimeout:
            e = TimeoutException();
            break;
          case DioErrorType.response:
            if (error.response == null) {
              e = ResponseException(code: 500, message: "Internal sever error");
            } else if (error.response!.statusCode == 500) {
              e = InternalServerException();
            } else {
              e = ResponseException(
                  code: error.response!.statusCode,
                  message: error.response!.statusMessage.toString() +
                      "\n" +
                      error.message);
            }

            break;
          case DioErrorType.sendTimeout:
            e = TimeoutException();
            break;
        }
      } else if (error is SocketException) {
        e = SocketException();
      } else if (error is UatUpdateException) {
        e = UatUpdateException();
      }
      else if (error is LocalApkException) {
        e = LocalApkException();
      }
      else {
        e = UnknownException(message: error.toString());
      }
      return e;
    } on FormatException catch (e) {
      return FormatException(message: e.toString());
    } catch (error) {
      return UnknownException(message: error.toString());
    }
  } else {
    if (error.toString().contains("is not a subtype of")) {
      return UnableToProcessResponseException(message: error.toString());
    } else {
      return UnknownException(message: error.toString());
    }
  }
}

handleException(e) {
  Get.to(() => ExceptionPage(error: e));
}
