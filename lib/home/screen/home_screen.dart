import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/screen/home_splash_screen.dart';
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
      loading: () => Center(child: HomeSplashScreen()),
      data: (data) {
        if (data == null) {
          return Center(
            child: Text('아직 차후 경기 일정이 없습니다.', style: defaultTextStyle),
          );
        }
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.50, -0.00),
              end: Alignment(0.50, 0.90),
              colors: [
                const Color(0xFF0F0F10),
                const Color(0xFF141416),
                const Color(0xFF1F2022),
                const Color(0xFF151517),
                const Color(0xFF0F0F10),
              ],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: -1.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'asset/img/component/black_home.png',
                      height: 169.h,
                    ),
                    Positioned(
                      top: 64.h,
                      child: Text(
                        DataUtils.extractLastName(data.winnerName),
                        style: defaultTextStyle.copyWith(
                          fontSize: 65.sp,
                          fontFamily: 'Dalmation',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 36.h,
                      child: Text(
                        '${weightClassMap[data.fightWeight] ?? '-'} ${data.title ? '타이틀전' : '매치'}',
                        style: defaultTextStyle.copyWith(
                          fontSize: 16.sp,
                          letterSpacing: 6.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 162.h,
                child: Text(
                  'VS',
                  style: TextStyle(
                    color: WHITE_COLOR,
                    fontSize: 35.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'dalmation',
                  ),
                ),
              ),
              Positioned(
                top: 161.h,
                left: -6.w,
                right: 0.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'asset/img/component/black_home.png',
                      height: 169.h,
                    ),
                    Text(
                      DataUtils.extractLastName(data.loserName),
                      style: defaultTextStyle.copyWith(
                        fontSize: 74.sp,
                        fontFamily: 'Dalmation',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 168.h,
                left: 0,
                right: 0,
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerRight,
                          widthFactor: 0.95.w,
                          child: _renderImageWithOpacity(data.winnerBodyUrl),
                        ),
                      ),
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
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
                top: 500.h,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _renderName(
                          name: DataUtils.extractLastName(data.winnerName),
                          borderColor: RED_COLOR,
                        ),
                        _renderName(
                          name: DataUtils.extractLastName(data.loserName),
                          borderColor: BLUE_COLOR,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 26.h, bottom: 11.h),
                      child:
                          data.mainCardDateTimeInfo != null
                              ? Text(
                                '${DataUtils.formatDateTimeWithNWI(data.mainCardDateTimeInfo!.date)} '
                                '| KST ${DataUtils.formatDurationToHHMM(data.mainCardDateTimeInfo!.time)}',
                                style: defaultTextStyle.copyWith(
                                  fontSize: 12.sp,
                                  letterSpacing: 3.0,
                                ),
                                textAlign: TextAlign.center,
                              )
                              : SizedBox(height: 12.h),
                    ),
                    Container(
                      width: 230.w,
                      height: 37.h,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.red, Colors.blue], // 빨 -> 파
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: ElevatedButton(
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BLACK_COLOR, // 내부 배경
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          "라이브 경기 바로가기",
                          style: TextStyle(
                            color: WHITE_COLOR,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _renderName({required String name, required Color borderColor}) {
    return Container(
      constraints: BoxConstraints(minHeight: 24.h, minWidth: 150.w),
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: borderColor, width: 2.w),
        color: Colors.black,
      ),
      child: Text(
        name,
        style: defaultTextStyle.copyWith(
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
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
        height: 344.h,
        width: 226.w,
        fit: BoxFit.contain,
        errorWidget: (context, url, error) {
          return Image.asset('asset/img/component/default-headshot.png');
        },
      ),
    );
  }
}
