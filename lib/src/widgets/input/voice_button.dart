import 'package:flutter/material.dart';

import '../state/inherited_chat_theme.dart';

/// A class that represents attachment button widget.
class VoiceButton extends StatefulWidget {
  /// Creates attachment button widget.
  const VoiceButton({
    super.key,
    this.isLoading = false,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.onPanLeft,
    this.onPanUp,
    this.padding = EdgeInsets.zero,
  });

  /// Show a loading indicator instead of the button.
  final bool isLoading;

  /// Callback for attachment button tap event.
  final void Function(LongPressStartDetails)? onLongPressStart;

  /// Callback for attachment button tap event.
  final void Function(LongPressEndDetails)? onLongPressEnd;

  /// Callback for attachment button tap event.
  final void Function(void)? onPanLeft;

  /// Callback for attachment button tap event.
  final void Function(void)? onPanUp;

  /// Padding around the button.
  final EdgeInsets padding;

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton> {
  Offset _startSwipePosition = Offset.zero; // Position de départ du glissement

  @override
  Widget build(BuildContext context) => Container(
        margin: InheritedChatTheme.of(context).theme.voiceButtonMargin ??
            const EdgeInsetsDirectional.fromSTEB(
              0,
              0,
              8,
              0,
            ),
        child: GestureDetector(
          onLongPressStart: widget.onLongPressStart,
          onLongPressEnd: widget.onLongPressEnd,
          onPanStart: (details) {
            _startSwipePosition = details.localPosition;
          },
          onPanEnd: (details) {
            // Calcule la différence entre la position de départ et la fin du glissement
            final swipeDifference =
                _startSwipePosition - details.velocity.pixelsPerSecond;

            // Si la différence horizontale est supérieure à la verticale
            if (swipeDifference.dx.abs() > swipeDifference.dy.abs()) {
              // Glissement horizontal détecté
              if (swipeDifference.dx > 0) {
                widget.onPanLeft;
              }
            } else {
              // Glissement vertical détecté
              if (swipeDifference.dy > 0) {
                widget.onPanUp;
              }
            }
          },
          child: Container(
            constraints: const BoxConstraints(
              minHeight: 24,
              minWidth: 24,
            ),
            child: widget.isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        InheritedChatTheme.of(context).theme.inputTextColor,
                      ),
                    ),
                  )
                : InheritedChatTheme.of(context).theme.voiceButtonIcon ??
                    Image.asset(
                      'assets/icon-voice.png',
                      color:
                          InheritedChatTheme.of(context).theme.inputTextColor,
                      package: 'flutter_chat_ui',
                    ),
            // onPressed:onPressed,
            // padding: padding,
            // splashRadius: 24,
            // tooltip:
            //     InheritedL10n.of(context).l10n.attachmentButtonAccessibilityLabel,
          ),
        ),
      );
}
