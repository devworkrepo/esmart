import 'package:esmartbazaar/model/banner.dart';
import 'package:esmartbazaar/model/cms_service.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/login_session.dart';
import 'package:esmartbazaar/model/profile.dart';
import 'package:esmartbazaar/model/qr_code/qrcode_response.dart';
import 'package:esmartbazaar/model/summary.dart';
import 'package:esmartbazaar/model/user/user.dart';

import '../../model/alert.dart';
import '../../model/app_update.dart';
import '../../model/notification.dart';

abstract class HomeRepo{

  Future<UserDetail> fetchAgentInfo();

  Future<BannerResponse> fetchBanners();

  Future<UserProfile> fetchProfileInfo();

  Future<TransactionSummary> fetchSummary();

  Future<LoginSessionResponse> fetchLoginSession();
  Future<CommonResponse> killSession(data);
  Future<CommonResponse> logout();

  Future<NotificationResponse> fetchNotification();

  Future<UserBalance> fetchUserBalance();

  Future<CommonResponse> requestOtp(data);

  Future<CommonResponse> changePassword(data);

  Future<CommonResponse> changePin(data);
  Future<NetworkAppUpdateInfo> updateInfo();

  Future<CommonResponse> getTransactionNumber();

  Future<void> downloadFileAndSaveToGallery(String baseUrl, String extension);

  Future<AlertMessageResponse> alertMessage();
  Future<CmsServiceResponse> cmsService();
  Future<QRCodeListResponse> fetchQRCodes();
}