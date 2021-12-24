import 'package:blooper_client/core/app_error.dart';
import 'package:blooper_client/domain/entities/query_result_entity.dart';
import 'package:equatable/equatable.dart';

class GetQueryState extends Equatable {
  const GetQueryState();

  @override
  List<Object?> get props => [];
}

class GetQueryStateInitial extends GetQueryState {
  const GetQueryStateInitial();
}

class GetQueryStateLoading extends GetQueryState {
  const GetQueryStateLoading();
}

class GetQueryStateLoaded extends GetQueryState {
  final QueryResultEntity result;

  const GetQueryStateLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

class GetQueryStateError extends GetQueryState {
  final AppError error;

  const GetQueryStateError(this.error);

  @override
  List<Object?> get props => [error];
}
