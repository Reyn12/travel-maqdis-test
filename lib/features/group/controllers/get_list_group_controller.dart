import 'package:get/get.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';
import 'package:maqdis_connect/features/group/services/group_service.dart';

class GetListGroupController extends GetxController {
  final groupService = GroupService();

  RxnString roomId = RxnString();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('GetListGroupController initialized');
    fetchRoomId(); // Panggil fetchRoomId saat inisialisasi
  }

  Future<void> fetchRoomId() async {
    try {
      isLoading.value = true;
      print('Fetching grupId from SharedPreferences...');

      // Fetch grupId from SharedPreferences
      final grupId = await SharedPreferencesService.getGroupId();
      print('grupId found: $grupId');

      if (grupId == null) {
        throw Exception('grupId not found in SharedPreferences');
      }

      // Fetch group list
      print('Fetching group list...');
      final groups = await groupService.getListGroup();
      print('Group list fetched: ${groups.length} items.');

      // Debug group list
      print('Group list: ${groups.map((g) => g.grupId).toList()}');

      // Find the matching group
      final matchingGroup = groups.firstWhere(
        (group) => group.grupId == grupId,
        orElse: () => throw Exception('Group not found for grupId: $grupId'),
      );

      print('Matching group found: $matchingGroup');

      roomId.value = matchingGroup.roomId;
      print('Matching roomId: ${roomId.value}');

      // Save roomId using SharedPreferencesService.saveRoomid
      if (matchingGroup.roomId != null) {
        print('Saving roomId using SharedPreferencesService.saveRoomid...');
        await SharedPreferencesService.saveRoomid(matchingGroup.roomId!);
        print('Saved roomId: ${matchingGroup.roomId}');
      } else {
        print('No roomId found for the matching group.');
      }
    } catch (e) {
      print('Error in fetchRoomId: $e');
      roomId.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
