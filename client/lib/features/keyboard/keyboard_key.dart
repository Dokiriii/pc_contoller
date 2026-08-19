// features/keyboard/keyboard_key.dart

class KeyboardKey {

  final String key;

  final String label;

  final String? secondaryLabel;

  final String? shiftLabel;


  const KeyboardKey({

    required this.key,

    required this.label,

    this.secondaryLabel,

    this.shiftLabel,
  });
}
