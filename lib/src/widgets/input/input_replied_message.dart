import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../../flutter_chat_ui.dart';
import '../state/inherited_chat_theme.dart';
import '../state/inherited_user.dart';

class InputRepliedMessage extends StatelessWidget {
  const InputRepliedMessage(
      {super.key,
      required this.message,
      this.backgroundColor,
      this.borderColor,
      this.authorNameColor,
      this.messageColor});

  final types.Message message;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? authorNameColor;
  final Color? messageColor;

  @override
  Widget build(BuildContext context) {
    final theme = InheritedChatTheme.of(context).theme;

    var repliedMessage = '';
    if (message.type == types.MessageType.text) {
      repliedMessage = (message as types.TextMessage).text;
    } else if (message.type == types.MessageType.image) {
      repliedMessage = '🖼️ Image';
    } else if (message.type == types.MessageType.audio) {
      repliedMessage = '🎵 Audio';
    } else if (message.type == types.MessageType.video) {
      repliedMessage = '📹 Video';
    } else if (message.type == types.MessageType.file) {
      repliedMessage = '📎 File';
    } else {
      repliedMessage = '';
    }
    final user = InheritedUser.of(context).user;

    // final currentUserisRepliedAuthor =
    //     message.author.id == repliedMessage.author.id;
    return Container(
      padding: const EdgeInsets.only(left: 5),
      margin: const EdgeInsets.only(top: 6, left: 5),
      decoration: BoxDecoration(
        border: Border(
            left: BorderSide(
                width: 3,
                color: borderColor ??
                    (InheritedChatTheme.of(context).theme.primaryColor))),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(4),
          topLeft: Radius.circular(4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message.author.firstName!,
              style: theme.userNameTextStyle
                  .copyWith(color: authorNameColor ?? Colors.white)),
          TextMessageText(
            bodyTextStyle: messageColor != null
                ? theme.sentMessageBodyTextStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 13)
                : theme.sentMessageBodyTextStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 13),
            text: repliedMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
