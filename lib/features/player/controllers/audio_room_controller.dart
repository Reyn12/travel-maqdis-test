import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';
import 'package:maqdis_connect/features/beranda/controllers/location_controller.dart';
import 'package:maqdis_connect/features/group/models/check_group_model.dart';
import 'package:maqdis_connect/features/group/services/group_service.dart';
import 'package:maqdis_connect/features/group/services/live_progress_service.dart';
import 'package:maqdis_connect/features/player/controllers/player_controller.dart';
import 'package:maqdis_connect/features/room/controllers/player-Controller/room_controller.dart';
import 'package:maqdis_connect/features/room/models/peer_track_node.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class AudioRoomController extends GetxController
    with
        HMSUpdateListener,
        HMSActionResultListener,
        HMSKeyChangeListener,
        GetSingleTickerProviderStateMixin {
  final LiveProgressServices _progressService = LiveProgressServices();
  final RoomController _authController = Get.put(RoomController());
  final PlayerControllerTesting playerController =
      Get.put(PlayerControllerTesting());
  final LocationController locationController = Get.put(LocationController());
  late TabController tabController;

  late HMSSDK _hmsSDK;
  HMSSessionStore? _hmsSessionStore;
  // var otherUsersLocation = {}.obs;
  var otherUsersLocation = <String, Position>{}.obs;

  // final List<PeerTrackNode> listener = [];
  // final List<PeerTrackNode> speaker = [];
  // final RxList<Rx<PeerTrackNode>> listener = <Rx<PeerTrackNode>>[].obs;
  // final RxList<Rx<PeerTrackNode>> speaker = <Rx<PeerTrackNode>>[].obs;
  final RxList<PeerTrackNode> listener = <PeerTrackNode>[].obs;
  final RxList<PeerTrackNode> speaker = <PeerTrackNode>[].obs;
  // final RxBool isMicrophoneMuted = false.obs;
  RxBool isMicrophoneMuted = false.obs;
  HMSPeer? _localPeer;
  final RxBool isReconnecting = false.obs;
  RxString? role = ''.obs;
  RxBool isLoadingRole = true.obs;
  var waktuPerjalanan = '00:00:00'.obs;
  Timer? _timer;
  int _elapsedSeconds = 0;

  final RxBool _isPageActive = true.obs;
  RxBool isRoomEnded = false.obs;
  RxString endRoomReason = "".obs;
  var peerNetworkQuality = <String, int>{}.obs;
  RxBool autos = false.obs;
  RxBool nextPlay = false.obs;
  RxBool firstOpen = false.obs;
  RxBool play = false.obs;
  RxBool isPreparingHmsSDK = false.obs;
  RxString? iduser = ''.obs;
  RxString? roleid = ''.obs;
  RxString? apikey = ''.obs;
  RxString? userName = ''.obs;
  RxString? photo = ''.obs;
  var peerProfilePhotos = <String, String>{}.obs;
  var peerUserIds = <String, String>{}.obs;

  @override
  void onInit() async {
    super.onInit();
    isPreparingHmsSDK.value = true;
    tabController = TabController(length: 3, vsync: this);
    locationController
        .startLocationUpdates(); // update lokasi terkini ustad dan jamaah

    try {
      await _authController.setAuthToken();
      if (_authController.authToken.isNotEmpty) {
        print('Auth Token set: ${_authController.authToken.value}');

        await initHMSSDK(); // Tunggu SDK siap dulu sebelum lanjut
        print('HMS SDK Initialized!');

        _loadUserRole(); // Setelah SDK siap, baru load role
        isPreparingHmsSDK.value = false;
        playerController.loadJsonData();
        startTimer();

        // });
      } else {
        print('Error: ${_authController.errorMessage.value}');
        Fluttertoast.showToast(msg: "Failed to set token. Please try again.");
      }
    } catch (error) {
      print('Error during token setup: $error');
      Fluttertoast.showToast(msg: "Failed to set token. Please try again.");
    }
  }

  @override
  void onClose() {
    removePageChangeListener();
    _hmsSDK.leave(hmsActionResultListener: this);
    super.onClose();
  }

  // fungsi leave room per peer 100mslive
  void leaveRoom() async {
    await _hmsSDK.leave();
  }

  // timer untuk di progress perjalanan
  void startTimer() {
    _timer?.cancel();
    _elapsedSeconds = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      int hours = _elapsedSeconds ~/ 3600;
      int minutes = (_elapsedSeconds % 3600) ~/ 60;
      int seconds = _elapsedSeconds % 60;

      waktuPerjalanan.value =
          '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    });
  }

  void stopTimer() {
    _timer?.cancel(); // Hentikan timer jika masih berjalan
    _timer = null;
  }

  Future<String?> getGroupNameById(String grupId) async {
    List<GroupModel>? grupList = await GroupService().getGrup();

    if (grupList != null) {
      GroupModel? grup = grupList.firstWhere(
        (grup) => grup.grupid == grupId,
        orElse: () => GroupModel(
            grupid: '',
            namaGrup: '',
            createdBy: '',
            createdAt: DateTime.now(),
            openUser: 0,
            status: '',
            userId: '',
            roomId: null,
            room: null),
      );

      if (grup.grupid.isNotEmpty) {
        return grup.namaGrup;
      } else {
        print("Grup dengan ID $grupId tidak ditemukan.");
        return null;
      }
    } else {
      print("Data grup tidak ditemukan.");
      return null;
    }
  }

  // get user role saat ini
  void _loadUserRole() async {
    try {
      final userRole = await SharedPreferencesService.getRole();
      role?.value = userRole!;
      isLoadingRole.value = false;
    } catch (error) {
      print("Error mendapatkan role: $error");
      isLoadingRole.value = false;
    }
  }

  // fungsi finish progress
  Future<void> finishProgress() async {
    locationController.stopLocationUpdates();
    await _progressService.finishProgress();
    stopTimer();
  }

  // Kirim lokasi ke metadata hmssdk
  void sendLocationToMetadata(double lat, double lon) {
    String newMetadata = '{"lat": $lat, "lon": $lon}';

    _hmsSDK.changeMetadata(metadata: newMetadata).then((_) {
      print("Metadata lokasi dikirim: $newMetadata");
    }).catchError((error) {
      print("Gagal mengirim metadata: $error");
    });
  }

  // Menghitung jarak antar user
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  void updateDistance(String userId, double otherLat, double otherLon) {
    double distance = calculateDistance(
      locationController.latitude.value,
      locationController.longitude.value,
      otherLat,
      otherLon,
    );
    print("Jarak ke $userId: ${distance.toStringAsFixed(2)} meter");
  }

  // menangani perubahan sessionstore hmssdk untuk doa
  void updateCurrentPage(int page, {bool isFinished = false}) {
    print("Mengirim update halaman dan status selesai...");
    print("currentDoa: $page");
    print("isFinished: $isFinished");

    _hmsSessionStore?.setSessionMetadataForKey(
      key: 'currentDoa',
      data: page.toString(),
    );

    _hmsSessionStore?.setSessionMetadataForKey(
      key: 'isFinished',
      data: isFinished.toString(),
    );
  }

  // menerima perubahan sessionstore
  void addPageChangeListener() {
    if (_hmsSessionStore != null) {
      _hmsSessionStore?.addKeyChangeListener(
        keys: ['currentDoa', 'isFinished'], // Tambahkan isFinished di sini!
        hmsKeyChangeListener: this,
      );
      print("📡 Page & status listener added.");
    }
  }

  // menangani perubahan by key yang sudah dibuat
  @override
  void onKeyChanged({required String key, required String? value}) async {
    print("onKeyChanged triggered for key: $key, value: $value");

    if (key == 'currentDoa') {
      int newPage = int.tryParse(value ?? "0") ?? 0;
      print("📄 Halaman Doa berubah ke: $newPage");

      if (playerController.currentIndex.value != newPage) {
        await playerController.audioPlayer.stop();
        playerController.currentPosition.value = Duration.zero;
        playerController.currentIndex.value = newPage;
      }
    } else if (key == 'isFinished') {
      bool finished = value == 'true';
      print("Listener menerima isFinished: $finished");

      playerController.isFinished.value = finished;
      playerController.update();
    }
  }

  void removePageChangeListener() {
    _hmsSessionStore?.removeKeyChangeListener(hmsKeyChangeListener: this);
  }

  // fungsi untuk menginisialisasi sdk hms yang dipanggil di awal audio room dibuka
  Future<void> initHMSSDK() async {
    // Ubah jadi Future<void>
    final userData = await SharedPreferencesService.getDataUser();
    userName?.value = userData.username;
    iduser?.value = userData.iduser;
    photo?.value = userData.photo;

    print('ini token 100ms : ${_authController.authToken.value}');

    if (_authController.authToken.isEmpty) return;

    await Future.delayed(const Duration(milliseconds: 2000));

    try {
      _hmsSDK = HMSSDK();
      await _hmsSDK.build();
      _hmsSDK.addUpdateListener(listener: this);

      await _hmsSDK.join(
        config: HMSConfig(
          authToken: _authController.authToken.value,
          userName: userName!.value,
          metaData: jsonEncode({
            "userId": iduser!.value,
            "photo": photo!.value,
          }),
        ),
      );
    } catch (e) {
      print('Error joining the room: $e');
    }
  }

  // fungsi toggle mic untuk speaker/ustadz yang terhubung langsung dengan hmssdk
  Future<bool> toggleMicMuteState() async {
    if (role?.value != "ustadz") {
      print("User tidak memiliki akses untuk mengontrol mikrofon.");
      return false;
    }

    try {
      HMSException? result = await _hmsSDK.toggleMicMuteState();
      if (result == null) {
        print("Microphone state toggled successfully on the backend.");
        return true;
      } else {
        print("HMSException occurred: ${result.message}");
        return false;
      }
    } catch (e) {
      print("Exception while toggling mic state: $e");
      return false;
    }
  }

  void leaveMeeting() async {
    _hmsSDK.leave(hmsActionResultListener: this);
  }

  // menangani perubahan value boolean mic dengan getx
  void toggleMic() async {
    try {
      bool isToggled = await toggleMicMuteState();
      if (isToggled) {
        isMicrophoneMuted.toggle();
      } else {
        print("Failed to toggle mic state.");
      }
    } catch (e) {
      print("Failed to toggle mic state: $e");
    }
  }

  // menangani peer saat join ke session hmssdk room
  @override
  void onJoin({required HMSRoom room}) {
    for (var peer in room.peers ?? []) {
      if (peer.isLocal) {
        _localPeer = peer;
      }

      switch (peer.role.name) {
        case 'speaker':
          int index =
              speaker.indexWhere((node) => node.uid == '${peer.peerId}speaker');
          if (index != -1) {
            speaker[index].peer = peer;
          } else {
            speaker
                .add(PeerTrackNode(uid: '${peer.peerId}speaker', peer: peer));
          }
          speaker.refresh();
          break;
        case 'listener':
          int index = listener
              .indexWhere((node) => node.uid == '${peer.peerId}listener');
          if (index != -1) {
            listener[index].peer = peer;
          } else {
            listener
                .add(PeerTrackNode(uid: '${peer.peerId}listener', peer: peer));
          }
          listener.refresh();
          break;
        default:
          break;
      }
    }
  }

  // fungsi untuk speaker/ustadz untuk menakhiri room secara keseluruhan
  void endRoom(
      {required bool lock,
      required String reason,
      HMSActionResultListener? hmsActionResultListener}) async {
    //this is the instance of class which implements HMSActionResultListener
    try {
      _hmsSDK.endRoom(
          lock: lock, reason: reason, hmsActionResultListener: this);
      Get.offAllNamed(
          '/waitingScreen'); // saat endroom maka speaker/ustadz akan dikembalikan ke waitingscreen
    } on Exception catch (e) {
      print('Error saat mengakhiri room: $e');
      Get.snackbar("Error", "Gagal mengakhiri room");
    }
  }

  // menangani perubahan saat ada peer baru yang masuk
  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    if (update == HMSPeerUpdate.metadataChanged && peer.metadata != null) {
      print("Metadata diubah untuk ${peer.name}: ${peer.metadata}");

      // menangani perubahan lokasi setiap peer dalam satuan meter
      try {
        var data = jsonDecode(peer.metadata!);
        if (data.containsKey('lat') && data.containsKey('lon')) {
          double? otherLat = data['lat'];
          double? otherLon = data['lon'];

          print(
              "Lokasi diterima: $otherLat, $otherLon untuk ${peer.customerUserId}");

          otherUsersLocation[peer.customerUserId ?? "unknown"] = Position(
            latitude: otherLat!,
            longitude: otherLon!,
            timestamp: DateTime.now(),
            accuracy: 0.0,
            altitude: 0.0,
            altitudeAccuracy: 0.0,
            heading: 0.0,
            headingAccuracy: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
          );

          otherUsersLocation.refresh();

          if (peer.customerUserId != null) {
            updateDistance(peer.customerUserId!, otherLat, otherLon);
          }
        } else {
          print("⚠️ Metadata tidak berisi lokasi untuk ${peer.customerUserId}");
        }
      } catch (e) {
        print("❌ Gagal decode metadata: $e");
      }
    }

    switch (update) {
      case HMSPeerUpdate.networkQualityUpdated:
        // menampilkan status kekuatan sinyal setiap peer
        // UNDER DEVELOPMENT - FUTURE WORK
        int quality = peer.networkQuality?.quality ?? -1;
        peerNetworkQuality[peer.peerId] = quality;
        print("Network Quality of ${peer.name}: $quality");
        break;

      case HMSPeerUpdate.peerJoined:
        if (peer.isLocal) {
          _localPeer = peer;
        }
        switch (peer.role.name) {
          case 'speaker':
            int index = speaker
                .indexWhere((node) => node.uid == '${peer.peerId}speaker');
            if (index != -1) {
              speaker[index].peer = peer;
            } else {
              speaker
                  .add(PeerTrackNode(uid: '${peer.peerId}speaker', peer: peer));
            }
            speaker.refresh();
            break;
          case 'listener':
            int index = listener
                .indexWhere((node) => node.uid == '${peer.peerId}listener');
            if (index != -1) {
              listener[index].peer = peer;
            } else {
              listener.add(
                  PeerTrackNode(uid: '${peer.peerId}listener', peer: peer));
            }
            listener.refresh();
            break;
        }
        break;
      case HMSPeerUpdate.peerLeft:
        switch (peer.role.name) {
          case 'speaker':
            int index = speaker
                .indexWhere((node) => node.uid == '${peer.peerId}speaker');
            if (index != -1) {
              speaker.removeAt(index);
            }
            speaker.refresh();
            break;
          case 'listener':
            int index = listener
                .indexWhere((node) => node.uid == '${peer.peerId}listener');
            if (index != -1) {
              listener.removeAt(index);
            }
            listener.refresh();
            break;
        }
        break;
      case HMSPeerUpdate.roleUpdated:
        break;
      case HMSPeerUpdate.metadataChanged:
        break;
      case HMSPeerUpdate.nameChanged:
        break;
      case HMSPeerUpdate.defaultUpdate:
        // TODO: Handle this case.
        break;
      case HMSPeerUpdate.handRaiseUpdated:
      // TODO: Handle this case.
    }
  }

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    switch (peer.role.name) {
      case 'speaker':
        int index =
            speaker.indexWhere((node) => node.uid == '${peer.peerId}speaker');
        if (index != -1) {
          speaker[index].audioTrack = track;
        } else {
          speaker.add(PeerTrackNode(
              uid: '${peer.peerId}speaker', peer: peer, audioTrack: track));
        }
        if (peer.isLocal) {
          isMicrophoneMuted.value = track.isMute;
        }
        speaker.refresh();
        break;
      case 'listener':
        int index =
            listener.indexWhere((node) => node.uid == '${peer.peerId}listener');
        if (index != -1) {
          listener[index].audioTrack = track;
        } else {
          listener.add(PeerTrackNode(
              uid: '${peer.peerId}listener', peer: peer, audioTrack: track));
        }
        listener.refresh();
        break;
      default:
        //Handle the case if you have other roles in the room
        break;
    }
  }

  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {
    // TODO: implement onAudioDeviceChanged
  }

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {
    // TODO: implement onChangeTrackStateRequest
  }

  @override
  void onHMSError({required HMSException error}) {
    Get.snackbar("Error", error.message ?? "");
  }

  @override
  void onMessage({required HMSMessage message}) {
    // TODO: implement onMessage
  }

  // menangani kondisi peer saat mengalami permasalahan jaringan
  @override
  void onReconnecting() {
    isReconnecting.value = true;
    Get.snackbar("Menghubungkan",
        "Terjadi kesalahan jaringan, mencoba menghubungkan kembali...",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2));
  }

  // fungsi saat peer kembali terhubung dengan jaringan dan room
  @override
  void onReconnected() {
    isReconnecting.value = false;
    Get.snackbar("Terhubung", "Kamu kembali online!",
        snackPosition: SnackPosition.BOTTOM);
  }

  // menangani kondisi dimana ada peer yang dikeluarkan dari room, khususnya terjadi saat speaker/ustadz memanggil fungsi endroom
  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {
    if (hmsPeerRemovedFromPeer.roomWasEnded) {
      isRoomEnded.value = true;
      endRoomReason.value = hmsPeerRemovedFromPeer.reason;

      Get.delete<PlayerControllerTesting>();

      Get.snackbar(
        "Room Ended",
        "Room was ended by ${hmsPeerRemovedFromPeer.peerWhoRemoved?.name ?? 'Unknown'}",
        snackPosition: SnackPosition.TOP,
      );

      // Tambahkan delay sebelum berpindah halaman
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offAllNamed('/waitingScreen');
      });
    }
  }

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    // TODO: implement onRoleChangeRequest
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    // TODO: implement onRoomUpdate
  }

  @override
  void onSessionStoreAvailable({HMSSessionStore? hmsSessionStore}) {
    _hmsSessionStore = hmsSessionStore;

    print("HMS Session Store tersedia!");

    // Setelah tersedia, langsung tambahkan listener
    addPageChangeListener();
  }

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    // TODO: implement onUpdateSpeakers
  }

  @override
  void onPeerListUpdate(
      {required List<HMSPeer> addedPeers,
      required List<HMSPeer> removedPeers}) {
    // TODO: implement onPeerListUpdate
  }

  @override
  void onException(
      {HMSActionResultListenerMethod? methodType,
      Map<String, dynamic>? arguments,
      required HMSException hmsException}) {
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        Get.snackbar("Leave Error", hmsException.message ?? "");
        break;
      case HMSActionResultListenerMethod.startScreenShare:
        Get.snackbar("startScreenShare Error", hmsException.message ?? "");

        break;
      case HMSActionResultListenerMethod.stopScreenShare:
        Get.snackbar("stopScreenShare Error", hmsException.message ?? "");

        break;
      case HMSActionResultListenerMethod.changeTrackState:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.changeMetadata:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.endRoom:
        Get.snackbar("EndRoom Error", hmsException.message ?? "");
        break;
      case HMSActionResultListenerMethod.removePeer:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.acceptChangeRole:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.changeRoleOfPeer:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.changeTrackStateForRole:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.startRtmpOrRecording:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.stopRtmpAndRecording:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.changeName:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.sendBroadcastMessage:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.sendGroupMessage:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.sendDirectMessage:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.hlsStreamingStarted:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.hlsStreamingStopped:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.startAudioShare:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.stopAudioShare:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.switchCamera:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.changeRoleOfPeersWithRoles:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.setSessionMetadataForKey:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.sendHLSTimedMetadata:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.lowerLocalPeerHand:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.lowerRemotePeerHand:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.raiseLocalPeerHand:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.quickStartPoll:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.addSingleChoicePollResponse:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.addMultiChoicePollResponse:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.unknown:
        // TODO: Handle this case.
        break;
      case null:
        // TODO: Handle this case.
        break;
    }
    Get.snackbar("Error", hmsException.message ?? "");
  }

  @override
  void onSuccess(
      {required HMSActionResultListenerMethod methodType,
      Map<String, dynamic>? arguments}) {
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        _hmsSDK.removeUpdateListener(listener: this);
        _hmsSDK.destroy();
        break;
      case HMSActionResultListenerMethod.endRoom:
        //Room Ended successfully
        break;
      default:
        break;
    }
  }
}
