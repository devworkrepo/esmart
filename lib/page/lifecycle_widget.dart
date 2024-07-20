import 'package:flutter/material.dart';
import 'package:esmartbazaar/util/app_util.dart';

class AppLifecycleWidget extends StatefulWidget {
  final VoidCallback? onResume;
  final VoidCallback? onPause;
  final Widget child;

  const AppLifecycleWidget({Key? key,required this.child, this.onResume, this.onPause})
      : super(key: key);

  @override
  State<AppLifecycleWidget> createState() => _AppLifecycleWidgetState();
}

class _AppLifecycleWidgetState extends State<AppLifecycleWidget>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (widget.onResume != null) widget.onResume!();
        AppUtil.logger("Lifecycle state : onResume");
        break;

      case AppLifecycleState.inactive:

        AppUtil.logger("Lifecycle state : inactive");
        break;
      case AppLifecycleState.paused:
        if (widget.onPause != null) widget.onPause!();
        AppUtil.logger("Lifecycle state : paused");
        break;
      case AppLifecycleState.detached:

        AppUtil.logger("Lifecycle state : detached");
        break;
      default : break;
    }
  }
}

/*
abstract class LifecycleWatcherState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        onPaused();
        break;
      case AppLifecycleState.paused:
        onInactive();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
    }
  }

  void onResumed();
  void onPaused();
  void onInactive();
  void onDetached();
}*/
