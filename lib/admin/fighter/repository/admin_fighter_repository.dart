import 'dart:developer';

import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'admin_fighter_repository.g.dart';

final adminFighterUpdateProvider = FutureProvider.autoDispose<void>((ref) async {
  await ref.read(adminFighterRepositoryProvider).updateRanking();
});

final adminFighterRepositoryProvider = Provider<AdminFighterRepository>((ref) {
  final dio = ref.read(dioProvider);
  return AdminFighterRepository(dio, baseUrl: 'http://$ip/admin/fighter');
});

@RestApi()
abstract class AdminFighterRepository {
  factory AdminFighterRepository(Dio dio, {String baseUrl}) =
      _AdminFighterRepository;

  @POST('/update_ranking')
  @Headers({'accessToken': 'true'})
  Future<void> updateRanking();
}
