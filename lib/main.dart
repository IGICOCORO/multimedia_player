import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: ThemeData(
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

}
class _HomePageState extends State<HomePage> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currenttime = "00:00:00";
  String completetime = "00:00:00";
  @override
  void initState() {
    super.initState();
    _audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        currenttime = duration.toString().split(".")[0];
      });
    });
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        completetime = duration.toString().split(".")[0];
      });
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Image.asset("images/microphone.jpg",fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,),
          Container(
            width: MediaQuery.of(context).size.width*0.8,
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.7, left: MediaQuery.of(context).size.width*0.1),
            height: 80,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: (){
                    if(isPlaying){
                      _audioPlayer.pause();
                      setState(() {
                        isPlaying = false;
                      });
                    }else{
                      _audioPlayer.resume();
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                ),
                SizedBox(width: 16,),
                IconButton(
                    icon: Icon(Icons.stop),
                    onPressed: (){
                      _audioPlayer.stop();
                      setState(() {
                        isPlaying = false;
                      });
                      if(currenttime!=null){
                        return currenttime="0:00:00";
                      }
                    }),
                Text(currenttime, style: TextStyle(fontWeight: FontWeight.w700),),
                Text(" | "),
                Text(completetime, style: TextStyle(fontWeight: FontWeight.w300),)
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.audiotrack,color: Colors.lime,),
        onPressed: () async{
          String filePath = await FilePicker.getFilePath();
          _audioPlayer.play(filePath, isLocal: true);
          int status = await _audioPlayer.play(filePath, isLocal: true);
          if(status==1){
            setState(() {
              isPlaying = true;
            });
          }
        },
      ),
    );
  }
}