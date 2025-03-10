import 'package:flutter/material.dart';
import 'package:music_player/components/neu_box.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  const SongPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {

        //get playlist
        final playlist = value.playlist;



        //get current song index

        final currentSong = playlist[value.currentSongIndex ?? 0];

        //return scaffold
        return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 25.00, right: 25.00, bottom: 25.00),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // AppBar Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context); // This will navigate back to the previous screen
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),

                    // Title
                   const Text("P L A Y L I S T"),

                    // Menu button
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.menu),
                    ),
                  ],
                ),
                // Album artwork
                NeuBox(
                  child: Column(
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.00),
                        child: Image.asset(currentSong.albumArtImagePath),
                      ),

                      // Song and artist name
                       Padding(
                        padding: const EdgeInsets.all(15.00),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Song and artist name
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentSong. songName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 20.00),
                                ),
                                Text(currentSong.artistName),
                              ],
                            ),

                            // Heart icon
                            const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25.00,),

                // Song duration progress
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.00),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Start time
                          Text("0:00"),

                          // Shuffle icon
                          Icon(Icons.shuffle),

                          // Repeat icon
                          Icon(Icons.repeat),

                          // End time
                          Text("0:00"),
                        ],
                      ),
                    ),

                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6), // Make thumb visible
                      ),
                      child: Slider(
                        min: 0,
                        max: value.totalDuration.inMinutes.toDouble(),
                        value: value.currentDuration.inMinutes.toDouble(),
                        activeColor: Colors.green,
                        onChanged: (double double) {
                          //during when the usr is dragging sliding around 
                        },
                        onChangeEnd: (double double){
                          //sliding has finished , to go to the position in the song duration
                          value.seek(Duration(minutes: double.toInt()));
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20.00,),
                // Playback controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
                  children: [
                    // Skip previous
                    GestureDetector(
                      onTap: value.playPreviousSong,
                      child: const NeuBox(
                        child: Icon(Icons.skip_previous),
                      ),
                    ),

                    const SizedBox(width: 20.00,), // Add space between buttons

                    // Play/pause
                    GestureDetector(
                      onTap: value.pauseOrResume,
                      child: NeuBox(
                        child: Icon(value.isPlaying ? Icons.pause: Icons.play_arrow),
                      ),
                    ),

                    const SizedBox(width: 20.00,), // Add space between buttons

                    // Skip next
                    GestureDetector(
                      onTap: value.playNextSong,
                      child: const NeuBox(
                        child: Icon(Icons.skip_next),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      }
    );
  }
}
