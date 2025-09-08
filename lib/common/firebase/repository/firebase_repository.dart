// import 'package:dio/dio.dart' hide Headers;
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mma_flutter/common/const/data.dart';
// import 'package:mma_flutter/common/firebase/model/firebase_sender_model.dart';
// import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
// import 'package:retrofit/http.dart';
//
// final firebaseRepositoryProvider = Provider<FirebaseRepository>((ref) {
//   final dio = ref.read(dioProvider);
//   return FirebaseRepositoryImpl(dio: dio, baseUrl: 'http://$ip/fcm',);
// });
//
// abstract class FirebaseRepository {
//   final Dio dio;
//   final String baseUrl;
//
//   FirebaseRepository({required this.dio, required this.baseUrl});
//
//   Future<void> sendTokenToServer({
//     required String category,
//     required int categoryId,
//   });
// }
//
// class FirebaseRepositoryImpl implements FirebaseRepository {
//   @override
//   final Dio dio;
//   @override
//   final String baseUrl;
//
//   String? _token;
//
//   FirebaseRepositoryImpl({required this.dio, required this.baseUrl});
//
//   Future<void> initToken() async {
//     _token = await FirebaseMessaging.instance.getToken();
//   }
//
//   String? get token => _token;
//
//   @POST('/')
//   @Headers({'accessToken': 'true'})
//   @override
//   Future<void> sendTokenToServer({
//     required String category,
//     required int categoryId,
//   }) async {
//     if (_token == null) {
//       print('token is null');
//       await initToken();
//     }
//     final model = FirebaseSenderModel(
//       token: token!,
//       category: category,
//       categoryId: categoryId,
//     );
//     await dio.post(baseUrl, data: model.toJson());
//   }
// }
