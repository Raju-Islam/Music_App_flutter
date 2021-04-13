
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayer extends StatefulWidget {
  SongInfo songInfo;
  Function changeTracks;
  final GlobalKey<MusicPlayerState>key;
  MusicPlayer({this.songInfo,this.changeTracks,this.key}):super(key: key);
  @override
  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {
   double minmumValue=0.0,maximumValue=0.0,currentValue=0.0;
  String currentTime="",endTime="";
  final AudioPlayer player=AudioPlayer();
  bool isPlaying=false;
  //
  @override
  void initState() { 
    super.initState();
    setSong(widget.songInfo);

  }
  void dispose(){
    super.dispose();
    player?.dispose();
  }

  
  
  //
  setSong(SongInfo songInfo)async{
  widget.songInfo=songInfo;
  await player.setUrl(widget.songInfo.uri);
  currentValue=minmumValue;
  maximumValue=player.duration.inMilliseconds.toDouble();
  setState(() {
    currentTime=getDuration(currentValue);
    endTime=getDuration(maximumValue);
    isPlaying=false;
    changeStatus();
    player.positionStream.listen((duration) { 
      currentValue=duration.inMilliseconds.toDouble();
       setState(() {
          currentTime=getDuration(currentValue);
       });
    });
  });
  }
  //
  void changeStatus(){
    setState(() {
      isPlaying=!isPlaying;
    });
    if(isPlaying){
      player.play();
    }else{
      player.pause();
    }
  }

  //
  //convert min,second
  String getDuration(double value){
    Duration duration=Duration(milliseconds:value.round(),);
    return[duration.inMinutes,duration.inSeconds].map((element) => element.remainder(60).toString().padLeft(2,"0")).join(":");

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Playing",
          style: new TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
      
          margin: EdgeInsets.fromLTRB(5, 40, 5, 0),
          child: Column(
            children: [
              new CircleAvatar(
                backgroundImage: widget.songInfo.albumArtwork == null
                    ? AssetImage("assets/splash.png")
                    : FileImage(File(widget.songInfo.albumArtwork),),
                    radius: 95,
              ),
              Container(margin: EdgeInsets.fromLTRB(0,20, 0, 7),child: Text(widget.songInfo.title,style: new TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),),
              Container(margin: EdgeInsets.fromLTRB(0,10, 0, 5),child:Text(widget.songInfo.artist,style:new TextStyle(color:Colors.green),),),
              SizedBox(height:10),
              Slider(inactiveColor: Colors.black12,activeColor: Colors.black,min: minmumValue,max: maximumValue,value: currentValue,onChanged: (value){
                currentValue=value;
                player.seek(Duration(milliseconds: currentValue.round(),),);
              },),
              Container(transform: Matrix4.translationValues(0, -5, 0),margin: EdgeInsets.fromLTRB(5, 0, 5, 15),child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Text(currentTime,style: new TextStyle(fontSize:12.5,fontWeight:FontWeight.w500,),),
              Text(endTime,style: new TextStyle(fontSize:12.5,fontWeight:FontWeight.w500,),),
              ],),),
              Container(margin: EdgeInsets.fromLTRB(0, 0, 0, 0),child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                GestureDetector(child:Icon(Icons.skip_previous,color:Colors.black,size: 55,),behavior: HitTestBehavior.translucent,onTap: (){
                  widget.changeTracks(false);
                },
                ),
                GestureDetector(child:Icon(isPlaying?Icons.pause_circle_filled_rounded:Icons.play_circle_fill_rounded,color:Colors.black,size: 75,),behavior: HitTestBehavior.translucent,onTap: (){
                changeStatus();
                },),
                GestureDetector(child:Icon(Icons.skip_next,color:Colors.black,size: 55,),behavior: HitTestBehavior.translucent,onTap: (){
                  widget.changeTracks(true);
                },
                )
              ],),)
            ],
          ),
          ),
          
    );
  }
}
