import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viidieo_call/screens/call_screen.dart';

class HomePagetwo extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePagetwo> {
List <String> img = [ "img/aa.jpg" ,"img/ambani.jpg" , "img/selfi1.jpeg"  ,"img/bot1.jpg" ,"img/bot.jpg" ,"img/rc.jpg" ,"img/bot5.jpg", "img/kajal.jpg" ,"img/rc.jpg" ,"img/bot5.jpg", "img/kajal.jpg"] ;
List <String> title = [ "Allu Arjun" ,"Ambani" ,"lakshmi prasad" ,"pawan Kalayan" , "mahesh babu" ,"ram charan " , "Raj mouli" ,"Kajal","ram charan " , "Raj mouli" ,"Kajal"];
List <String> date = ["june 18 2021 , 9:40 pm" ,"june 17 2021 , 9:40 pm" ,"june 16 2021 , 9:40 pm" ,"june 15 2021 , 9:40 pm" ,"june 14 2021 , 9:40 pm" ,
  "june 14 2021 , 9:40 pm" ,"june 13 2021 , 9:40 pm" ,"june 12 2021 , 9:40 pm" ,"june 14 2021 , 9:40 pm" ,"june 13 2021 , 9:40 pm" ,"june 12 2021 , 9:40 pm" ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Center(
            child: Text(
              "Edit",
              style: TextStyle(
                  color: Colors.purple,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            )),
        centerTitle: true,
        title: Text(
          "Calls",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          Icon(
            Icons.more_vert,
            color: Colors.purple,
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: [
                Container(
                  height: 50,
                  width: 350,
                  child: Stack(
                    children: [

                      Positioned(
                        left: 0,
                        child: Container(

                          height: 50,
                          width: 175,
                          decoration: BoxDecoration(
                              color: Colors.white,
                            borderRadius: BorderRadius.circular(30)
                          ),
                          child: Center(child: Text("All" , style: TextStyle(color: Colors.purple),)),
                        ),
                      ),
                      Positioned(
                        right:0,
                        child: Container(
                          height: 50,
                          width: 185,

                          decoration: BoxDecoration(
                            color: Colors.blueGrey[50],
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Center(child: Text("Missed" ,style: TextStyle(color: Colors.grey),)),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300],
                        offset: const Offset(
                          2.0,
                          2.0,
                        ),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 10,),
                Expanded(
                  child: ListView.separated(
                    primary: false,
                    itemCount: title.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return AllCalls(name: title[index],
                        img: img[index],
                        date: date[index],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xFFFFFF),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Color(0xff00000029),
                    offset: Offset(0, 3),
                    blurRadius: 6)
              ]),
          margin: EdgeInsets.only(bottom: 5),
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
             Icon(Icons.phone , color: Colors.purple,),
              Icon(Icons.message , color: Colors.black54,),
             CircleAvatar(
radius: 23,
                  backgroundImage: AssetImage("img/dail2.png" ),
                ),

              Icon(Icons.person ,color: Colors.black54,),
              Icon(Icons.more_horiz ,color: Colors.black54,),
            ],
          )
        ),

      ),
// bottomNavigationBar: BottomNavigationBar(
//   items: [
//     BottomNavigationBarItem(icon: Icon(Icons.phone), title: Text("")),
//     BottomNavigationBarItem(icon: Icon(Icons.message) ,title: Text("")),
//     BottomNavigationBarItem(icon: Icon(Icons.person),title: Text("")),
//     BottomNavigationBarItem(icon: Icon(Icons.more_horiz),title: Text(""))
//   ],
// ),

    );

  }
}

class AllCalls extends StatefulWidget {

AllCalls({ this.name , this.date , this.img});
final String img ;
final String date ;
final String name ;

  @override
  _AllCallsState createState() => _AllCallsState();
}

class _AllCallsState extends State<AllCalls> {
  ClientRole _role = ClientRole.Broadcaster;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 0, right: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(widget.img,),
                      fit: BoxFit.cover
                    ),
                   ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name ,style: TextStyle(fontSize: 16,
                      color: Colors.black , fontWeight: FontWeight.w600),),
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      Icon(
                        Icons.call_missed,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(widget.date , style: TextStyle(fontSize: 11,
                      color: Colors.grey , fontWeight: FontWeight.w600),),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: 10,),
          Row(

              children: [
               Image.asset("img/phone.png" ,height: 30,width: 30, color: Colors.purple,),
                SizedBox(
                  width: 15,
                ),
                InkWell
                  (
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CallPage(channelName: "lpk",role: _role,
                            img: widget.img,name: widget.name,)),
                    );
                  },
                    child: Image.asset("img/vidieo.png" ,height: 30, width: 30, color: Colors.purple,)),


              ],
            ),

        ],
      ),
    );
  //   return ListTile(
  //     leading: CircleAvatar(
  //       backgroundColor: Colors.green,
  //       radius: 30,
  //
  //     ),
  //     title: Text(widget.name),
  //     subtitle: Row(
  //       children: [
  //         Icon(Icons.call),
  //         Text(widget.date)
  //
  //       ],
  //     ),
  //     trailing: trall(),
  //   );
  // }
  // Widget trall (){
  //   Row(
  //     children: [
  //       Icon(Icons.call , size: 100,), InkWell(
  //           onTap: (){
  //             Navigator.push(context, MaterialPageRoute(builder: (Context) => CallPage(role: _role, channelName: "lpk",)));
  //           },
  //           child: Icon(Icons.call , size: 10,)),
  //     ],
  //   );
}
}
