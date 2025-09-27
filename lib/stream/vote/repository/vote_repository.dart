import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
import 'package:mma_flutter/stream/provider/stream_fight_event_provider.dart';
import 'package:mma_flutter/stream/vote/model/vote_rate_response_model.dart';
import 'package:mma_flutter/stream/vote/model/vote_request_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'vote_repository.g.dart';

final voteCreateFutureProvider = FutureProvider.family.autoDispose<void,VoteRequestModel>((ref, request) async{
  final resp = await ref.read(voteRepositoryProvider).vote(request: request);
  if(resp != null) {
    ref.read(streamFightEventProvider.notifier).updateVoteRate(resp);
  }
},);

final voteRepositoryProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return VoteRepository(dio, baseUrl: 'http://$ip/vote');
});

@RestApi()
abstract class VoteRepository {
  factory VoteRepository(Dio dio, {String baseUrl}) = _VoteRepository;

  @POST('')
  @Headers({'accessToken': 'true'})
  Future<VoteRateResponseModel?> vote({
    @Body() required VoteRequestModel request,
  });

}
