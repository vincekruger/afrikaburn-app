import 'dart:io';

import 'package:afrikaburn/app/models/ticket.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:path_provider/path_provider.dart';
import 'package:afrikaburn/app/models/guide.dart';

class SystemProvider implements NyProvider {
  boot(Nylo nylo) async {
    setOnlyPortraitOrientation();
    return nylo;
  }

  afterBoot(Nylo nylo) async {
    await prepareDocumentDirectories();
  }

  /// Prepare the document directories when the system boots
  Future<void> prepareDocumentDirectories() async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final Directory appLibraryDir =
        Platform.isIOS ? await getLibraryDirectory() : appDocumentsDir;

    /// Tickets Directory
    final Directory ticketDir =
        Directory(p.join(appDocumentsDir.path, ticketLocalPath));
    final Directory ticketThumbnailDir =
        Directory(p.join(appLibraryDir.path, ticketThumbnailLocalPath));
    if (!ticketDir.existsSync()) ticketDir.createSync();
    if (!ticketThumbnailDir.existsSync()) ticketThumbnailDir.createSync();

    /// Guides Directory
    final Directory guidesDir =
        Directory(p.join(appDocumentsDir.path, guideLocalPath));
    if (!guidesDir.existsSync()) guidesDir.createSync();
  }

  /// Set only portrait orientation
  setOnlyPortraitOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  /// Set portrait & landscape orientation
  setPortraitAndLandscapeOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
