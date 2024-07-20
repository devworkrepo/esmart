import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/api_component.dart';
import '../page/exception_page.dart';
import 'api/resource/resource.dart';

class ObsResourceWidget<T> extends StatelessWidget {
  final Rx<Resource<T>> obs;
  final Widget Function(T data) childBuilder;
  final bool handleCode;


  const ObsResourceWidget({Key? key, required this.obs,required this.childBuilder,this.handleCode = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => obs.value.when(onSuccess: (data) {
          dynamic response = data;
          if (response.code == 1 || handleCode) {
               return childBuilder(data);
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline,size: 62,),
                        SizedBox(height: 16,),
                        Text(response.message),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        }, onFailure: (e) {
          return ExceptionPage(
            error: e,
          );
        }, onInit: (data) {
          return ApiProgress(data);
        }));
  }
}


class ConditionalWidget extends StatelessWidget {
  final bool condition;
  final Widget child;
  const ConditionalWidget({required this.condition,required this.child,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (condition)  ? child : const SizedBox();
  }
}




