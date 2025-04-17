import 'package:get/get.dart';
import 'package:maqdis_connect/features/group/controllers/get_list_group_controller.dart';
import 'package:maqdis_connect/features/group/controllers/group_controller.dart';
import 'package:maqdis_connect/features/group/controllers/group_list_controller.dart';
import 'package:maqdis_connect/features/group/controllers/perjalanan_controller.dart';

class GroupWaitingBinding implements Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<GroupController>(() => GroupController())
      ..lazyPut<GetListGroupController>(() => GetListGroupController())
      ..lazyPut<GroupListController>(() => GroupListController())
      ..lazyPut<PerjalananController>(() => PerjalananController());
  }
}
