import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/dialog/full_screen_transaction.dart';

import '../button.dart';

class BaseDialogContainer extends StatelessWidget {
  final Widget child;
  final bool backPress;
  final int padding;

  const BaseDialogContainer(
      {required this.backPress,
      this.padding = 30,
      required this.child,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(backPress),
      child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(padding.toDouble()),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.white),
                child: child,
              ),
            ],
          )),
    );
  }
}

enum StatusType { success, failure, pending, alert }

class _ProgressDialog extends StatelessWidget {
  final String title;
  final bool backPress;

  const _ProgressDialog(
      {required this.title, required this.backPress, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseDialogContainer(
        backPress: backPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                  Radius.circular(100.0),
                )),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: Get.textTheme.caption
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ));
  }
}

class _StatusDialog extends StatelessWidget {
  final String title;
  final bool backPress;
  final StatusType type;
  final String? buttonText;
  final VoidCallback? proceed;

  _StatusDialog(
      {required this.title,
      required this.type,
      required this.backPress,
      this.buttonText,
      this.proceed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = _getColor(type);
    var icon = _getIcon(type);

    return BaseDialogContainer(
        padding: 70,
        backPress: backPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                    Radius.circular(100.0),
                  )),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      icon,
                      size: 52,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  title,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.caption
                      ?.copyWith(fontWeight: FontWeight.w500, fontSize: 14, color: color),
                ),
                const SizedBox(height: 16),
            
                ElevatedButton(
                  style:  ButtonStyle(
                      shape:
                      MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular((100)),
                          ))
                  ),
                    onPressed: () {
                      if (proceed != null) {
                        Get.back();
                        proceed!();
                      } else {
                        Get.back();
                      }
                    },
                    child: Text(buttonText ?? "       Done       "))
              ],
            ),
          ),
        ));
  }

  _getColor(StatusType type) {
    switch (type) {
      case StatusType.success:
        return Colors.green;
        break;
      case StatusType.failure:
        return Colors.grey[700];
        break;
      case StatusType.pending:
        return Colors.yellow[900];
        break;
      case StatusType.alert:
        return Colors.grey[700];
        break;
    }
  }

  _getIcon(StatusType type) {
    switch (type) {
      case StatusType.success:
        return Icons.verified;
        break;
      case StatusType.failure:
        return Icons.cancel_outlined;
        break;
      case StatusType.pending:
        return Icons.update;
        break;
      case StatusType.alert:
        return Icons.error_outline;
        break;
    }
  }
}

class StatusDialog {
  static progress({String title = "Loading...", bool backPress = false}) {
    backPress = (kDebugMode) ? true : false;

    return Get.dialog(
      _ProgressDialog(
        title: title,
        backPress: backPress,
      ),
      barrierDismissible: false,
    );
  }

  static Future success({required String title}) {
    return Get.dialog(
      _StatusDialog(
        title: title,
        backPress: true,
        type: StatusType.success,
      ),
      barrierDismissible: false,
    );
  }

  static Future failure(
      {String title =
          "Something went wrong! please try again after sometime"}) {
    return Get.dialog(
      _StatusDialog(
        title: title,
        backPress: true,
        type: StatusType.failure,
      ),
      barrierDismissible: false,
    );
  }

  static Future pending({required String title, String? buttonText}) {
    return Get.dialog(
      _StatusDialog(
          title: title,
          backPress: true,
          type: StatusType.pending,
          buttonText: buttonText),
      barrierDismissible: false,
    );
  }

  static Future alert({required String title}) {
    return Get.dialog(
      _StatusDialog(
        title: title,
        backPress: true,
        type: StatusType.alert,
      ),
      barrierDismissible: false,
    );
  }

  static transaction() {
    return Get.to(
      () => const FullScreenProgressDialogWidget(),
      fullscreenDialog: true,
    );
  }
}

closeGetDialog() {
  if (Get.isDialogOpen!) {
    Get.back();
  }
}
