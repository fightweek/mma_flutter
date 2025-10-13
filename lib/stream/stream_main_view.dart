import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mma_flutter/common/service/admob_service.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/stream/bet/screen/bet_screen.dart';
import 'package:mma_flutter/stream/chat/model/join_request_model.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';
import 'package:mma_flutter/stream/model/stream_message_request_model.dart';
import 'package:mma_flutter/stream/model/stream_message_response_model.dart';
import 'package:mma_flutter/stream/bet/provider/bet_history_provider.dart';
import 'package:mma_flutter/stream/provider/socket_stream_provider.dart';
import 'package:mma_flutter/stream/provider/stream_component_providers.dart';
import 'package:mma_flutter/stream/provider/stream_fight_event_provider.dart';
import 'package:mma_flutter/stream/bet/screen/bet_history_screen.dart';
import 'package:mma_flutter/stream/chat/screen/chat_room.dart';
import 'package:mma_flutter/stream/screen/stream_fight_event_detail_screen.dart';
import 'package:mma_flutter/stream/screen/stream_fighter_info_screen.dart';
import 'package:mma_flutter/user/model/user_model.dart';

class StreamMainView extends ConsumerStatefulWidget {
  final UserModel user;

  const StreamMainView({required this.user, super.key});

  @override
  ConsumerState<StreamMainView> createState() => _StreamMainViewState();
}

