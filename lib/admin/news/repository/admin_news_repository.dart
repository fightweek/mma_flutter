import 'dart:ffi';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/model/model_with_id.dart';
import 'package:mma_flutter/common/model/pagination_model.dart';
import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
import 'package:mma_flutter/common/repository/pagination_base_repository.dart';
import 'package:mma_flutter/main.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'admin_news_repository.g.dart';

final adminNewsRepositoryProvider = Provider<AdminNewsRepository>((ref) {
  final dio = ref.read(dioProvider);
  return AdminNewsRepository(dio, baseUrl: 'http://$ip/admin/news');
});

@RestApi()
abstract class AdminNewsRepository {
  factory AdminNewsRepository(Dio dio, {String baseUrl}) = _AdminNewsRepository;

  @POST('/save')
  @MultiPart()
  @Headers({'accessToken': 'true'})
  Future<void> save({
    @Part(name: 'title') required String title,
    @Part(name: 'content') required String content,
    @Part(name: 'source') required String source,
    @Part(name: 'multipartFiles') required List<MultipartFile>? files,
  });

}
