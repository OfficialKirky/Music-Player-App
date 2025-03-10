import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  // Playlist of songs
  final List<Song> _playlist = [
    Song(
      songName: "Liyue",
      artistName: "Yu-peng Chen",
      albumArtImagePath: "assets/images/liyue.png",
      audioPath: "audio/Liyue.mp3", // Removed "assets/"
    ),
    Song(
      songName: "You Belong With Me",
      artistName: "Taylor Swift",
      albumArtImagePath: "assets/images/fearless.png",
      audioPath: "audio/YBWM.mp3",
    ),
    Song(
      songName: "Ruu's Melody",
      artistName: "Yu-peng Chen",
      albumArtImagePath: "assets/images/ruu.png",
      audioPath: "audio/ruu.mp3",
    ),
  ];

  // Current song index
  int? _currentSongIndex;

  // Audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Initially not playing
  bool _isPlaying = false;

  // Constructor
  PlaylistProvider() {
    listenToDuration();
  }

  // Play the song
  void play() async {
    if (_currentSongIndex == null) return;

    final String path = _playlist[_currentSongIndex!].audioPath;

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(path));
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  // Pause the song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // Resume the song
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // Pause or resume
  void pauseOrResume() async {
    _isPlaying ? pause() : resume();
    notifyListeners();
  }

  // Seek to specific position
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // Play next song
  void playNextSong() {
    if (_currentSongIndex == null) return;

    currentSongIndex = (_currentSongIndex! < _playlist.length - 1)
        ? _currentSongIndex! + 1
        : 0; // Loop back to first song
  }

  // Play previous song
  void playPreviousSong() {
    if (_currentSongIndex == null) return;

    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero); // Restart the current song
    } else {
      currentSongIndex = (_currentSongIndex! > 0)
          ? _currentSongIndex! - 1
          : _playlist.length - 1; // Loop back to last song
    }
  }

  // Listen to duration changes
  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      playNextSong();
    });
  }

  // Dispose audio player properly
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /*
    G E T T E R S
  */
  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  /*
    S E T T E R S 
  */
  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if (newIndex != null) play();
    notifyListeners();
  }
}
