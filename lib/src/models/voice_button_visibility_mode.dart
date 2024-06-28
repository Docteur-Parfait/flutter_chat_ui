/// Used to toggle the visibility behavior of the [VoiceButton] based on the
/// [TextField] state inside the [Input] widget.
enum VoiceButtonVisibilityMode {
  /// Always show the [VoiceButton] regardless of the [TextField] state.
  always,

  /// The [VoiceButton] will only appear when the [TextField] is not empty.
  recording,

  /// Always hide the [VoiceButton] regardless of the [TextField] state.
  hidden,
}
