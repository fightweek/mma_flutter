import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'fight_event_repository.g.dart';

final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  final dio = ref.read(dioProvider);
  return ScheduleRepository(dio, baseUrl: 'http://$ip/event');
});

@RestApi()
abstract class ScheduleRepository {
  factory ScheduleRepository(Dio dio, {String baseUrl}) = _ScheduleRepository;

  @GET('/schedule')
  @Headers({'accessToken': 'true'})
  Future<FightEventModel?> getSchedule({
    @Query('date') required String date,
  });
}
