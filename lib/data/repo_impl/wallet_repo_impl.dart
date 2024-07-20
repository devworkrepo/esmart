import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/wallet_repo.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/wallet/wallet_fav.dart';
import 'package:esmartbazaar/service/network_client.dart';
import 'package:esmartbazaar/util/app_util.dart';

class WalletRepoImpl extends WalletRepo{

  NetworkClient client = Get.find();


  @override
  Future<WalletFavListResponse> fetchFavList()  async{
    var response = await client.post("/GetWalletFavList");
    return WalletFavListResponse.fromJson(response.data);
  }

  @override
  Future<WalletSearchResponse> searchWallet(data) async {
    var response = await client.post("/SearchWalletAccount",data: data);
    return WalletSearchResponse.fromJson(response.data);
  }

  @override
  Future<WalletTransactionResponse> walletTransfer(data) async {
    var response = await client.post("/WalletTransaction",data: data);
    return WalletTransactionResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> deleteFav(data) async {
    var response = await client.post("/RemoveWalletFav",data: data);
    return CommonResponse.fromJson(response.data);
  }


}