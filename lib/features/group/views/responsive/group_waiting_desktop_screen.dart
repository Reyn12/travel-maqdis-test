import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/widgets/w_enum_loading_anim.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';
import 'package:maqdis_connect/features/group/controllers/group_controller.dart';
import 'package:maqdis_connect/features/group/models/check_user_in_group.dart';
import 'package:maqdis_connect/features/group/lazy_loader/waiting_screen_loader.dart';
import 'package:maqdis_connect/features/group/widgets/build_user_avatar.dart';

class GroupWaitingDesktopScreen extends StatelessWidget {
  const GroupWaitingDesktopScreen({super.key, required this.groupController});

  final GroupController groupController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 8,
      child: Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<String?>(
          future: SharedPreferencesService.getIdUser(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: WEnumLoadingAnim()));
            }

            final myIdUser = snapshot.data!;

            return Obx(() {
              if (groupController.isLoading.value) {
                return const WaitingScreenLoader();
              }

              List<CheckUserInGroupModel> sortedUsers =
                  List.from(groupController.groupUsers);
              sortedUsers.sort((a, b) {
                if (a.userId == myIdUser) {
                  return -1;
                }
                if (b.userId == myIdUser) return 1;
                return 0;
              });

              return GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.35,
                ),
                itemBuilder: (context, index) => BuildUserAvatar(
                  userData: sortedUsers[index],
                  index: index,
                  myIdUser: myIdUser,
                  fontSize: 24,
                ),
                itemCount: sortedUsers.length,
              );
            });
          },
        ),
      ),
    );
  }
}
