import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'resource.freezed.dart';

@freezed
abstract class Resource<T> with _$Resource<T> {
  const factory Resource.onSuccess(T data) = Success<T>;
  const factory Resource.onFailure(dynamic error) = Failure<T>;
  const factory Resource.onInit({T? data}) = Loading<T>;
}

