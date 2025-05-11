import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
import 'package:mma_flutter/user/model/verify_code_request.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'smtp_repository.g.dart';

final smtpRepositoryProvider = Provider<SmtpRepository>((ref) {
  final dio = ref.read(dioProvider);
  return SmtpRepository(dio, baseUrl: 'http://$ip/smtp');
});

// http://$ip/smtp
@RestApi()
abstract class SmtpRepository {
  factory SmtpRepository(Dio dio, {String baseUrl}) = _SmtpRepository;

  @POST('/send_join_code')
  Future<String> sendJoinCode({@Body() required Map<String, String> emailTo});

  @POST('/verify_code')
  Future<String> verifyCode({@Body() required VerifyCodeRequest request});
}
