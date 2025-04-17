import 'package:get/get.dart';
import 'package:maqdis_connect/features/room/services/room_service.dart';

class RoomRefreshTokenController extends GetxController {
  final RoomServices _getRoomService = RoomServices();

  Future<void> getRoomRefreshToken() async {
    await _getRoomService.refreshAndSaveTokenSpeaker();
  }
}
