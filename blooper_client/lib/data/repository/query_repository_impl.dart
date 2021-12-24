import 'dart:io';

import 'package:blooper_client/core/app_error.dart';
import 'package:blooper_client/data/remote/remote_query_repository.dart';
import 'package:blooper_client/domain/entities/query_result_entity.dart';
import 'package:blooper_client/domain/repository/query_repository.dart';
import 'package:dartz/dartz.dart';

class QueryRepositoryImpl extends QueryRepository {
  final RemoteQueryRepository remoteQueryRepository;

  QueryRepositoryImpl(this.remoteQueryRepository);

  @override
  Future<Either<AppError, QueryResultEntity>> getQueryResult(
      String query) async {
    try {
      final result = await remoteQueryRepository.getQueryResult(query);
      return Right(result);
    } on SocketException {
      return Left(AppError(
        errorType: AppErrorType.NETWORK_ERROR,
        message: 'An error occurred!',
      ));
    } on Exception {
      return Left(AppError(
        errorType: AppErrorType.API_ERROR,
        message: 'An error occurred!',
      ));
    }
  }
}
