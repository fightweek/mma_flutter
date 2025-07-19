import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/screen/splash_screen.dart';
import 'package:mma_flutter/common/utils/data_utils.dart';
import 'package:mma_flutter/home/provider/home_future_provider.dart';
import 'package:mma_flutter/home/repository/home_repository.dart';
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
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              data.eventName,
              style: defaultTextStyle.copyWith(
                fontSize: 24.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (data.mainCardDateTimeInfo != null)
              Text(
                '메인 카드\n${DataUtils.formatDateTime(data.mainCardDateTimeInfo!.date)} / ${DataUtils.formatDurationToHHMM(data.mainCardDateTimeInfo!.time)} (KST)',
                style: defaultTextStyle.copyWith(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: data.winnerBodyUrl,
                      ),
                      Text(
                        data.winnerName,
                        style: defaultTextStyle.copyWith(fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'VS',
                    style: defaultTextStyle.copyWith(fontSize: 24.0),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: data.loserBodyUrl,
                      ),
                      Text(
                        data.loserName,
                        style: defaultTextStyle.copyWith(fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (data.now)
              Column(
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
              ),
          ],
        );
      },
    );
  }
}
