import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/game/component/game_selection.dart';
import 'package:mma_flutter/game/component/game_text_question.dart';
import 'package:mma_flutter/game/component/octagon_clipper.dart';
import 'package:mma_flutter/game/component/octagon_painter.dart';
import 'package:mma_flutter/game/model/game_args.dart';
import 'package:mma_flutter/game/model/game_response_model.dart';
import 'package:mma_flutter/game/model/image_game_questions_model.dart';
import 'package:mma_flutter/game/model/name_game_questions_model.dart';
import 'package:mma_flutter/game/provider/game_provider.dart';
import 'package:mma_flutter/game/screen/game_end_screen.dart';

class GameScreen extends ConsumerStatefulWidget {
  static String get routeName => 'game';

  final int seq;
  final bool isNormal;
  final bool isImage;

  const GameScreen({
    required this.seq,
    required this.isNormal,
    required this.isImage,
    super.key,
  });

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  int? selectedAnswerIdx;
  Timer? timer;
  int currentTimeSec = 15;

  /**
   * GoRouter는 GameScreen을 같은 라우트로 보고
   * 단지 path parameter (seq)만 바뀐 것으로 인식해서
   * 기존의 GameScreen 인스턴스를 재사용 (seq=1일 때만 initState 호출됨)
   */
  @override
  void initState() {
    print('init state');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedAnswerIdx = null;
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      gameProvider(
        GameArgs(isNormal: widget.isNormal, isImage: widget.isImage),
      ),
    );

    if (state is StateError) {
      _pauseTimer();
      return _renderScaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              ref.invalidate(gameProvider);
            },
            child: Text('다시시도'),
          ),
        ),
      );
    }

    if (state is StateLoading) {
      _pauseTimer();
      return _renderScaffold(body: Center(child: CircularProgressIndicator()));
    }

    final gameState = (state as StateData<GameResponseModel>).data!;
    final game = ref.read(
      gameProvider(
        GameArgs(isNormal: widget.isNormal, isImage: widget.isImage),
      ).notifier,
    );
    _resumeTimer();

    return _renderScaffold(
      body: _renderBody(
        context,
        game: game,
        selection: game.selectionList[widget.seq - 1],
        nameGameQuestion:
            !widget.isImage
                ? gameState.nameGameQuestions!.gameQuestions[widget.seq - 1]
                : null,
        imageGameQuestion:
            widget.isImage
                ? gameState.imageGameQuestions!.gameQuestions[widget.seq - 1]
                : null,
      ),
    );
  }

  _renderBody(
    BuildContext context, {
    required NameGameQuestionModel? nameGameQuestion,
    required ImageGameQuestionModel? imageGameQuestion,
    required List<String> selection,
    required GameProvider game,
  }) {
    return Container(
      color: DARK_GREY_COLOR,
      child: SafeArea(
        child: SizedBox.expand(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [..._renderQuizSeq(widget.seq)],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 60.h, bottom: 20.h),
                  child: Text(
                    'QUIZ ${widget.seq}',
                    style: defaultTextStyle.copyWith(fontSize: 18.sp),
                    textAlign: TextAlign.center,
                  ),
                ),
                GameTextQuestion(
                  nameQuestionModel: nameGameQuestion,
                  imageQuestionModel: imageGameQuestion,
                ),
                if (nameGameQuestion != null &&
                    (nameGameQuestion.gameCategory == GameCategory.body ||
                        nameGameQuestion.gameCategory == GameCategory.headshot))
                  _renderImgForNameQuestion(question: nameGameQuestion),
                GameSelection(
                  selectedAnswerIdx: selectedAnswerIdx,
                  gameCategory: nameGameQuestion?.gameCategory,
                  selection: selection,
                  onTap: (index) {
                    setState(() {
                      selectedAnswerIdx = index;
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top:
                        (imageGameQuestion != null ||
                                (nameGameQuestion != null &&
                                    (nameGameQuestion.gameCategory ==
                                            GameCategory.body ||
                                        nameGameQuestion.gameCategory ==
                                            GameCategory.headshot)))
                            ? 60.h
                            : 110.h,
                    bottom: 10.h,
                  ),
                  child: CustomPaint(
                    painter: OctagonPainter(
                      strokeColor: BLUE_COLOR,
                      isEasy: true,
                      num: currentTimeSec,
                    ),
                    size: Size(46.w, 46.h),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(370.w, 35.h),
                    disabledBackgroundColor: GREY_COLOR,
                    backgroundColor: BLUE_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8.r),
                    ),
                  ),
                  onPressed:
                      selectedAnswerIdx == null
                          ? null
                          : () {
                            game.selectedList[widget.seq - 1] =
                                selection[selectedAnswerIdx!];
                            context.goNamed(
                              widget.seq != 5
                                  ? GameScreen.routeName
                                  : GameEndScreen.routeName,
                              pathParameters:
                                  widget.seq != 5
                                      ? {'seq': '${widget.seq + 1}'}
                                      : {},
                              queryParameters: {
                                'isNormal': '${widget.isNormal}',
                                'isImage': '${widget.isImage}',
                              },
                            );
                          },
                  child: Text(
                    widget.seq != 5 ? '다음' : '종료',
                    style: defaultTextStyle.copyWith(fontSize: 15.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderImgForNameQuestion({required NameGameQuestionModel question}) {
    return SizedBox(
      width: 180.w,
      height: 180.h,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: OctagonPainter(
                fillColor: BLACK_COLOR,
                strokeColor: GREY_COLOR,
                isEasy: true,
                width: 2.w,
              ),
            ),
          ),
          ClipPath(
            clipper: OctagonClipper(),
            child: CachedNetworkImage(
              imageUrl:
                  question.gameCategory == GameCategory.headshot
                      ? question.headshotUrl!
                      : question.bodyUrl!,
              height: 170.h,
              width: 170.w,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Scaffold _renderScaffold({required Widget body}) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: AppBar(
          backgroundColor: DARK_GREY_COLOR,
          foregroundColor: WHITE_COLOR,
        ),
      ),
      body: body,
    );
  }

  List<Widget> _renderQuizSeq(int seq) {
    return List.generate(5, (index) {
      return CustomPaint(
        painter: OctagonPainter(
          num: seq == index + 1 ? seq : null,
          isEasy: true,
          fillColor: seq == index + 1 ? BLUE_COLOR : BLACK_COLOR,
          textSize: 11.sp,
        ),
        size: Size(22.w, 22.h),
      );
    });
  }

  void _reduceTime(Timer timer) {
    if (currentTimeSec == 0) {
      timer.cancel();
      context.goNamed(
        widget.seq != 5 ? GameScreen.routeName : GameEndScreen.routeName,
        pathParameters: widget.seq != 5 ? {'seq': '${widget.seq + 1}'} : {},
        queryParameters: {
          'isNormal': '${widget.isNormal}',
          'isImage': '${widget.isImage}',
        },
      );
    } else {
      setState(() {
        currentTimeSec -= 1;
      });
    }
  }

  void _pauseTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
  }

  void _resumeTimer() {
    if (timer != null && timer!.isActive) return;
    _startTimer();
  }

  void _startTimer() {
    currentTimeSec = 15;
    timer = Timer.periodic(Duration(seconds: 1), _reduceTime);
  }
}
