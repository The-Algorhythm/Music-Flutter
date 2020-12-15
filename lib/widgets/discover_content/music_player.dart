import 'package:audioplayer/audioplayer.dart';
import 'dart:async';

enum PlayerState { stopped, playing, paused }

class MusicPlayer {

  Duration duration;
  Duration position;

  AudioPlayer audioPlayer;

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  String currentUrl;
  final Function audioPositionChangedCallback;

  MusicPlayer(this.currentUrl, this.audioPositionChangedCallback);

  get isPlaying => playerState == PlayerState.playing;

  get isPaused => playerState == PlayerState.paused;
  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) async {
          audioPositionChangedCallback(p);
          Duration timeLeft  = duration - p;
          if(timeLeft.inMilliseconds.abs() <= 100) {
            await stop();
            initAudioPlayer();
          }
        });
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
          if (s == AudioPlayerState.PLAYING) {
            duration = audioPlayer.duration;
          } else if (s == AudioPlayerState.STOPPED) {
            if(playerState != PlayerState.stopped) {
              initAudioPlayer();
            } else {
              print("stopped");
              audioPositionChangedCallback(position);
            }
          }
        }, onError: (msg) {
          audioPositionChangedCallback(Duration(seconds: 0));
        });
    play(currentUrl);
  }

  Future play(url) async {
    print("playing audio");
    currentUrl = url;
    await audioPlayer.play(url);
    playerState = PlayerState.playing;
  }

  Future stop() async {
    await audioPlayer.stop();
    playerState = PlayerState.stopped;
    audioPositionChangedCallback(Duration());
  }

  Future pause() async {
    await audioPlayer.pause();
    playerState = PlayerState.paused;
    audioPositionChangedCallback(position);
  }

  Future dispose() async {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
  }
}