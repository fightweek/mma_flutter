import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'stream_fight_event_repository.g.dart';

final streamFightEventRepositoryProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return StreamFightEventRepository(dio, baseUrl: 'http://$ip/stream');
});

@RestApi()
abstract class StreamFightEventRepository {
  factory StreamFightEventRepository(Dio dio, {String baseUrl}) = _StreamFightEventRepository;

  @GET('/weekly_event')
  @Headers({'accessToken': 'true'})
  Future<StreamFightEventModel> getFightEvent();

}
