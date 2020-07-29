import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vulpix/models/contact.dart';
import 'package:vulpix/models/user.dart';
import 'package:vulpix/provider/userprovider.dart';
import 'package:vulpix/resources/auth_methods.dart';
import 'package:vulpix/resources/chat_methods.dart';
import 'package:vulpix/screens/chat_screens/chatscreen.dart';
import 'package:vulpix/utils/universalvariables.dart';
import 'package:vulpix/widgets/custom_tile.dart';

import 'last_message.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods=AuthMethods();

  ContactView(this.contact);
  @override
  Widget build(BuildContext context) { 
    return FutureBuilder<User>(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context,snapshot){
        if(snapshot.hasData){
          User user=snapshot.data;
          return ViewLayout(contact: user);
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final User contact;
  final ChatMethods _chatMethods=ChatMethods();

  ViewLayout({
    @required this.contact
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider=Provider.of<UserProvider>(context);
    return CustomTile(
            mini: false,
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(receiver: contact,))),
            title: Text(
                    contact.name,
                    style: TextStyle(
                      color: Colors.white,fontFamily: "Arial",fontSize: 19),),
            subtitle: LastMessageContainer(
              stream: _chatMethods.fetchLastMessage(
                senderId: userProvider.getUser.uid,
                recerverId: contact.uid
              ),
            ),
             leading: Container(
               constraints: BoxConstraints(maxHeight: 60,maxWidth: 60),
               child: Stack(
                 children: <Widget>[
                   CircleAvatar(
                     maxRadius: 30,
                     backgroundColor: Colors.grey,
                     backgroundImage: NetworkImage(contact.profilePhoto),
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
  }
}