import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/home/model/home_screen_model.dart';
import 'package:mma_flutter/home/repository/home_repository.dart';

final homeFutureProvider = FutureProvider<HomeScreenModel?>((ref) async {
  final res = await ref.read(homeRepositoryProvider).home();
  return res;
},);