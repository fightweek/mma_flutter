import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
import 'package:mma_flutter/stream/bet_and_vote/model/bet_request_model.dart';
import 'package:mma_flutter/stream/bet_and_vote/model/vote_rate_response_model.dart';
import 'package:mma_flutter/stream/bet_and_vote/model/vote_request_model.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'stream_repository.g.dart';

final streamRepositoryProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return StreamRepository(dio,baseUrl: 'http://$ip/stream');
},);

@RestApi()
abstract class StreamRepository{
  factory StreamRepository(Dio dio, {String baseUrl}) = _StreamRepository;

  @GET('/today_event')
  @Headers({
    'accessToken' : 'true'
  })
  Future<StreamFightEventModel> getFightEvent();

  @POST('/vote')
  @Headers({
    'accessToken' : 'true'
  })
  Future<VoteRateResponseModel> vote({@Body() required VoteRequestModel request});

  @POST('/bet')
  @Headers({
    'accessToken' : 'true'
  })
  Future<int> bet({@Body() required BetRequestModel request});
}