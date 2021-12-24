import 'package:bloc/bloc.dart';
import 'package:blooper_client/domain/usecase/get_query_result.dart';
import 'package:blooper_client/presentation/bloc/get_query_state.dart';

class GetQueryCubit extends Cubit<GetQueryState> {
  final GetQueryResult getQueryResult;

  GetQueryCubit(this.getQueryResult) : super(const GetQueryStateInitial());

  Future<void> submitQuery(String query) async {
    emit(const GetQueryStateLoading());

    (await getQueryResult.call(query)).fold(
      (l) => emit(GetQueryStateError(l)),
      (r) => emit(GetQueryStateLoaded(r)),
    );
  }
}
