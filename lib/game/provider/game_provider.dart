import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
import 'package:mma_flutter/game/model/game_args.dart';
import 'package:mma_flutter/game/model/game_response_model.dart';
import 'package:mma_flutter/game/model/image_game_questions_model.dart';
import 'package:mma_flutter/game/model/name_game_questions_model.dart';
import 'package:mma_flutter/game/repository/game_repository.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';

final gameAttemptCountProvider = FutureProvider.autoDispose<int>((ref) async {
  ref.onDispose(() => print('dispose gameAttemptCountProvider'));
  return await ref.watch(gameRepositoryProvider).getGameAttemptCount();
});

/// gameProvider를 더 이상 참조하는 위젯이 없을 때 자동 dispose
/// family : <Notifier, State, Arg>
final gameProvider = StateNotifierProvider.family<
  GameProvider,
  StateBase<GameResponseModel>,
  GameArgs
>((ref, gameArgs) {
  ref.onDispose(() => print('dispose gameProvider'));
  final gameRepository = ref.read(gameRepositoryProvider);
  return GameProvider(
    gameRepository: gameRepository,
    ref: ref,
    isNormal: gameArgs.isNormal,
    isImage: gameArgs.isImage,
  );
});

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  final dio = ref.read(dioProvider);
  return GameRepository(dio, baseUrl: 'http://$ip/game');
});

class GameProvider extends StateNotifier<StateBase<GameResponseModel>> {
  final Ref ref;
  final GameRepository gameRepository;
  final bool isNormal;
  final bool isImage;
  List<List<String>> selectionList = [];
  List<String> selectedList = ['', '', '', '', ''];

  GameProvider({
    required this.gameRepository,
    required this.ref,
    required this.isNormal,
    required this.isImage,
  }) : super(StateLoading()) {
    print('initialize game provider');
    getGameQuestions();
  }

  Future<void> getGameQuestions() async {
    try {
      final resp = await gameRepository.getGameQuestions(
        isNormal: isNormal,
        isImage: isImage,
      );
      if (!isImage) {
        for (NameGameQuestionModel e in resp.nameGameQuestions!.gameQuestions) {
          selectionList.add([...e.wrongSelection, e.answerName]..shuffle());
        }
      } else {
        for (ImageGameQuestionModel e
            in resp.imageGameQuestions!.gameQuestions) {
          selectionList.add([...e.wrongSelection, e.answerImgUrl]..shuffle());
        }
      }
      state = StateData<GameResponseModel>(data: resp);
    } catch (e, stack) {
      print(e);
      print(stack);
      log('error while get game questions');
      state = StateError(message: 'error while getting game questions');
    }
  }

  Future<int> getCorrectCount() async {
    print(selectedList);
    try {
      int currentPoint = (ref.read(userProvider) as UserModel).point;
      int correctCount = 0;
      final gameQuestions = state as StateData<GameResponseModel>;
      if (!isImage) {
        for (
          int i = 0;
          i < gameQuestions.data!.nameGameQuestions!.gameQuestions.length;
          i++
        ) {
          if (selectedList[i] ==
              gameQuestions.data!.nameGameQuestions!.gameQuestions[i].answerName) {
            currentPoint += 20;
            correctCount += 1;
          }
        }
      } else {
        for (
          int i = 0;
          i < gameQuestions.data!.imageGameQuestions!.gameQuestions.length;
          i++
        ) {
          if (selectedList[i] ==
              gameQuestions
                  .data!
                  .imageGameQuestions!
                  .gameQuestions[i]
                  .answerImgUrl) {
            currentPoint += 20;
            correctCount += 1;
          }
        }
      }
      ref
          .read(userProvider.notifier)
          .updatePoint(
            await gameRepository.updatePoint(newPoint: currentPoint.toString()),
          );
      return correctCount;
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      log('error while get answer names');
      return -1;
    }
  }
}
