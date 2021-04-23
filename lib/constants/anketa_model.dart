import 'package:intl/intl.dart';

class AnketaModel{
  String? name;
  DateTime? age;
  bool male=true;
  int baby=0;
  AnketaModel({this.name,this.age,this.male:true,this.baby:0});
  @override
  String toString(){
    
    return getMap().toString();
  }
  Map<String, dynamic> getMap(){
    final f=DateFormat("dd.MM.yyyy");
    Map<String, dynamic> a={};
    a['name']=name;
    a['age']=f.format(age!);
    a['male']=male;
    a['baby']=baby;
    return a;
  }
}