import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/model/model_with_id.dart';
import 'package:mma_flutter/common/model/pagination_model.dart';
import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
import 'package:mma_flutter/common/repository/pagination_base_repository.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/fight_event/model/fight_event_pagination_model.dart';
import 'package:mma_flutter/fighter/model/update_preference_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'fight_event_repository.g.dart';

final fightEventRepositoryProvider = Provider<FightEventRepository>((ref) {
  final dio = ref.read(dioProvider);
  return FightEventRepository(dio, baseUrl: 'http://$ip/event');
});

@RestApi()
abstract class FightEventRepository implements PaginationBaseRepository<FighterFightEventModel> {
  factory FightEventRepository(Dio dio, {String baseUrl}) = _FightEventRepository;

  @GET('/detail')
  @Headers({'accessToken': 'true'})
  Future<FightEventModel?> getSchedule({
    @Query('date') required String date,
  });

  @POST('/preference')
  @Headers({'accessToken': 'true'})
  Future<void> updatePreference({
    @Body() required UpdatePreferenceModel request
  });

  @override
  @GET('/events')
  @Headers({'accessToken':'true'})
  Future<Pagination<FighterFightEventModel>> paginate({@Queries() Map<String, dynamic>? params});
}
