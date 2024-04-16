import 'dart:async';

import 'package:afrikaburn/app/models/guide.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nylo_framework/nylo_framework.dart';

class GuideDownloadProvider implements NyProvider {
  static final FirebaseStorage storage = FirebaseStorage.instance;
  static final String localAssetFolder = 'Guides';

  @override
  boot(Nylo nylo) async {
    return nylo;
  }

  @override
  afterBoot(Nylo nylo) async {}

  /// Singleton Instance of GuideDownloadProvider
  static GuideDownloadProvider instance(Guide guide) {
    GuideDownloadProvider i = GuideDownloadProvider();
    i.guide = guide;
    return i;
  }

  late StreamSubscription? downloadSubscription;

  /// Guide Model
  late Guide _guide;
  Guide get guide => _guide;
  void set guide(Guide guide) {
    _guide = guide;
  }

  /// If the local file exists
  Future<bool> existsLocal() async => (await guide.file).existsSync();

  /// Download the guide to local storage
  Future<void> downloadGuide(String stateKey) async {
    try {
      // Create a local file reference
      final localFile = await guide.file;
      final remoteFileRef = storage.ref().child(guide.remotePath);
      final downloadTask = remoteFileRef.writeToFile(localFile);

      downloadSubscription = downloadTask.snapshotEvents.listen((event) {
        if (event.bytesTransferred > 0) {
          updateState(stateKey,
              data: event.bytesTransferred.toDouble() /
                  event.totalBytes.toDouble());
        }
      });
      await downloadTask;
    } on FirebaseException catch (e) {
      // Handle download error
      print(e.message);

      // TODO Add some proper error handling here
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Error downloading file: ${e.message}'),
      //   ),
      // );
    }
  }
}
