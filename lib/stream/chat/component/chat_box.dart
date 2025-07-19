import 'package:flutter/material.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/stream/chat/model/chat_response_model.dart';
import 'package:mma_flutter/user/model/user_model.dart';

class ChatBox extends StatelessWidget {
  final UserModel user;
  final ChatResponseModel chatModel;

  const ChatBox({required this.user, required this.chatModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          user.nickname == chatModel.nickname
              ? Alignment.centerRight
              : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user.nickname != chatModel.nickname)
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
                    style: TextStyle(fontSize: 12.0),
                  ),
                ],
              ),
            ),
          UnconstrainedBox(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  chatModel.message,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
