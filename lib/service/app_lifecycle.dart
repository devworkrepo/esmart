import 'package:flutter/material.dart';
import 'package:esmartbazaar/util/app_util.dart';

class AppLifecycleManager extends StatefulWidget {
  final Widget child;
  final VoidCallback? onResume;

  const AppLifecycleManager({required this.child,this.onResume,Key? key}) : super(key: key);

  @override
  _AppLifecycleManagerState createState() => _AppLifecycleManagerState();
}

class _AppLifecycleManagerState extends State<AppLifecycleManager>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        if(widget.onResume!=null){
          widget.onResume!();
        }
        break;
      case AppLifecycleState.inactive:

        break;
      case AppLifecycleState.paused:

        break;
      case AppLifecycleState.detached:
        break;
      default : break;
    }

  }
}
