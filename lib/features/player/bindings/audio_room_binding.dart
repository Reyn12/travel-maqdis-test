import 'package:get/get.dart';
import 'package:maqdis_connect/features/player/controllers/audio_room_controller.dart';
import 'package:maqdis_connect/features/player/controllers/player_controller.dart';

class AudioRoomBinding implements Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<AudioRoomController>(() => AudioRoomController())
      ..lazyPut<PlayerControllerTesting>(() => PlayerControllerTesting());
  }
}
