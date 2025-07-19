import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/provider/secure_storage_provider.dart';
import 'package:mma_flutter/main.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);
  dio.interceptors.add(CustomInterceptor(ref: ref, storage: storage));
  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomInterceptor({required this.ref, required this.storage});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    print('[REQ] [${options.method}] ${options.uri}');
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');
      final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({'Authorization': 'Bearer $accessToken'});
    }
    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');
      final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
      options.headers.addAll({'Refresh': '$refreshToken'});
    }
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 에러가 발생했을 때 토큰 재발급을 받는 요청을 한다.
    // 토큰이 재발급되면, 다시 새로운 토큰으로 원래 하려던 요청을 한다.
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    if (refreshToken == null) {
      // 예외 발생
      return handler.reject(err);
    }
    final isStatus401 = err.response?.statusCode == 401;
    final isPathReissue = err.requestOptions.path == '/reissue';
    // reissue 요청이 아닌데, 401이다? -> 빼박 accessToken 만료된 것임
    if (isStatus401 && !isPathReissue) {
      print('accesstoken is invalid!');
      final dio = Dio();
      print('refresh=$refreshToken');
      try {
        final resp = await dio.post(
          'http://$ip/reissue',
          options: Options(headers: {'Refresh': refreshToken}),
        );
        final newAccessToken = resp.data['accessToken'];
        final newRefreshToken = resp.data['refreshToken'];
        print(resp.statusMessage);
        final options = err.requestOptions;
        await storage.write(key: ACCESS_TOKEN_KEY, value: newAccessToken);
        await storage.write(key: REFRESH_TOKEN_KEY, value: newRefreshToken);
        options.headers.addAll({'Authorization': 'Bearer $newAccessToken'});
        final response = await dio.fetch(
          options,
        ); // 새롭게 발급받은 accessToken 으로 요청 재전송
        return handler.resolve(response);
      } on DioException catch (e) {
        // refresh 마저 만료되었을 때
        ref.read(userProvider.notifier).logout(withRefresh: false);
        return handler.reject(e);
      }
    }
    return handler.reject(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}',
    );
    super.onResponse(response, handler);
  }
}
