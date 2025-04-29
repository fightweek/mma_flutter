import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/error_logger.dart';

part 'user_repository.g.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.read(dioProvider);
  return UserRepository(dio,baseUrl: 'http://$ip/user/me');
},);

// http://$ip/user/me
@RestApi()
abstract class UserRepository{
  factory UserRepository(Dio dio, {String baseUrl}) = _UserRepository;

  @GET('')
  @Headers({'accessToken' : 'true'})
  Future<UserModel> getMe();

}