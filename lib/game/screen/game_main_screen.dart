import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mma_flutter/common/component/point_with_icon.dart';
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
    final attemptCount = ref.watch(gameAttemptCountProvider);
    final user = ref.watch(userProvider) as UserModel;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 82.h),
          child: Image.asset('asset/img/logo/fight_week_white.png'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 7.5.h),
          child: _renderQuizButton(context, text: '이름 맞추기'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 7.5.h),
          child: _renderQuizButton(context, text: '사진 맞추기'),
        ),
        SizedBox(height: 92.h,),
        _renderBorderContainer(
          label: '내 포인트',
          child: PointWithIcon(user: user),
        ),
        attemptCount.when(
          data:
              (data) => _renderBorderContainer(
                label: '오늘 남은 게임 횟수',
                child: Text('$data', style: defaultTextStyle),
              ),
          error:
              (error, stackTrace) => ElevatedButton(
                onPressed: () {
                  ref.invalidate(gameAttemptCountProvider);
                },
                child: Text(
                  '다시 시도',
                  style: defaultTextStyle.copyWith(color: BLACK_COLOR),
                ),
              ),
          loading: () => Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }

  Widget _renderQuizButton(BuildContext context, {required String text}) {
    return ElevatedButton(
      onPressed: () {
        print(text == '사진 맞추기');
        context.goNamed(
          GameDescriptionScreen.routeName,
          pathParameters: {'isImage': '${text == '사진 맞추기' ? true : false}'},
        );
      },
      style: ElevatedButton.styleFrom(
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

  _renderBorderContainer({required String label, required Widget child}) {
    return Column(
      children: [
        Text(
          label,
          style: defaultTextStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(height: 16.h,),
        Container(
          height: 36.h,
          width: 226.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: BoxBorder.all(color: BLUE_COLOR, width: 2.w),
          ),
          child: Center(child: child),
        ),
        SizedBox(height: 20.h,),
      ],
    );
  }
}
