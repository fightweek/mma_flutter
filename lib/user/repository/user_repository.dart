import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
import 'package:mma_flutter/user/model/join_request.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/model/user_profile_model.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/error_logger.dart';

part 'user_repository.g.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.read(dioProvider);
  return UserRepository(dio, baseUrl: 'http://$ip/user');
});

// http://$ip/user/me
@RestApi()
abstract class UserRepository {
  factory UserRepository(Dio dio, {String baseUrl}) = _UserRepository;

  @GET('/me')
  @Headers({'accessToken': 'true'})
  Future<UserModel> getMe();

  @GET('/check_dup_nickname')
  Future<bool> checkDuplicatedNickname({
    @Body() required Map<String, String> nickname,
  });

  @POST('/update_nickname')
  @Headers({'accessToken': 'true'})
  Future<UserModel> updateNickname({
    @Body() required Map<String, String> nickname,
  });

  @POST('/join')
  Future<void> join({@Body() required JoinRequest request});

  @GET('/profile')
  @Headers({'accessToken' : 'true'})
  Future<UserProfileModel> profile();
}
