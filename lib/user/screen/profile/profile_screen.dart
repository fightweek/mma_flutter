import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mma_flutter/common/component/point_with_icon.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/model/user_profile_model.dart';
import 'package:mma_flutter/user/provider/user_profile_provider.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';
import 'package:mma_flutter/user/screen/profile/footer.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(userProfileProvider);
    final userState = ref.watch(userProvider) as UserModel;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 25.h, bottom: 18.h),
          child: SvgPicture.asset(
            'asset/img/icon/profile.svg',
            width: 68.w,
            height: 68.h,
          ),
        ),
        _renderNicknameWithEdit(nickname: userState.nickname!),
        Padding(
          padding: EdgeInsets.only(top: 19.h, bottom: 40.h),
          child: _renderBetRecordWithBelt(
            profileState: profileState,
            point: userState.point,
          ),
        ),
        _renderBeltSequence(point: userState.point),
        Expanded(child: Footer(profileState: profileState)),
      ],
    );
  }

  Widget _renderNicknameWithEdit({required String nickname}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(nickname, style: defaultTextStyle.copyWith(fontSize: 20.sp)),
        SizedBox(width: 5.w),
        SvgPicture.asset('asset/img/icon/edit.svg', width: 20.w, height: 20.h),
      ],
    );
  }

  Widget _renderBetRecordWithBelt({
    required StateBase<UserProfileModel> profileState,
    required int point,
  }) {
    return Container(
      width: 362.w,
      height: 92.h,
      decoration: BoxDecoration(
        color: WHITE_COLOR,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: beltByPoint(point: point),
          ),
          SizedBox(width: 18.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _beltNameByPoint(point: point),
                style: TextStyle(
                  color: BLACK_COLOR,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6.h),
              if (profileState is StateData<UserProfileModel>)
                Text(
                  _betRecord(betRecord: profileState.data!.userBetRecord),
                  style: TextStyle(color: BLACK_COLOR, fontSize: 12.sp),
                ),
            ],
          ),
          Expanded(child: SizedBox()),
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: PointWithIcon(point: point, color: BLACK_COLOR),
          ),
        ],
      ),
    );
  }

  Widget _renderBeltSequence({required int point}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _renderBeltWithName(
          beltName: '화이트 벨트',
          engBeltName: 'white',
          isUnlocked: true,
        ),
        _renderBeltWithName(
          beltName: '블루 벨트',
          engBeltName: 'blue',
          isUnlocked: point >= 10000,
        ),
        _renderBeltWithName(
          beltName: '퍼플 벨트',
          engBeltName: 'purple',
          isUnlocked: point >= 20000,
        ),
        _renderBeltWithName(
          beltName: '브라운 벨트',
          engBeltName: 'brown',
          isUnlocked: point >= 50000,
        ),
        _renderBeltWithName(
          beltName: '블랙 벨트',
          engBeltName: 'black',
          isUnlocked: point >= 100000,
        ),
      ],
    );
  }

  Widget _renderBeltWithName({
    required String beltName,
    required String engBeltName,
    required bool isUnlocked,
  }) {
    return Column(
      children: [
        Image.asset(
          'asset/img/icon/${isUnlocked ? engBeltName : 'locked'}_belt.png',
          width: 34.w,
          height: 34.h,
        ),
        SizedBox(height: 8.h),
        Text(
          beltName,
          style: TextStyle(
            color: isUnlocked ? GREY_COLOR : WHITE_COLOR,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  String _beltNameByPoint({required int point}) {
    switch (point) {
      case < 10000:
        return '화이트 벨트';
      case < 20000:
        return '블루 벨트';
      case < 50000:
        return '퍼플 벨트';
      case < 100000:
        return '브라운 벨트';
      default:
        return '블랙 벨트';
    }
  }

  String _betRecord({required UserBetRecordModel betRecord}) {
    return '${betRecord.win}승 ${betRecord.loss}패(배팅 전적)';
  }
}
