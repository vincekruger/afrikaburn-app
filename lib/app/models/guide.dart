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
  Guide(GuideType this.type, int this.year);
  GuideType type;
  int year;

  /// Get the local filename for the guide
  get filename {
    switch (type) {
      case GuideType.WTF:
        return 'WTF Guide $year.pdf';
      case GuideType.MAP:
        return 'Map $year.pdf';
      case GuideType.MOOP:
        return 'MOOP Map $year.pdf';
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
  get remotePath => 'guides/${type.name.toString().toLowerCase()}-$year.pdf';
}
