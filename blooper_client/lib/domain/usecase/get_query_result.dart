import 'package:blooper_client/core/app_error.dart';
import 'package:blooper_client/domain/entities/query_result_entity.dart';
import 'package:blooper_client/domain/repository/query_repository.dart';
import 'package:blooper_client/domain/usecase/use_case.dart';
import 'package:dartz/dartz.dart';

class GetQueryResult extends UseCase<QueryResultEntity, String> {
  final QueryRepository queryRepository;

  GetQueryResult(this.queryRepository);

  @override
  Future<Either<AppError, QueryResultEntity>> call(String query) async {
    return await queryRepository.getQueryResult(query);
  }
}
