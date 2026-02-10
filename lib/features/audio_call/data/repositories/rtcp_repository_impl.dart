import 'package:mail_messanger/features/audio_call/data/datasources/webrtc_remote_datasource.dart';
import 'package:mail_messanger/features/audio_call/domain/repositories/i_rtc_repository.dart';

class RtcpRepositoryImpl implements IRTCPRepository {
  final WebrtcRemoteDatasource webrtcRemoteDs;

  RtcpRepositoryImpl(this.webrtcRemoteDs);

  @override
  Future<void> ensureMicPermission() => webrtcRemoteDs.ensureMicPermission();

  @override
  Future<Map<String, dynamic>> createOffer() => webrtcRemoteDs.createOffer();

  @override
  Future<Map<String, dynamic>> createAnswer() => webrtcRemoteDs.createAnswer();

  @override
  Future<void> setRemoteDescription(Map<String, dynamic> sdp) =>
      webrtcRemoteDs.setRemoteDescription(sdp);

  @override
  Future<void> addIceCandidate(Map<String, dynamic> candidate) =>
      webrtcRemoteDs.addIceCandidate(candidate);

  @override
  void setOnIceCandidate(void Function(Map<String, dynamic>) onCandidate) =>
      webrtcRemoteDs.setOnIceCandidate(onCandidate);

  @override
  Stream<String> get connectionStateStream =>
      webrtcRemoteDs.connectionStateStream;

  @override
  Future<void> toggleMute(bool isMuted) async =>
      webrtcRemoteDs.toggleMute(isMuted);

  @override
  Future<void> toggleSpeaker(bool isSpeakerOn) =>
      webrtcRemoteDs.toggleSpeaker(isSpeakerOn);

  @override
  Future<void> dispose() => webrtcRemoteDs.dispose();
}
