import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/stream/chat/model/chat_response_model.dart';
import 'package:mma_flutter/stream/component/report_dialog.dart';
import 'package:mma_flutter/stream/model/stream_message_request_model.dart';
import 'package:mma_flutter/stream/provider/stream_component_providers.dart';
import 'package:mma_flutter/stream/report/model/report_request_model.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatBox extends ConsumerWidget {
  final WebSocketChannel socket;
  final UserModel user;
  final ChatResponseModel chatModel;

  const ChatBox({
    required this.socket,
    required this.user,
    required this.chatModel,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isMine = user.nickname == chatModel.nickname;
    return Padding(
      padding: EdgeInsets.only(
        left: isMine ? 0 : 18.w,
        right: isMine ? 18.w : 0,
      ),
      child: Align(
        alignment:
            user.nickname == chatModel.nickname
                ? Alignment.centerRight
                : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user.nickname != chatModel.nickname)
              UnconstrainedBox(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: tierIcon(chatModel.point),
                              style: TextStyle(fontSize: 4.0),
                            ),
                            WidgetSpan(child: SizedBox(width: 4.0)),
                            TextSpan(
                              text: chatModel.nickname,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                      _renderBlockOrReport(
                        context,
                        targetUserId: chatModel.userId,
                        nickname: chatModel.nickname,
                        ref: ref,
                      ),
                    ],
                  ),
                ),
              ),
            UnconstrainedBox(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5.w,
                decoration: BoxDecoration(
                  color: BLACK_COLOR,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                  child: Text(
                    chatModel.message,
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderBlockOrReport(
    BuildContext context, {
    required int targetUserId,
    required String nickname,
    required WidgetRef ref,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _renderTextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  backgroundColor: DARK_GREY_COLOR,
                  title: Column(
                    children: [
                      Text(
                        '이 사용자를 차단하시겠습니까?\n',
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: WHITE_COLOR,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '차단하시면, 이 사용자의 메시지를 볼 수 없게 됩니다.',
                        style: TextStyle(fontSize: 12.sp, color: WHITE_COLOR),
                      ),
                    ],
                  ),
                  children: [
                    SimpleDialogOption(
                      onPressed: () {
                        socket.sink.add(
                          json.encode(
                            StreamMessageRequestModel(
                              requestMessageType: RequestMessageType.block,
                              userIdToBlock: targetUserId,
                            ),
                          ),
                        );
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('해당 사용자에 대한 차단이 완료되었습니다.')),
                        );
                      },
                      child: Text('차단', style: TextStyle(color: WHITE_COLOR)),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('취소', style: TextStyle(color: WHITE_COLOR)),
                    ),
                  ],
                );
              },
            );
          },
          label: '차단',
        ),
        Text(' | ', style: TextStyle(color: GREY_COLOR, fontSize: 14.sp)),
        _renderTextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => ReportUser(reportedId: targetUserId),
            );
          },
          label: '신고',
        ),
      ],
    );
  }

  TextButton _renderTextButton({
    required VoidCallback onPressed,
    required String label,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero, // 좌우 여백 제거
        minimumSize: Size(0, 0), // 높이 최소화
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      child: Text(label, style: TextStyle(color: GREY_COLOR, fontSize: 14.sp)),
    );
  }
}
