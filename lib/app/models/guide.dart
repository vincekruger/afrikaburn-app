import 'dart:io';

import 'package:nylo_framework/nylo_framework.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Guide Type Enum
enum GuideType {
  WTF,
  MAP,
  MOOP,
}

final String guideLocalPath = 'Guides';

/// Ticket Model
class Guide extends Model {
  Guide(
    this.type,
    this.year, {
    this.protected = false,
  });

  final GuideType type;
  final int year;
  final bool protected;

  /// Get the local filename for the guide
  get filename {
    if (Platform.isAndroid) {
      String protectedSuffix = protected ? '_protected' : '';
      return 'guide_${type.name.toString().toLowerCase()}_${year}${protectedSuffix}.pdf';
    }

    String protectedSuffix = protected ? ' (Protected)' : '';
    switch (type) {
      case GuideType.WTF:
        return 'WTF Guide ${year}${protectedSuffix}.pdf';
      case GuideType.MAP:
        return 'Map ${year}${protectedSuffix}.pdf';
      case GuideType.MOOP:
        return 'MOOP Map ${year}${protectedSuffix}.pdf';
    }
  }

  /// Get the local relative path for the guide
  String get localPath => p.join(guideLocalPath, filename);

  /// Get the full local path for the guide
  Future<String> get fullPath async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    return p.join(appDocumentsDir.path, localPath);
  }

  /// Get the local file reference for the guide
  Future<File> get file async => File(await fullPath);

  /// Get the firebase storage path for the guide
  get remotePath {
    String protectedSuffix = protected ? '-protected' : '';
    return 'guides/${type.name.toString().toLowerCase()}-$year$protectedSuffix.pdf';
  }
}
