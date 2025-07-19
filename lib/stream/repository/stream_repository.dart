import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'stream_repository.g.dart';

final streamRepositoryProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return StreamRepository(dio,baseUrl: 'http://$ip/event/stream');
},);

@RestApi()
abstract class StreamRepository{
  factory StreamRepository(Dio dio, {String baseUrl}) = _StreamRepository;

  @GET('')
  @Headers({
    'accessToken' : 'true'
  })
  Future<StreamFightEventModel> getFightEvent({@Query("eventName") required String eventName});
}