import '../../model/common.dart';
import '../../model/matm_credo/matm_credo_initiate.dart';

abstract class MatmCredoRepo {
  Future<MatmCredoInitiate> initiateMATMTransaction(data);
  Future<MatmCredoInitiate> initiateMPOSTransaction(data);
  Future<MatmCredoInitiate> initiateVOIDTransaction(data);
  Future<CommonResponse> updateTransactionToServer(data);
}