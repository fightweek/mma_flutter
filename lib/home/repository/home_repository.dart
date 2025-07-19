import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
import 'package:mma_flutter/home/model/home_screen_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'home_repository.g.dart';

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) {
    final dio = ref.read(dioProvider);
    return HomeRepository(dio,baseUrl: 'http://$ip/home');
  },
);

@RestApi()
abstract class HomeRepository{
  factory HomeRepository(Dio dio, {String baseUrl}) = _HomeRepository;

  @GET('')
  @Headers({
    'accessToken' : 'true'
  })
  Future<HomeScreenModel?> home();

}