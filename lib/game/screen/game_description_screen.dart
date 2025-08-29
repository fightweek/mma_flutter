import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mma_flutter/common/component/custom_alert_dialog.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/game/provider/game_provider.dart';
import 'package:mma_flutter/game/screen/game_screen.dart';

class GameDescriptionScreen extends ConsumerStatefulWidget {
  static String get routeName => 'game_desc';

  final bool isImage;

  const GameDescriptionScreen({required this.isImage, super.key});

  @override
  ConsumerState<GameDescriptionScreen> createState() =>
      _GameDescriptionScreenState();
}

class _GameDescriptionScreenState extends ConsumerState<GameDescriptionScreen> {
  bool? isEasySelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: AppBar(
          backgroundColor: DARK_GREY_COLOR,
          foregroundColor: WHITE_COLOR,
        ),
      ),
      body: Container(
        color: DARK_GREY_COLOR,
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 37.h),
              child: Image.asset(
                'asset/img/logo/fight_week_white.png',
                height: 57.h,
                width: 64.w,
              ),
            ),
            SizedBox(
              height: 500.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 20.h,
                    child: Container(
                      width: 329.w,
                      height: 450.h,
                      decoration: BoxDecoration(
                        color: BLACK_COLOR,
                        borderRadius: BorderRadius.circular(8.r),
                        border: BoxBorder.all(color: BLUE_COLOR, width: 2.w),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '난이도',
                                    style: defaultTextStyle.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SimpleDialog(
                                        backgroundColor: DARK_GREY_COLOR,
                                        children: [
                                          Text(
                                            'nlabalsdasdasd',
                                            style: defaultTextStyle,
                                          ),
                                          SimpleDialogOption(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              '취소',
                                              style: TextStyle(
                                                color: WHITE_COLOR,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Icon(
                                  Icons.question_mark_sharp,
                                  color: GREY_COLOR,
                                  size: 22.sp,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _renderLevelButtonWithDescription(label: 'EASY'),
                              _renderLevelButtonWithDescription(label: 'HARD'),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              disabledBackgroundColor: GREY_COLOR,
                              fixedSize: Size(288.w, 35.h),
                              backgroundColor: BLUE_COLOR,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(
                                  8.r,
                                ),
                              ),
                            ),
                            onPressed:
                                isEasySelected == null
                                    ? null
                                    : () async {
                                      await ref
                                          .read(gameRepositoryProvider)
                                          .subtractAttemptCount();
                                      // ref.invalidate(gameAttemptCountProvider);
                                      context.goNamed(
                                        GameScreen.routeName,
                                        pathParameters: {'seq': '1'},
                                        queryParameters: {
                                          'isNormal':
                                              '${isEasySelected! ? true : false}',
                                          'isImage':
                                              '${widget.isImage ? true : false}',
                                        },
                                      );
                                    },
                            child: Center(
                              child: Text('시작하기', style: defaultTextStyle),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0.h,
                    child: Container(
                      height: 44.h,
                      width: 180.w,
                      decoration: BoxDecoration(
                        color: BLUE_COLOR,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          widget.isImage ? '사진 맞추기' : '이름 맞추기',
                          style: defaultTextStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderLevelButtonWithDescription({required String label}) {
    final isEasy = label == 'EASY' ? true : false;
    return SizedBox(
      width: 130.w,
      child: Column(
        children: [
          SizedBox(
            height: 106.h,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isEasySelected = isEasy ? true : false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: BLACK_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(8.0),
                  side: BorderSide(
                    color:
                        isEasySelected != null &&
                                (isEasy && isEasySelected! ||
                                    !isEasy && !isEasySelected!)
                            ? BLUE_COLOR
                            : GREY_COLOR,
                    width: 2.w,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  '$label\nMODE',
                  style: defaultTextStyle.copyWith(fontSize: 15.sp),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label == 'EASY' ? easyGameDescription : hardGameDescription,
            style: defaultTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
