import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../../flutter_chat_ui.dart';
import '../state/inherited_chat_theme.dart';
import '../state/inherited_user.dart';

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

  if (duration.inHours > 0) {
    final twoDigitHours = twoDigits(duration.inHours);
    return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
  } else {
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}

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
      repliedMessage = '🎙️ Audio';
    } else if (message.repliedMessage!.type == types.MessageType.video) {
      repliedMessage = '📹 Video';
    } else if (message.repliedMessage!.type == types.MessageType.file) {
      repliedMessage = '📁 File';
    } else {
      repliedMessage = '';
    }
    final user = InheritedUser.of(context).user;

    final currentUserisAuthor = user.id == message.author.id;
    // final currentUserisRepliedAuthor =
    //     message.author.id == repliedMessage.author.id;
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      margin: const EdgeInsets.only(top: 6, left: 5, bottom: 4),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message.repliedMessage!.author.firstName!,
                  style: currentUserisAuthor
                      ? theme.userNameTextStyle
                          .copyWith(color: authorNameColor ?? Colors.white)
                      : theme.userNameTextStyle.copyWith(
                          color: authorNameColor ??
                              InheritedChatTheme.of(context)
                                  .theme
                                  .primaryColor)),
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
                        : theme.receivedMessageBodyTextStyle.copyWith(
                            fontWeight: FontWeight.w300, fontSize: 13),
                text: repliedMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          if (message.repliedMessage!.type == types.MessageType.file)
            Text(
                '(${(message.repliedMessage! as types.FileMessage).size ~/ 1024}KB)',
                style: currentUserisAuthor
                    ? theme.userNameTextStyle
                        .copyWith(color: authorNameColor ?? Colors.white)
                    : theme.userNameTextStyle.copyWith(
                        color: authorNameColor ??
                            InheritedChatTheme.of(context).theme.primaryColor)),
          if (message.repliedMessage!.type == types.MessageType.image)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: (message.repliedMessage! as types.ImageMessage).uri,
                width: 35,
                height: 35,
                fit: BoxFit.cover,
              ),
            ),
          if (message.repliedMessage!.type == types.MessageType.video)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: (message.repliedMessage! as types.VideoMessage).uri,
                width: 35,
                height: 35,
                fit: BoxFit.cover,
              ),
            ),
          if (message.repliedMessage!.type == types.MessageType.audio)
            Text(
                '(${formatDuration((message.repliedMessage! as types.AudioMessage).duration)})')
        ],
      ),
    );
  }
}
