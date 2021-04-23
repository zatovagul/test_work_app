import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:test_work_app/constants/anketa_model.dart';
import 'package:test_work_app/constants/app_colors.dart';
import 'package:test_work_app/constants/custom_widgets.dart';
import 'package:test_work_app/pages/video_page.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';

class AnketaPage extends StatefulWidget {
  @override
  _AnketaPageState createState() => _AnketaPageState();
}

class _AnketaPageState extends State<AnketaPage> {
  bool male = true;
  TextEditingController? nameController, dateController, babyController;
  bool nameNormal=true, dateNormal=true, babyNormal=true;
  DateTime? age;
  BuildContext? scafContext;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    dateController = TextEditingController();
    babyController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Анкета"),
        centerTitle: true,
      ),
      body:Builder(builder: (context){
        scafContext=context;
          return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: _getBody);
      }),
    );
  }

  Widget get _getBody {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: 50,
              ),
              CustomInput(
                type: 0,
                controller: nameController,
                normal: nameNormal,
                onChanged: (s){
                  setState(() {
                    nameNormal=true;
                  });
                },
              ),
              SizedBox(
                height: 24,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  _showDate();
                },
                child: CustomInput(
                  type: 1,
                  controller: dateController,
                  normal: dateNormal,
                  onChanged: (s){
                    setState(() {
                      dateNormal=true;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Expanded(
                      child: GenderItem(
                    text: "Муж",
                    checked: male,
                    onPressed: () {
                      _setGender(true);
                    },
                  )),
                  Expanded(
                      child: GenderItem(
                    text: "Жен",
                    checked: !male,
                    onPressed: () {
                      _setGender(false);
                    },
                  )),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              CustomInput(
                type: 2,
                controller: babyController,
                normal: babyNormal,
                onChanged: (s){
                  setState(() {
                    babyNormal=true;
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 80),
            child: ButtonWidget(
              onPressed: () {
                _send();
              },
              text: "Отправить",
            ),
          )
        ],
      ),
    );
  }
  _showDate() async{
    var datePicked = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2021, 12,31),
      dateFormat: "dd-MMMM-yyyy",
      locale: DateTimePickerLocale.en_us,
      looping: true,
      confirmText: "Done",
      cancelText: "Cancel",
      textColor: Colors.black,
    );
    if(datePicked!=null){
      final f=DateFormat("dd.MM.yyyy");
      dateController!.text=f.format(datePicked);
      age=datePicked;
      setState(() {
        dateNormal=true;
      });
    }
  }

  _setGender(bool male) {
    setState(() {
      this.male = male;
    });
  }

  _send(){
    setState(() {
      if(nameController!.text.length==0){
        nameNormal=false;
      }
      if(dateController!.text.length==0){
        dateNormal=false;
      }
      if(babyController!.text.length==0){
        babyNormal=false;
      }
    });
    if(nameNormal && dateNormal && babyNormal){
      _sendRequest();
    }
  }

  _sendRequest() async{
    context.showLoaderOverlay();
    try {
      AnketaModel anketaModel = AnketaModel(name: nameController!.text,
          age: age,
          male: male,
          baby: int.parse(babyController!.text));
      var url = "https://ptsv2.com/t/o88e8-1619180476/post";
      var response = await http.post(
          Uri.parse(url), body: anketaModel.toString());
      if (response.statusCode == 200)
        Navigator.push(context, MaterialPageRoute(builder: (c) {
          return VideoPage(anketaModel: anketaModel,);
        }),);
      else {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text("Connection problems")));
      }
    }
    catch(e){
      Scaffold.of(scafContext!).showSnackBar(
          SnackBar(content: Text("Connection problems")));
    }
    context.hideLoaderOverlay();
  }
}

class CustomInput extends StatefulWidget {
  final int type;
  final bool normal;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const CustomInput(
      {Key? key, this.type: 1, this.normal: true, this.controller, this.onChanged})
      : super(key: key);
  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  @override
  Widget build(BuildContext context) {
    int type = widget.type;
    String asset = type == 0
        ? "user.svg"
        : type == 1
            ? "calendar.svg"
            : "baby.svg";
    String hint = type == 0
        ? "Введите ваше имя"
        : type == 1
            ? "Дата рождения"
            : "Количество детей";
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black, width: 2),
            color: widget.normal?null:AppColors.red,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 16,
            ),
            SvgPicture.asset(
              "assets/$asset",
              width: 24,
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child:type==0||type==2 ? TextField(
                onChanged: widget.onChanged,
                controller: widget.controller,
                focusNode: type == 1 ? AlwaysDisabledFocusNode() : null,
                keyboardType: type == 2 ? TextInputType.number : null,
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: hint),
              ) : Text(widget.controller!.text.length>0 ? widget.controller!.text : hint),
            )
          ],
        ),
      ),
    );
  }
}

class GenderItem extends StatelessWidget {
  final String text;
  final bool checked;
  final VoidCallback? onPressed;

  const GenderItem(
      {Key? key, this.text: '', this.checked: false, this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: _decoration.copyWith(
                color: !checked ? AppColors.lightGrey : null),
            child: Center(
              child: Container(
                height: 16,
                width: 16,
                decoration: checked
                    ? _decoration.copyWith(color: AppColors.yellow)
                    : null,
              ),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Text(text)
        ],
      ),
    );
  }

  BoxDecoration get _decoration => BoxDecoration(
      borderRadius: BorderRadius.circular(180),
      border: Border.all(width: 2, color: Colors.black));
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
