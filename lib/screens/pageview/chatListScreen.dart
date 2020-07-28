import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vulpix/models/contact.dart';
import 'package:vulpix/provider/userprovider.dart';
import 'package:vulpix/resources/chat_methods.dart';
import 'package:vulpix/screens/pageview/widgets/contact_view.dart';
import 'package:vulpix/screens/pageview/widgets/new_chat_button.dart';
import 'package:vulpix/screens/pageview/widgets/quiet_box.dart';
import 'package:vulpix/screens/pageview/widgets/user_circle.dart';
import 'package:vulpix/utils/universalvariables.dart';
import 'package:vulpix/widgets/appbar.dart';

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
    final UserProvider userProvider=Provider.of<UserProvider>(context);
    ChatMethods _chatMethods=ChatMethods();
    return Container(
      child: StreamBuilder(
              stream: _chatMethods.fetchContacts(
                userId: userProvider.getUser.uid
              ),
              builder: (context,snapshot){
                if(snapshot.hasData)
                {
                  var docList=snapshot.data.document;
                  if(docList.isEmpty){
                  return  QuietBox();
                  }
                  return ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: docList.length,
                    itemBuilder:(context,index){
                      Contact contact=Contact.fromMap(docList[index].data);
                      return ContactView(contact);
                    },);
                }
                return Center(child: CircularProgressIndicator(),);
             },
      ),
    );
  }
}



