import 'package:flutter/material.dart';

class EmptyBox extends StatelessWidget {
  const EmptyBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ApiProgress extends StatelessWidget {
  final dynamic data;

  const ApiProgress(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return _progressbar();
    } else {
      return const EmptyBox();
    }
  }

  _progressbar() {
    return const Center(
      child: SizedBox(
        height: 48,
        width: 48,
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(100.0),
          )),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      ),
    );
  }
}
