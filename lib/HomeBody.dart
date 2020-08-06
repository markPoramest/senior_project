import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login_button/twiiter.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter/services.dart';
import 'package:term_project/HomePage.dart';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'model/bully.dart';
import 'dart:math';

class HomeBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomeBody> {
  static final TwitterLogin twitterLogin = TwitterLogin(
    consumerKey: 'V6WhIk4MThLDHOZffp5ePjhxb',
    consumerSecret: '0mBgQEhDmlCJYFiEuzv49bwauCKzvBHh7yg2ph5QksMNxHTaOQ',
  );
  String _title = "";
  void _login() async {
    final TwitterLoginResult result = await twitterLogin.authorize();
    String Message;
    int error=0;
    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        Message = 'คุณ ${result.session.username}';
        break;
      case TwitterLoginStatus.cancelledByUser:
        Message = 'Login cancelled by user.';
        error=1;
        break;
      case TwitterLoginStatus.error:
        Message = 'Login error: ${result.errorMessage}';
        error=2;
        break;
    }

    setState(() {
      if(error==0)
          _title = Message;
      print('tile :::::' + _title);
    });
  }

  void _logout() async {
    await twitterLogin.logOut();

    setState(() {
      _title = "";
    });
  }

  final MethodChannel _channel = const MethodChannel('flutter_share_me');

  Future<String> shareToTwitter({String msg = '', String url = ''}) async {
    final Map<String, Object> arguments = Map<String, dynamic>();
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('url', () => url);
    dynamic result;
    try {
      result = await _channel.invokeMethod('shareTwitter', arguments);
    } catch (e) {
      return "false";
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return _title.length==0 ? loginUI() : mainUI();

  }
  // -----------------------------หน้าlogin
  Widget loginUI() {
    return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top:100 ),
            child: Image.asset('assets/images/logo-sandy.png', height: 150,),
          ),
          Container(
            padding: EdgeInsets.only(left: 10 , right: 10,bottom: 30),
            child: Text(
              "Sandy คือแอพพลิเคชันสำหรับตรวจสอบคำ Bully ภาษาไทยก่อนข้อความนั้นจะถูกโพสลงบน Twitter",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),

          ),
          Expanded(child: Container()),
          Container(
            child: Column(
              children: <Widget>[
                  Container(
                    child: TwitterSignInButton(
                      onPressed: _login,
                    ),
                  ),
                Container(
                    padding: EdgeInsets.only(bottom: 30,top: 15,right: 20 , left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                       Container(
                             child : Icon(
                               Icons.info,
                               color: Colors.white,

                             ),
                      ),

                        Expanded(child: Container(
                          child: Text("ผู้ใช้งานจะต้องมีบัญชี Twitter ก่อน ถึงจะสามารถใช้งานได้"
                            ,textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),),
                        ),)
                      ],
    )

                )]),
                    )
                ]);

  }


 // -----------------------------หน้าต้อนรับ
  final TextEditingController _bullywordController = TextEditingController();
  Color color1 = HexColor("f3dec7");
  Color color2 = HexColor("a8948c");
  Color color3 = HexColor("adc965");
  Color color4 = HexColor("d74e37");
  String name, username, avatar;
  bool isData = false;

  Widget mainUI() {
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top:30),
              child: Image.asset('assets/images/logo-sandy.png', height: 200,),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 5,top: 10, ),
              child : Text('ยินดีต้อนรับ'+_title, style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white
              ), textAlign: TextAlign.center,),
            ),

            Container(
              padding: EdgeInsets.only(top: 20, bottom: 20, right: 15 , left: 15),
              width: 320,
              child: TextField(
                controller: _bullywordController,
//                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: color1,
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: color1)),
                    labelText: 'กรอกประโยคที่ต้องการ Tweet',
                    hintText: 'tweet...',
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: color2
                      )
                  ),


                ),

              ),
            ),
            ButtonTheme(
              minWidth: 300.0,
              child: RaisedButton(

                onPressed: () async {
                  var Response = await http.get(
                    "http://sai.cp.su.ac.th:8002/input/"+_bullywordController.text,
                    headers: {"Accept": "application/json"},
                  );
                if (Response.statusCode == 200) {
                  String responseBody = Response.body;
                  var responseJSON = json.decode(responseBody);
                  Bully bully = Bully.fromJson(responseJSON);
                  var bully_class = [bully.result0,bully.result1,bully.result2,bully.result3,bully.result4,bully.result5];
                  if(bully_class.reduce((max))==bully.result0)
                    {
                     showAlertDialog(context, 'ไม่เป็นคำ Bully กด OK เพื่อ Tweet', 0);
                    }
                  else{
                    List a1 = new List();
                    int index = indexOfMax(bully_class);
                    for(int i=1;i<bully_class.length;i++){
                      if(bully_class[index]*(90/100) <= bully_class[i]){
                       if(i==1){
                         a1.add('แบ่งแยก กีดกัน (Exclusion)');
                       }
                       else if(i==2){
                         a1.add('ข่มขู่ คุกคาม (Harassment)');
                       }
                       else if(i==3){
                         a1.add('การแฉ เปิดโปงให้อับอาย (Revealing)');
                       }
                       else if(i==4){
                         a1.add('ดูถูก เหยียดหยาม ลดทอนศักดิ์ศรี (Dissing)');
                       }
                       else if(i==5){
                         a1.add('ก่อกวน (Trolling)');
                       }
                      }
                    }
                    String msg ='เป็นคำ Bully ประเภท ';
                    for(int i=0;i<a1.length;i++)
                      {
                        if(i!=0){
                          msg += 'หรือ ';
                        }
                         msg += a1[i];
                      }
                    showAlertDialog(context,msg+' กรุณาใช้คำอื่นหลีกเลี่ยง', 1);
                  }
                 /*var response = await FlutterShareMe().shareToTwitter(
                      msg: _bullywordController.text + bully.result0.toString());
                  if (response == 'success') {
                    //showAlertDialog(context, 'ทวีตข้อความสำเร็จ');
                  }*/
                }
                else{
                  print('time out');
                }
                },
                color: color3,
                textColor: Colors.white,
                padding: EdgeInsets.only(right: 30 , left: 30, bottom: 10, top: 10),
                child: Text("Tweet on Twitter".toUpperCase(),
                    style: TextStyle(fontSize: 25)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: color3)),

              ),
            ),
           Container(
             padding: EdgeInsets.only(top: 10 , bottom: 30),
             child:  ButtonTheme(
               minWidth: 300.0,
               child: RaisedButton(
                 color: color4,
                 textColor: Colors.white,
                 padding: EdgeInsets.only(right: 30 , left: 30, bottom: 10, top: 10),
                 child: Text("Log Out".toUpperCase(),
                     style: TextStyle(fontSize: 25)),
                 shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(20.0),
                     side: BorderSide(color: color4)),
                 onPressed: _logout,
               ),
             ),
           )
          ],
        );

  }
  showAlertDialog(BuildContext context, String text , int bully) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () async{
       if(bully==0){
         var response = await FlutterShareMe().shareToTwitter(
             msg: _bullywordController.text + ' #ThaiBullyDetectionApp');
         if (response == 'success') {
           //showAlertDialog(context, 'ทวีตข้อความสำเร็จ');
         }
       }
      Navigator.pop(context);},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Result"),
      content: Text(text),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  indexOfMax(arr) {
    if (arr.length == 0) {
      return -1;
    }

    var max = arr[0];
    var maxIndex = 0;

    for (var i = 1; i < arr.length; i++) {
      if (arr[i] > max) {
        maxIndex = i;
        max = arr[i];
      }
    }

    return maxIndex;
  }
}
