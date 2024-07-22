import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radio_braulio/models/radio_station.dart';
import 'package:radio_braulio/widgets/loading.dart';
import 'package:radio_braulio/widgets/player_button.dart';
import 'package:volume_controller/volume_controller.dart';

class Player extends StatefulWidget {
  final RadioStation radioStation;
  final Function previous;
  final Function next;

  const Player(this.radioStation, this.previous, this.next, {super.key});

  @override
  State<StatefulWidget> createState() => _PlayerState();
}

enum PlayerState { loading, playing, paused, error }

class _PlayerState extends State<Player> with SingleTickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();
  PlayerState state = PlayerState.loading;
  late RadioStation currentStation;
  double _volumeBeforeMute = 0;
  double _volumeValue = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInCubic,
      ),
    );
    _controller.repeat(reverse: true);
    VolumeController().listener((volume) {
      setState(() => _volumeValue = volume);
    });
    currentStation = widget.radioStation;
    _init();
  }

  Future<void> _init() async {
    try {
      await _player.setUrl(widget.radioStation.url);
      _player.play();
      setState(() => state = PlayerState.playing);
    } catch (e) {
      if (e.toString() == '(0) Source error') {
        setState(() => state = PlayerState.error);
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget get getStateText {
    switch (state) {
      case PlayerState.loading:
        return const Text(
          'Loading...',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15,
            color: Colors.yellow,
            letterSpacing: 0.5,
          ),
        );
      case PlayerState.playing:
        return const Text(
          'Playing',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15,
            color: Colors.green,
            letterSpacing: 0.5,
          ),
        );
      case PlayerState.paused:
        return const Text(
          'Paused',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        );
      default:
        return const Text(
          'Not available',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15,
            color: Colors.red,
            letterSpacing: 0.5,
          ),
        );
    }
  }

  void pause() {
    _player.pause();
    setState(() => state = PlayerState.paused);
  }

  void play() {
    _player.play();
    setState(() => state = PlayerState.playing);
  }

  void previousStation() async {
    try {
      setState(() => state = PlayerState.loading);
      currentStation = widget.previous(currentStation);
      await _player.stop();
      await _player.setUrl(currentStation.url);
      _player.play();
      setState(() => state = PlayerState.playing);
    } catch (e) {
      if (e.toString() == '(0) Source error') {
        setState(() => state = PlayerState.error);
      }
    }
  }

  void nextStation() async {
    try {
      setState(() => state = PlayerState.loading);
      currentStation = widget.next(currentStation);
      await _player.stop();
      await _player.setUrl(currentStation.url);
      _player.play();
      setState(() => state = PlayerState.playing);
    } catch (e) {
      if (e.toString() == '(0) Source error') {
        setState(() => state = PlayerState.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black87,
              Colors.black,
              Colors.black54,
            ],
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.height * 0.05,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.cancel,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
              ScaleTransition(
                scale: _animation,
                child: SizedBox(
                  height: MediaQuery.of(context).size.width * 0.6,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: currentStation.getImageWidget(),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                currentStation.name,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.ubuntu(
                  letterSpacing: 1,
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(
                height: 1,
                thickness: 0.5,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              getStateText,
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PlayerButton(Icons.skip_previous_outlined, previousStation),
                  PlayerButton(
                    state == PlayerState.playing
                        ? Icons.pause
                        : Icons.play_arrow_outlined,
                    () {
                      if (state == PlayerState.playing) {
                        pause();
                      } else if (state == PlayerState.paused) {
                        play();
                      }
                    },
                  ),
                  PlayerButton(Icons.skip_next_outlined, nextStation),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  PlayerButton(
                    Icons.volume_off,
                    () {
                      if (_volumeValue == 0 && _volumeBeforeMute != 0) {
                        _volumeValue = _volumeBeforeMute;
                        _volumeBeforeMute = 0;
                        VolumeController().setVolume(_volumeValue);
                      } else {
                        _volumeBeforeMute = _volumeValue;
                        VolumeController().muteVolume();
                      }
                      setState(() {});
                    },
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Slider(
                      min: 0,
                      max: 1,
                      thumbColor: Colors.white,
                      activeColor: Colors.white,
                      inactiveColor: Colors.white,
                      onChanged: (double value) {
                        _volumeValue = value;
                        VolumeController().setVolume(_volumeValue);
                        setState(() {});
                      },
                      value: _volumeValue,
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
}
