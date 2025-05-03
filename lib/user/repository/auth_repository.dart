import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
import 'package:mma_flutter/user/model/login_request.dart';
import 'package:mma_flutter/user/model/login_response.dart';
import 'package:mma_flutter/user/model/naver_login_request.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'auth_repository.g.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.read(dioProvider);
  return AuthRepository(dio, baseUrl: 'http://$ip/auth');
});

// http://$ip/auth
@RestApi()
abstract class AuthRepository {
  factory AuthRepository(Dio dio, {String baseUrl}) = _AuthRepository;

  @POST('/login')
  Future<LoginResponse> login({@Body() required LoginRequest request});

  @POST('/social_login')
  Future<LoginResponse> socialLogin({@Body() required SocialLoginRequest request});

  @POST('/logout')
  @Headers({'refreshToken': 'true'})
  Future<void> logout();
}
