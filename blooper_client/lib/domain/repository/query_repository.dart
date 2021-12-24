import 'package:blooper_client/core/app_error.dart';
import 'package:blooper_client/domain/entities/query_result_entity.dart';
import 'package:dartz/dartz.dart';

abstract class QueryRepository {
  Future<Either<AppError, QueryResultEntity>> getQueryResult(String query);
}