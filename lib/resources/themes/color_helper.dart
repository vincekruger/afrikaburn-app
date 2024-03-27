import 'dart:ui';

Color? colorFromValue(dynamic config) {
  if (config.isEmpty) return null;
  return Color.fromARGB(
    config['alpha'],
    config['red'],
    config['green'],
    config['blue'],
  );
}
