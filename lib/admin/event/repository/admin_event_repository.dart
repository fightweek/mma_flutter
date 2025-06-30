import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'admin_event_repository.g.dart';

final adminEventSaveUpcomingProvider = FutureProvider.autoDispose<void>((ref) async{
  await ref.read(adminEventRepositoryProvider).saveUpcoming();
},);

final adminEventRepositoryProvider = Provider<AdminEventRepository>((ref) {
  final dio = ref.read(dioProvider);
  return AdminEventRepository(dio,baseUrl: 'http://$ip/admin/event');
},);

@RestApi()
abstract class AdminEventRepository{
  factory AdminEventRepository(Dio dio, {String baseUrl}) = _AdminEventRepository;

  @POST('/save_upcoming')
  @Headers({'accessToken' : 'true'})
  Future<void> saveUpcoming();

}