import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/admin/repository/updatable_repository.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'admin_stream_repository.g.dart';

final adminStreamRepositoryProvider = Provider<AdminStreamRepository>((ref) {
  final dio = ref.read(dioProvider);
  return AdminStreamRepository(dio, baseUrl: 'http://$ip/admin/stream');
});

@RestApi()
abstract class AdminStreamRepository implements UpdatableRepository{
  factory AdminStreamRepository(Dio dio, {String baseUrl}) =
      _AdminStreamRepository;

  /// activate stream room
  @override
  @POST('/event')
  @Headers({'accessToken': 'true'})
  Future<void> update();
}
