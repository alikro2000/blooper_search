import 'package:blooper_client/data/remote/remote_query_repository.dart';
import 'package:blooper_client/data/repository/query_repository_impl.dart';
import 'package:blooper_client/domain/repository/query_repository.dart';
import 'package:blooper_client/domain/usecase/get_query_result.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

abstract class GetItInitializer {
  static initGetIt() {
    //Repositories
    GetIt.instance.registerSingleton<RemoteQueryRepository>(RemoteQueryRepositoryImpl());
    GetIt.instance.registerSingleton<QueryRepository>(QueryRepositoryImpl(GetIt.instance<RemoteQueryRepository>()));
    //Usecases
    GetIt.instance.registerSingleton<GetQueryResult>(GetQueryResult(GetIt.instance<QueryRepository>()));
  }
}