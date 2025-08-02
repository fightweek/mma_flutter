import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
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
          color: DARK_GREY_COLOR,
          child: Stack(
            children: [
              Positioned(
                left: -6,
                top: 58.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('asset/img/component/red.png', height: 274.h),
                    Text(
                      DataUtils.extractLastName(data.winnerName),
                      style: defaultTextStyle.copyWith(
                        fontSize: 70.0,
                        fontFamily: 'BadGrunge',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 204.9.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset(
                    'asset/img/component/vs.png',
                    height: 123.h,
                  ),
                ),
              ),
              Positioned(
                top: 235.h,
                left: -6,
                right: 0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('asset/img/component/blue.png', height: 274.h),
                    Text(
                      DataUtils.extractLastName(data.loserName),
                      style: defaultTextStyle.copyWith(
                        fontSize: 70.0,
                        fontFamily: 'BadGrunge',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 226.h,
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
                          child: CachedNetworkImage(
                            imageUrl: data.winnerBodyUrl,
                            height: 389.h,
                            width: 280.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.8,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..scale(-1.0, 1.0),
                            child: CachedNetworkImage(
                              imageUrl: data.loserBodyUrl,
                              height: 389.h,
                              width: 280.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (data.now)
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: _renderChatRoomButton(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _renderChatRoomButton() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(8.0),
          ),
          width: 150,
          child: Column(
            children: [
              IconButton(
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
                icon: Icon(Icons.chat_outlined),
              ),
              Text(
                '실시간 채팅방',
                style: defaultTextStyle.copyWith(color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
