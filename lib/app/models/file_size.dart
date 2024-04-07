import 'dart:math';

import 'package:intl/intl.dart';
import 'package:nylo_framework/nylo_framework.dart';

/// FileSize Model.

class FileSize extends Model {
  /// File size in bytes.
  final int bytes;
  final String display;

  FileSize({
    required this.bytes,
    required this.display,
  });

  factory FileSize.size(size) {
    return FileSize(
      bytes: size,
      display: formatFileSize(size),
    );
  }

  static String formatFileSize(int bytes) {
    if (bytes <= 1024) return "0 B";
    final suffixes = [
      'B',
      'KB',
      'MB',
      'GB',
      'TB',
    ];
    int i = (log(bytes) / log(1024)).floor();
    final double value = (bytes / pow(1024, i));
    final formatter = NumberFormat.decimalPattern();
    return '${formatter.format(value)} ${suffixes[i]}';
  }
}
