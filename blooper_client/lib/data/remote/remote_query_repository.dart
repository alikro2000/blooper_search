import 'package:blooper_client/domain/entities/posting_list_item_entity.dart';
import 'package:http/http.dart' as http;

import 'package:blooper_client/domain/entities/query_result_entity.dart';

abstract class RemoteQueryRepository {
  Future<QueryResultEntity> getQueryResult(String query);
}

class RemoteQueryRepositoryImpl extends RemoteQueryRepository {
  @override
  Future<QueryResultEntity> getQueryResult(String query) async {
    final client = http.Client();
    var response = await client.get(Uri.parse(
      'http://localhost:3000?query=$query',
    ));
    if (response.statusCode == 200) {
      print('YAY! :D');
    } else {
      print('nay... :(');
    }
    client.close();
    return QueryResultEntity(
      query: 'query',
      count: 0,
      duration: 0,
      postingList: [
        PostingListItemEntity(
          docID: 0,
          score: 0,
          snippet: '',
          url: '',
        )
      ],
    );
  }
}
