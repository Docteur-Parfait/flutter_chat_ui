import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../../flutter_chat_ui.dart';
import '../state/inherited_chat_theme.dart';
import '../state/inherited_user.dart';

class RepliedMessage extends StatelessWidget {
  const RepliedMessage(
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
    if (message.repliedMessage!.type == types.MessageType.text) {
      repliedMessage = (message.repliedMessage! as types.TextMessage).text;
    } else if (message.repliedMessage!.type == types.MessageType.image) {
      repliedMessage = '🖼️ Image';
    } else if (message.repliedMessage!.type == types.MessageType.audio) {
      repliedMessage = '🎵 Audio';
    } else if (message.repliedMessage!.type == types.MessageType.video) {
      repliedMessage = '📹 Video';
    } else if (message.repliedMessage!.type == types.MessageType.file) {
      repliedMessage = '📎 File';
    } else {
      repliedMessage = '';
    }
    final user = InheritedUser.of(context).user;

    final currentUserisAuthor = user.id == message.author.id;
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
                    (currentUserisAuthor
                        ? InheritedChatTheme.of(context).theme.secondaryColor
                        : InheritedChatTheme.of(context).theme.primaryColor))),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(4),
          topLeft: Radius.circular(4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message.author.firstName!,
              style: currentUserisAuthor
                  ? theme.userNameTextStyle
                      .copyWith(color: authorNameColor ?? Colors.white)
                  : theme.userNameTextStyle.copyWith(
                      color: authorNameColor ??
                          InheritedChatTheme.of(context).theme.primaryColor)),
          TextMessageText(
            bodyTextStyle: messageColor != null
                ? theme.sentMessageBodyTextStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 13)
                : currentUserisAuthor
                    ? theme.sentMessageBodyTextStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 13)
                    : theme.receivedMessageBodyTextStyle
                        .copyWith(fontWeight: FontWeight.w300, fontSize: 13),
            text: repliedMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
