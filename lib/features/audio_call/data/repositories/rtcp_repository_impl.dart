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
  Future<void> dispose() => webrtcRemoteDs.dispose();
}
