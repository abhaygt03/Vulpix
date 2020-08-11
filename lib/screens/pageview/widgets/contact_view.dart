import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vulpix/models/contact.dart';
import 'package:vulpix/models/user.dart';
import 'package:vulpix/provider/themeprovider.dart';
import 'package:vulpix/provider/userprovider.dart';
import 'package:vulpix/resources/auth_methods.dart';
import 'package:vulpix/resources/chat_methods.dart';
import 'package:vulpix/screens/chat_screens/chatscreen.dart';
import 'package:vulpix/widgets/custom_tile.dart';
import 'package:vulpix/widgets/onlineDotIndicator.dart';

import 'last_message.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods=AuthMethods();

  ContactView(this.contact);
  @override
  Widget build(BuildContext context) { 
    Theme_Provider themeProvider=Provider.of<Theme_Provider>(context);
    return FutureBuilder<User>(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context,snapshot){
        if(snapshot.hasData){
          User user=snapshot.data;
          return ViewLayout(contact: user,thcolor: themeProvider.theme,);
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final User contact;
  final ChatMethods _chatMethods=ChatMethods();
  final String thcolor;
  ViewLayout({
    @required this.contact,
    @required this.thcolor
  });



  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider=Provider.of<UserProvider>(context);
    return CustomTile(
            trailing:  LastMessageContainer(
              requirement: "time",
              stream: _chatMethods.fetchLastMessage(
                senderId: userProvider.getUser.uid,
                recerverId: contact.uid
              ), 
              ),
            mini: false,
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(receiver: contact,))),
            title: Text(
                    contact.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color:(thcolor=="D")? Colors.white:Colors.black,fontFamily: "Arial",fontSize: 19),),
            subtitle: LastMessageContainer(
              requirement: "lastmsg",
              stream: _chatMethods.fetchLastMessage(
                senderId: userProvider.getUser.uid,
                recerverId: contact.uid
              ),
            ),
             leading: Container(
               constraints: BoxConstraints(maxHeight: 58,maxWidth: 58),
               child: Stack(
                 children: <Widget>[
                   CircleAvatar(
                     maxRadius: 30,
                     backgroundColor: Colors.grey,
                     backgroundImage: NetworkImage(contact.profilePhoto),
                   ),
                   Align(
                     alignment: Alignment.bottomRight,
                     child: OnlineDotIndicator(uid: contact.uid,)),
                 ],),
             ),                  
          );
  }
}