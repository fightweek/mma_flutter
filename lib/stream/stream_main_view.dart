import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/stream/chat/model/chat_request_model.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';
import 'package:mma_flutter/stream/model/stream_message_request_model.dart';
import 'package:mma_flutter/stream/model/stream_message_response_model.dart';
import 'package:mma_flutter/stream/provider/socket_stream_provider.dart';
import 'package:mma_flutter/stream/provider/stream_component_providers.dart';
import 'package:mma_flutter/stream/provider/stream_fight_event_provider.dart';
import 'package:mma_flutter/stream/screen/bet_screen.dart';
import 'package:mma_flutter/stream/screen/chat_room.dart';
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

  @override
  void initState() {
    print('--stream main view init--');
    _tabController = TabController(length: 4, vsync: this);
    super.initState();

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
    final socket = ref.watch(socketProvider);
    socket.sink.add(
      json.encode(
        StreamMessageRequestModel(
          requestMessageType: RequestMessageType.join,
          chatMessageRequest: ChatRequestModel(
            message: widget.user.nickname!,
            point: widget.user.point,
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(height: 256, child: _header()),
          Container(height: 60.0, color: Colors.yellow),
          Expanded(
            child: Column(
              children: [
                Container(
                  color: Colors.black87,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: GREY_COLOR,
                    indicatorColor: Colors.red,
                    tabs: [
                      Tab(
                        icon: Icon(Icons.info_outline, size: 20.0),
                        text: 'INFO',
                      ),
                      Tab(
                        icon: Icon(FontAwesomeIcons.noteSticky, size: 20.0),
                        text: 'CARDS',
                      ),
                      Tab(
                        icon: Icon(Icons.how_to_vote, size: 20.0),
                        text: 'BET',
                      ),
                      Tab(
                        icon: Icon(Icons.chat_bubble_outline_sharp, size: 20.0),
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
                      _renderFighterInfoScreen(),
                      Container(
                        color: DARK_GREY_COLOR,
                        child: StreamFightEventDetailScreen(
                          tabController: _tabController,
                        ),
                      ),
                      BetScreen(key: UniqueKey(),),
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

  Widget _renderFighterInfoScreen() {
    final state = ref.watch(streamFightEventProvider);
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
    final fe = (state as StateData<StreamFightEventModel>)
        .data!;
    StreamFighterFightEventModel? ffe  = fe
        .fighterFightEvents
        .firstWhereOrNull((e) => (e.status == StreamFighterFightEventStatus.now));
    ffe ??= fe.fighterFightEvents.last;
    return FighterInfoScreen(f1: (ffe).winner, f2: ffe.loser);
  }

  _header() {
    return Container(
      color: DARK_GREY_COLOR,
      width: double.infinity,
      child: Stack(
        children: [
          Image.asset(
            'asset/img/logo/cage-removebg.png',
            fit: BoxFit.contain,
            width: double.infinity,
          ),
          _renderCurrentFighterBodyImages(),
        ],
      ),
    );
  }

  Widget _renderCurrentFighterBodyImages() {
    final state = ref.watch(streamFightEventProvider);
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
    final fe = (state as StateData<StreamFightEventModel>)
        .data!;
    StreamFighterFightEventModel? ffe  = fe
        .fighterFightEvents
        .firstWhereOrNull((e) => (e.status == StreamFighterFightEventStatus.now));
    ffe ??= fe.fighterFightEvents.last;

    return LayoutBuilder(
      builder: (context, constraints) {
        final imageHeight = constraints.maxHeight / 1.7;
        final imageWidth = constraints.maxWidth / 2 / 1.5;
        return Column(
          children: [
            Center(
              child: Text(
                '${weightClassMap[ffe!.fightWeight]} 매치',
                style: defaultTextStyle.copyWith(fontSize: imageHeight / 8),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: ffe.winner.bodyUrl,
                      height: imageHeight,
                      width: imageWidth,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: BLUE_COLOR, width: 2.0),
                        color: Colors.black,
                      ),
                      child: SizedBox(
                        width: imageWidth,
                        child: Text(
                          ffe.winner.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: ffe.loser.bodyUrl,
                      height: imageHeight,
                      width: imageWidth,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: RED_COLOR, width: 2.0),
                        color: Colors.black,
                      ),
                      child: SizedBox(
                        width: imageWidth,
                        child: Text(
                          ffe.loser.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
