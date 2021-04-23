import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_work_app/constants/anketa_model.dart';
import 'package:test_work_app/constants/custom_widgets.dart';
import 'package:test_work_app/pages/anketa_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPage extends StatefulWidget {
  final AnketaModel? anketaModel;

  const VideoPage({Key? key, this.anketaModel}) : super(key: key);
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  YoutubePlayerController? controller;
  bool show=true;
  String videoId="DOzmVibauww";

  initState(){
    super.initState();
    print(widget.anketaModel);
    _checkAnketa();
    controller=YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  _checkAnketa(){
    Duration a=DateTime.now().difference(widget.anketaModel!.age!);
    int age=int.parse("${(a.inDays/365).toStringAsFixed(0)}");
    print(age);
    if(age<18){
      show=false;
    }
    else{
      AnketaModel model=widget.anketaModel!;
      if(!model.male) {
        if (age <= 24 && model.baby >= 1) {
          videoId = "LBdX-oRF5zY";
        }
        if (age >= 25 && age <= 34) {
          videoId = "G393z8s8nFY";
        }
        if (age >= 35 && age <=44){
          videoId="gmRKv7n2If8";
        }
        if(age>=45 && age<=55){
          videoId="w0xx477aeys";
        }
        if(age>55 && model.baby>1){
          videoId="jJ5aL3NqJKc";
        }
      }
      else{
        if (age <= 24 && model.baby >= 1) {
          videoId = "Sc59y_fStEs";
        }
        if (age >= 25 && age <= 34) {
          videoId = "-FZ-pPFAjYY";
        }
        if (age >= 35 && age <=44){
          videoId="zonzGtxZSnM";
        }
        if(age>=45 && age<=55){
          videoId="4MvhP2zKozI";
        }
        if(age>55 && model.baby>2){
          videoId="wdgUCrHa3oo";
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Анкета"),
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left:10),
            child: SvgPicture.asset("assets/back_button.svg"),
          ),
        ),
        ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(show ? infoText : "Извините, вы не подходите по возрасту"),
              ),SizedBox(height: 10,),
              if(show)
              YoutubePlayerWidget(controller: controller),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 80, left:25, right: 25),
            child: ButtonWidget(
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(c)=> AnketaPage()), (route) => false);
              },
              text: "Готово",
            ),
          )
        ],
      ),
    );
  }
}
class YoutubePlayerWidget extends StatelessWidget {
  final YoutubePlayerController? controller;

  const YoutubePlayerWidget({Key? key,required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:15),
      child: YoutubePlayer(
        controller: controller!,
        showVideoProgressIndicator: true,
      ),
    );
  }
}

String get infoText=>"Благодарим за заполнение анкеты. Пожалуйста, посмотрите трейлер";