class _StreamMainViewState extends ConsumerState<StreamMainView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  BannerAd? banner;

  @override
  void initState() {
    print('--stream main view init--');
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
    banner = BannerAd(
      size: AdSize.banner,
      adUnitId: AdMobService.bannerAdUnitId,
      listener: AdMobService.bannerAdListener,
      request: AdRequest(),
    )..load();

    Future.microtask(() {
      ref.listenManual<AsyncValue<StreamMessageResponseModel>>(
        socketResponseProvider,
        (prev, next) {
          next.whenData((message) {
            if (message.responseMessageType == ResponseMessageType.talk) {
              print('talk response received');
              ref
                  .read(chatResponseProvider.notifier)
                  .update((state) => message.chatMessageResponse!);
            } else if (message.responseMessageType ==
                ResponseMessageType.fight) {
              print('fight response received');
              ref
                  .read(streamFightEventProvider.notifier)
                  .update(message.streamFightEvent!);
            } else if (message.responseMessageType ==
                ResponseMessageType.connectionCount) {
              ref
                  .read(connectionCountProvider.notifier)
                  .update((state) => message.connectionCount!);
            }
          });
        },
      );
    });
  }

  @override
  void deactivate() {
    ref.invalidate(socketProvider);
    super.deactivate();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild stream main view');
    final socket = ref.watch(socketProvider);
    final state = ref.watch(streamFightEventProvider);

    socket.sink.add(
      json.encode(
        StreamMessageRequestModel(
          requestMessageType: RequestMessageType.join,
          chatJoinRequest: JoinRequestModel(
            nickname: widget.user.nickname!,
            userId: widget.user.id,
          ),
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.h),
        child: AppBar(
          backgroundColor: BLACK_COLOR,
          foregroundColor: WHITE_COLOR,
        ),
      ),
      body: Column(
        children: [
          _header(state: state),
          Container(
            height: 50.h,
            color: Colors.yellow,
            child: banner == null ? Container() : AdWidget(ad: banner!),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  color: BLACK_COLOR,
                  height: 66.h,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: GREY_COLOR,
                    indicatorColor: Colors.red,
                    labelStyle: TextStyle(fontSize: 12.h),
                    // 선택된 탭 텍스트 스타일
                    unselectedLabelStyle: TextStyle(fontSize: 12.h),
                    // 선택되지 않은 탭 텍스트 스타일
                    tabs: [
                      Tab(
                        icon: Icon(Icons.info_outline, size: 20.h),
                        text: 'INFO',
                      ),
                      Tab(
                        icon: Icon(FontAwesomeIcons.noteSticky, size: 20.h),
                        text: 'CARDS',
                      ),
                      Tab(
                        icon: Icon(Icons.how_to_vote, size: 20.h),
                        text: 'BET',
                      ),
                      Tab(icon: Icon(Icons.list, size: 20.h), text: 'HISTORY'),
                      Tab(
                        icon: Icon(Icons.chat_bubble_outline_sharp, size: 20.h),
                        text: 'CHAT',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      _renderFighterInfoScreen(state: state),
                      StreamFightEventDetailScreen(
                        tabController: _tabController,
                      ),
                      BetScreen(
                        tabController: _tabController,
                        key: UniqueKey(),
                      ),
                      _renderBetHistoryScreen(state: state),
                      ChatRoom(user: widget.user, socket: socket),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderFighterInfoScreen({
    required StateBase<StreamFightEventModel> state,
  }) {
    if (state is! StateData) {
      return _renderNonDataState(state);
    }
    final ffe = _getCurrentOFirstFightEvent(
      state as StateData<StreamFightEventModel>,
    );
    return FighterInfoScreen(f1: (ffe).winner, f2: ffe.loser);
  }

  Widget _renderBetHistoryScreen({
    required StateBase<StreamFightEventModel> state,
  }) {
    if (state is! StateData) {
      return _renderNonDataState(state);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(selectedBetHistoryEventIdProvider.notifier)
          .update((s) => (state as StateData<StreamFightEventModel>).data!.id);
    });
    return BetHistoryScreen(
      tabController: _tabController,
      userPoint: widget.user.point,
    );
  }

  Widget _header({required StateBase<StreamFightEventModel> state}) {
    if (state is! StateData) {
      return _renderNonDataState(state);
    }
    final ffe = _getCurrentOFirstFightEvent(
      state as StateData<StreamFightEventModel>,
    );
    final leftPercent = ffe.winnerVoteRate.toInt();
    final rightPercent = ffe.loserVoteRate.toInt();
    final winnerRate = leftPercent > rightPercent ? leftPercent : rightPercent;
    return Container(
      height: 226.h,
      color: BLACK_COLOR,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  bottom: 0.h,
                  child: Image.asset(
                    'asset/img/logo/stream_view_header_cage.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  left: 0.w,
                  right: 0.w,
                  child: Text(
                    '${ffe.fightWeight} MATCH',
                    style: defaultTextStyle.copyWith(
                      fontSize: 28.sp,
                      fontFamily: 'Dalmation',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Positioned(
                  top: 20.h,
                  left: 0.w,
                  right: 0.w,
                  child: _renderCurrentFighterBodyImages(ffe),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 24.h,
            child: Row(
              children: [
                Expanded(
                  flex:
                      leftPercent != rightPercent
                          ? winnerRate == leftPercent
                              ? leftPercent + 80
                              : leftPercent + 20
                          : 5,
                  child: Container(
                    color: RED_COLOR,
                    child: Text(
                      '$leftPercent%',
                      style: defaultTextStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Expanded(
                  flex:
                      leftPercent != rightPercent
                          ? winnerRate == rightPercent
                              ? rightPercent + 80
                              : rightPercent + 20
                          : 5,
                  child: Container(
                    color: BLUE_COLOR,
                    child: Text(
                      '$rightPercent%',
                      style: defaultTextStyle,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderCurrentFighterBodyImages(StreamFighterFightEventModel ffe) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _renderHeaderFighterInfo(
          name: ffe.winner.name,
          bodyUrl: ffe.winner.bodyUrl,
          color: RED_COLOR,
        ),
        _renderHeaderFighterInfo(
          name: ffe.loser.name,
          bodyUrl: ffe.loser.bodyUrl,
          color: BLUE_COLOR,
        ),
      ],
    );
  }

  _renderHeaderFighterInfo({
    required String bodyUrl,
    required String name,
    required Color color,
  }) {
    final imageHeight = 135.h;
    final imageWidth = 105.w;
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: bodyUrl,
          height: imageHeight,
          width: imageWidth,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: color, width: 2.0),
            color: Colors.black,
          ),
          child: SizedBox(
            width: imageWidth,
            child: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 13.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  /// last : 아직 이벤트 시작하지 않은 경우
  StreamFighterFightEventModel _getCurrentOFirstFightEvent(
    StateData<StreamFightEventModel> state,
  ) {
    final fe = state.data!;
    return fe.fighterFightEvents.firstWhereOrNull(
          (e) => e.status == StreamFighterFightEventStatus.now,
        ) ??
        fe.fighterFightEvents.first;
  }

  Widget _renderNonDataState(StateBase<StreamFightEventModel> state) {
    if (state is StateLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (state is StateError) {
      return ElevatedButton(
        onPressed: () {
          ref
              .read(streamFightEventProvider.notifier)
              .getCurrentFightEventInfo();
        },
        child: Text('다시시도'),
      );
    }
    return SizedBox();
  }
}
