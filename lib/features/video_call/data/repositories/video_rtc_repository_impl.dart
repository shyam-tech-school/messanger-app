import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mail_messanger/features/video_call/data/datasources/video_webrtc_datasource.dart';
import 'package:mail_messanger/features/video_call/domain/repositories/i_video_rtc_repository.dart';

class VideoRtcRepositoryImpl implements IVideoRtcRepository {
  VideoRtcRepositoryImpl(this._datasource);

  final VideoWebrtcDatasource _datasource;

  @override
  RTCVideoRenderer get localRenderer => _datasource.localRenderer;

  @override
  RTCVideoRenderer get remoteRenderer => _datasource.remoteRenderer;

  @override
  Future<void> initRenderers() => _datasource.initRenderers();

  @override
  Future<void> ensurePermissions() => _datasource.ensurePermissions();

  @override
  Future<Map<String, dynamic>> createOffer() => _datasource.createOffer();

  @override
  Future<Map<String, dynamic>> createAnswer() => _datasource.createAnswer();

  @override
  Future<void> setRemoteDescription(Map<String, dynamic> sdp) =>
      _datasource.setRemoteDescription(sdp);

  @override
  Future<void> addIceCandidate(Map<String, dynamic> candidate) =>
      _datasource.addIceCandidate(candidate);

  @override
  void setOnIceCandidate(void Function(Map<String, dynamic>) onCandidate) =>
      _datasource.setOnIceCandidate(onCandidate);

  @override
  void toggleMute(bool isMuted) => _datasource.toggleMute(isMuted);

  @override
  void toggleVideo(bool isOff) => _datasource.toggleVideo(isOff);

  @override
  Future<void> switchCamera() => _datasource.switchCamera();

  @override
  Stream<String> get connectionStateStream => _datasource.connectionStateStream;

  @override
  Future<void> dispose() => _datasource.dispose();
}
