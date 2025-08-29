import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/admin/provider/common_update_provider.dart';
import 'package:mma_flutter/admin/repository/updatable_repository.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'admin_event_repository.g.dart';

final adminEventRepositoryProvider = Provider<AdminEventRepository>((ref) {
  final dio = ref.read(dioProvider);
  return AdminEventRepository(dio, baseUrl: 'http://$ip/admin/event');
});

@RestApi()
abstract class AdminEventRepository implements UpdatableRepository {
  factory AdminEventRepository(Dio dio, {String baseUrl}) =
      _AdminEventRepository;

  @override
  @POST('/save_upcoming')
  @Headers({'accessToken': 'true'})
  Future<void> update();
}
