import 'package:json_annotation/json_annotation.dart';

part 'base_state_model.g.dart';

abstract class StateBase<T> {}

class StateLoading<T> extends StateBase<T> {}

class StateError<T> extends StateBase<T> {
  final String message;

  StateError({required this.message});
}

@JsonSerializable(genericArgumentFactories: true)
class StateData<T> extends StateBase<T> {
  final T? data;

  StateData({required this.data});

  factory StateData.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$StateDataFromJson(json, fromJsonT);
}

class StateDataDetail<T> extends StateData<T> {
  final T? meta;

  StateDataDetail({required this.meta, required super.data});

}
