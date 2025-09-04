import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mma_flutter/common/component/point_with_icon.dart';
import 'package:mma_flutter/common/component/rewarded_ad_manager.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/game/provider/game_provider.dart';
import 'package:mma_flutter/game/screen/game_description_screen.dart';
import 'package:mma_flutter/game/screen/game_screen.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';

class GameMainScreen extends ConsumerWidget {
  static String get routeName => 'game_main';

  const GameMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('build game main screen');
    final user = ref.watch(userProvider) as UserModel;
    final ram = ref.watch(rewardedAdProvider);
    final attempt = ref.watch(gameAttemptCountProvider);

    return attempt.when(
      data:
          (data) => Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 82.h),
                child: Image.asset('asset/img/logo/fight_week_white.png'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 7.5.h),
                child: _renderQuizButton(
                  context,
                  text: '이름 맞추기',
                  point: user.point,
                  attemptCount: data.count,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 7.5.h),
                child: _renderQuizButton(
                  context,
                  text: '사진 맞추기',
                  point: user.point,
                  attemptCount: data.count,
                ),
              ),
              SizedBox(height: 52.h),
              _renderBorderContainer(
                label: '내 포인트',
                child: PointWithIcon(user: user),
              ),
              _renderBorderContainer(
                label: '오늘 남은 게임 횟수',
                child: Text('${data.count}', style: defaultTextStyle),
              ),
              SizedBox(
                height: 30.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BLUE_COLOR,
                    disabledBackgroundColor: GREY_COLOR,
                  ),
                  onPressed:
                      ram.isAdReady && data.adCount > 0
                          ? () {
                            ram.showRewardedAd((rewardedItem) async {
                              await ref
                                  .read(gameRepositoryProvider)
                                  .updateAttemptCount(isSubtract: false);
                              ref.invalidate(gameAttemptCountProvider);
                            });
                          }
                          : null,
                  child: Text(
                    ram.isAdReady ? '광고 보고 게임 한 판 더 하기' : '광고 준비 중',
                    style: defaultTextStyle,
                  ),
                ),
              ),
            ],
          ),
      loading: () => Center(child: CircularProgressIndicator()),
      error:
          (e, s) => Center(
            child: ElevatedButton(
              onPressed: () => ref.invalidate(gameAttemptCountProvider),
              child: Text(
                '다시 시도',
                style: defaultTextStyle.copyWith(color: BLACK_COLOR),
              ),
            ),
          ),
    );
  }

  Widget _renderQuizButton(
    BuildContext context, {
    required String text,
    required int point,
    required int attemptCount,
  }) {
    return ElevatedButton(
      onPressed:
          point <= 0 || attemptCount <= 0
              ? null
              : () {
                print(text == '사진 맞추기');
                context.goNamed(
                  GameDescriptionScreen.routeName,
                  pathParameters: {
                    'isImage': '${text == '사진 맞추기' ? true : false}',
                  },
                );
              },
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: GREY_COLOR,
        fixedSize: Size(370.w, 44.h),
        backgroundColor: BLUE_COLOR,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(8.r),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: defaultTextStyle.copyWith(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _renderBorderContainer({
    required String label,
    required Widget child,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: defaultTextStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          height: 36.h,
          width: 226.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: BoxBorder.all(color: BLUE_COLOR, width: 2.w),
          ),
          child: Center(child: child),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
