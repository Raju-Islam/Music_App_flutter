import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

import 'music_player.dart';

class Tracks extends StatefulWidget {
  @override
  _TracksState createState() => _TracksState();
}

class _TracksState extends State<Tracks> {
  
  FlutterAudioQuery _audioQuery = FlutterAudioQuery();
  List<SongInfo> songs = [];
  var currentindex = 0;
  final GlobalKey<MusicPlayerState>key=GlobalKey<MusicPlayerState>();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTracks();
  }

  //
  void getTracks() async {
    songs = await _audioQuery.getSongs();
    setState(() {
      songs = songs;
    });
  }
void changeTracks(bool isNext){
if(isNext){
  if(currentindex!=songs.length-1){
    currentindex++;
  }else{
    if(currentindex!=0){
      currentindex--;
    }
 
  }
  
}
key.currentState.setSong(songs[currentindex]);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        leading: Icon(
          Icons.music_note,
          color: Colors.black,
        ),
        title: Center(
          child: Text(
            "Music App",
            style: new TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: songs.length,
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
            backgroundImage: songs[index].albumArtwork == null
                ? AssetImage("assets/splash.png")
                : FileImage(
                    File(songs[index].albumArtwork),
                  ),
          ),
          title: Text(songs[index].title),
          subtitle: Text(songs[index].artist),
          onTap: () {
            currentindex = index;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MusicPlayer(changeTracks: changeTracks,
                  songInfo: songs[currentindex],key: key,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
