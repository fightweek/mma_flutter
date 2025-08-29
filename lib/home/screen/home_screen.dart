import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/screen/splash_screen.dart';
import 'package:mma_flutter/common/utils/data_utils.dart';
import 'package:mma_flutter/home/provider/home_future_provider.dart';
import 'package:mma_flutter/stream/stream_main_view.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    print(bottomInset);
    super.build(context);
    final data = ref.watch(homeFutureProvider);
    return data.when(
      error: (error, stackTrace) {
        log(error.toString());
        log(stackTrace.toString());
        return Center(
          child: ElevatedButton(
            onPressed: () {
              ref.invalidate(homeFutureProvider);
            },
            child: Text('다시 시도'),
          ),
        );
      },
      loading: () => Center(child: SplashScreen()),
      data: (data) {
        if (data == null) {
          return Center(
            child: Text('아직 차후 경기 일정이 없습니다.', style: defaultTextStyle),
          );
        }
        return Container(
          color: BLACK_COLOR,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 20.h,
                child: Text(
                  '이번 주의 메인 이벤트',
                  style: defaultTextStyle.copyWith(fontSize: 24.sp),
                ),
              ),
              Positioned(
                left: -6.w,
                top: 94.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('asset/img/component/red.png', height: 100.h),
                    Text(
                      DataUtils.extractLastName(data.winnerName),
                      style: defaultTextStyle.copyWith(
                        fontSize: 74.sp,
                        fontFamily: 'BadGrunge',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 158.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset(
                    'asset/img/component/vs.png',
                    height: 108.72.h,
                  ),
                ),
              ),
              Positioned(
                top: 253.h,
                left: -6.w,
                right: 0.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('asset/img/component/blue.png', height: 100.h),
                    Text(
                      DataUtils.extractLastName(data.loserName),
                      style: defaultTextStyle.copyWith(
                        fontSize: 74.sp,
                        fontFamily: 'BadGrunge',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 177.h,
                left: 0,
                right: 0,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerRight,
                          widthFactor: 0.8,
                          child: _renderImageWithOpacity(data.winnerBodyUrl),
                        ),
                      ),
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.8,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..scale(-1.0, 1.0),
                            child: _renderImageWithOpacity(data.loserBodyUrl),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 536.h,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: DARK_GREY_COLOR,
                  ),
                  height: 143.h,
                  width: 362.w,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 12.h, bottom: 13.5.h),
                        child: Text(
                          '${weightClassMap[data.fightWeight] ?? '-'} ${data.title ? '타이틀전' : '매치'}',
                          style: defaultTextStyle.copyWith(fontSize: 12.sp),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Text(
                              DataUtils.formatDateTimeWithNWI(
                                data.mainCardDateTimeInfo!.date,
                              ),
                              style: defaultTextStyle.copyWith(fontSize: 12.sp),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 53.h,
                            color: GREY_COLOR,
                            width: 1.w,
                          ),
                          Expanded(
                            child: Text(
                              'KST ${DataUtils.formatDurationToHHMM(data.mainCardDateTimeInfo!.time)}',
                              style: defaultTextStyle.copyWith(fontSize: 12.sp),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(336.w,31.h),
                          backgroundColor: BLUE_COLOR,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return StreamMainView(
                                  user: (ref.read(userProvider) as UserModel),
                                );
                              },
                            ),
                          );
                        },
                        child: Text(
                          '라이브 채팅 참여하기',
                          style: defaultTextStyle.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _renderImageWithOpacity(String imgUrl) {
    return Container(
      foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, BLACK_COLOR.withValues(alpha: 0.5)],
        ),
      ),
      child: CachedNetworkImage(
        imageUrl: imgUrl,
        height: 343.95.h,
        width: 280.w,
        fit: BoxFit.contain,
      ),
    );
  }
}
