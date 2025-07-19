import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'admin_stream_repository.g.dart';

final adminActivateStreamRoomProvider = FutureProvider.autoDispose<void>((
  ref,
) async {
  await ref.read(adminStreamRepositoryProvider).activateStreamRoom();
});

final adminStreamRepositoryProvider = Provider<AdminStreamRepository>((ref) {
  final dio = ref.read(dioProvider);
  return AdminStreamRepository(dio, baseUrl: 'http://$ip/admin/stream');
});

@RestApi()
abstract class AdminStreamRepository {
  factory AdminStreamRepository(Dio dio, {String baseUrl}) =
      _AdminStreamRepository;

  @POST('/event')
  @Headers({'accessToken': 'true'})
  Future<void> activateStreamRoom();
}
