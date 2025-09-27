import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/stream/chat/component/chat_box.dart';
import 'package:mma_flutter/stream/chat/model/chat_request_model.dart';
import 'package:mma_flutter/stream/chat/model/chat_response_model.dart';
import 'package:mma_flutter/stream/model/stream_message_request_model.dart';
import 'package:mma_flutter/stream/provider/socket_stream_provider.dart';
import 'package:mma_flutter/stream/provider/stream_component_providers.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatRoom extends ConsumerStatefulWidget {
  final UserModel user;
  final WebSocketChannel socket;

  const ChatRoom({required this.user, required this.socket, super.key});

  @override
  ConsumerState<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends ConsumerState<ChatRoom>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final chatList = <ChatResponseModel>[];
  final scrollController = ScrollController();
  final textController = TextEditingController();

  @override
  void initState() {
    print('--init state--');
    super.initState();
    ref.listenManual<ChatResponseModel?>(chatResponseProvider, (
      previous,
      next,
    ) {
      if (next != null) {
        setState(() {
          chatList.add(next);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final connectionCount = ref.watch(connectionCountProvider);

    super.build(context);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear,
        );
      }
    });
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: DARK_GREY_COLOR,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5.h),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.remove_red_eye_outlined,
                                size: 17.r,
                                color: Colors.white,
                              ),
                            ),
                            WidgetSpan(child: SizedBox(width: 4.0)),
                            TextSpan(
                              text: connectionCount.toString(),
                              style: TextStyle(fontSize: 15.sp, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        controller: scrollController,
                        // reverse: true,
                        itemBuilder: (_, index) {
                          return ChatBox(
                            socket: widget.socket,
                            user: widget.user,
                            chatModel: chatList[index],
                          );
                        },
                        separatorBuilder: (_, index) {
                          return const SizedBox(height: 12);
                        },
                        itemCount: chatList.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 8.h,left: 12.w,right: 12.w),
              color: DARK_GREY_COLOR,
              child: SizedBox(
                height: 45.h,
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: linearGradientInputBorder,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    fillColor: Colors.black,
                    filled: true,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: IconButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.black),
                        ),
                        onPressed: () {
                          print('onpressed');
                          _sendMessage(widget.socket);
                        },
                        icon: Icon(FontAwesomeIcons.paperPlane, color: Colors.white),
                      ),
                    ),
                  ),
                  controller: textController,
                  // 엔터키로 전송
                  onSubmitted: (value) => _sendMessage(widget.socket),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _sendMessage(socket) {
    final text = textController.text.trim();
    if (text.isNotEmpty) {
      socket.sink.add(
        json.encode(
          StreamMessageRequestModel(
            requestMessageType: RequestMessageType.talk,
            chatMessageRequest: ChatRequestModel(
              message: text,
              point: widget.user.point,
            ),
          ),
        ),
      );
    }
    textController.clear();
  }
}
