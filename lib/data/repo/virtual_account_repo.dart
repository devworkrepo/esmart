import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/virtual_account/virtual_account.dart';

abstract class VirtualAccountRepo{
  Future<VirtualAccountDetailResponse> fetchVirtualAccounts();
  Future<CommonResponse> addIciciVirtualAccount();
  Future<CommonResponse> addYesVirtualAccount();
}