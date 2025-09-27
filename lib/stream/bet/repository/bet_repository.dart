import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
import 'package:mma_flutter/stream/bet/model/bet_request_model.dart';
import 'package:mma_flutter/stream/bet/model/bet_response_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'bet_repository.g.dart';

final betRepositoryProvider = Provider<BetRepository>((ref) {
  final dio = ref.read(dioProvider);
  return BetRepository(dio,baseUrl: 'http://$ip/bet');
},);

@RestApi()
abstract class BetRepository {
  factory BetRepository(Dio dio, {String baseUrl}) = _BetRepository;

  @PATCH('')
  @Headers({'accessToken': 'true'})
  Future<int> bet({@Body() required BetRequestModel request});

  @GET('/history')
  @Headers({'accessToken': 'true'})
  Future<BetResponseModel?> getBetHistory({@Query("eventId")required int eventId});

  @DELETE('')
  @Headers({'accessToken': 'true'})
  Future<BetResponseModel> deleteBet({@Query("betId") required int betId});

}