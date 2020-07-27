import 'package:flutter/material.dart';
import 'package:vulpix/screens/pageview/widgets/new_chat_button.dart';
import 'package:vulpix/screens/pageview/widgets/user_circle.dart';
import 'package:vulpix/utils/universalvariables.dart';
import 'package:vulpix/widgets/appbar.dart';
import 'package:vulpix/widgets/custom_tile.dart';

class ChatListScreen extends StatelessWidget {

    CustomAppBar customAppBar( BuildContext context)
    {
      return CustomAppBar(
        leading:IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.white), 
            onPressed: null),
            title:UserCircle(),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search,
                color: Colors.white),
                onPressed: (){
                  Navigator.pushNamed(context, '/search_screen');
                },
              ),

              IconButton(
                icon: Icon(Icons.more_vert,
                color: Colors.white),
                onPressed: (){},
              ),
            ],
      );
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      floatingActionButton:NewChatButton(),
      body: ChatListContainer(),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  @override
  
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 3,
        itemBuilder:(context,index){
          return CustomTile(
            mini: false,
            onTap: (){},
            title: Text("Abhay Gautam",
                    style: TextStyle(
                      color: Colors.white,fontFamily: "Arial",fontSize: 19),),
            subtitle: Text("Yaa lets meet at the ccd",
                      style: TextStyle(
                        color: UniversalVariables.greyColor,fontSize: 14,
                      ),), 
             leading: Container(
               constraints: BoxConstraints(maxHeight: 60,maxWidth: 60),
               child: Stack(
                 children: <Widget>[
                   CircleAvatar(
                     maxRadius: 30,
                     backgroundColor: Colors.grey,
                     backgroundImage: NetworkImage("https://scontent.fluh3-1.fna.fbcdn.net/v/t1.0-9/78203659_621665865038336_1898394953789210624_o.jpg?_nc_cat=105&_nc_sid=09cbfe&_nc_ohc=PSSgeeaft8MAX_Pz2ZB&_nc_ht=scontent.fluh3-1.fna&oh=3980ed2e246a95d3a8519b4e7f4ef788&oe=5F2F5F27"),
                   ),
                   Align(
                     alignment: Alignment.bottomRight,
                     child: Container(
                       height: 15,
                       width: 15,
                       decoration: BoxDecoration(
                         color: UniversalVariables.onlineDotColor,
                         shape: BoxShape.circle,
                         border: Border.all(
                           color:UniversalVariables.blackColor,
                           width: 2,
                         )
                       ),
                       ),),
                 ],),
             ),                  
          );
        },),
    );
  }
}



