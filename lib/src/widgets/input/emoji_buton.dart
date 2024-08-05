import 'package:flutter/material.dart';

import '../state/inherited_chat_theme.dart';
import '../state/inherited_l10n.dart';

/// A class that represents attachment button widget.
class EmojiButton extends StatelessWidget {
  /// Creates attachment button widget.
  const EmojiButton({
    super.key,
    this.isActive = false,
    this.onPressed,
    this.padding = EdgeInsets.zero,
  });

  /// Show a an emoji or keyboard
  final bool isActive;

  /// Callback for attachment button tap event.
  final VoidCallback? onPressed;

  /// Padding around the button.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
        margin: InheritedChatTheme.of(context).theme.voiceButtonMargin ??
            const EdgeInsetsDirectional.fromSTEB(
              0,
              0,
              8,
              0,
            ),
        child: IconButton(
          constraints: const BoxConstraints(
            minHeight: 24,
            minWidth: 24,
          ),
          icon: isActive
              ? InheritedChatTheme.of(context).theme.voiceButtonIcon ??
                  Image.asset(
                    'assets/icon-voice.png',
                    color: InheritedChatTheme.of(context).theme.inputTextColor,
                    package: 'flutter_chat_ui',
                  )
              : InheritedChatTheme.of(context).theme.voiceButtonIcon ??
                  Image.asset(
                    'assets/icon-voice.png',
                    color: InheritedChatTheme.of(context).theme.inputTextColor,
                    package: 'flutter_chat_ui',
                  ),
          onPressed: isActive ? null : onPressed,
          padding: padding,
          splashRadius: 24,
          tooltip:
              InheritedL10n.of(context).l10n.attachmentButtonAccessibilityLabel,
        ),
      );
}
