import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
import 'package:mma_flutter/report/model/report_request_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'report_repository.g.dart';

final reportRepositoryProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return ReportRepository(dio, baseUrl: 'http://$ip/report');
});

@RestApi()
abstract class ReportRepository {
  factory ReportRepository(Dio dio, {String baseUrl}) = _ReportRepository;

  @POST('')
  @Headers({'accessToken': 'true'})
  Future<void> report({@Body() required ReportRequestModel request});
}
