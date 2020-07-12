import 'package:flutter/material.dart';
import 'package:vulpix/resources/firebase_repository.dart';
import 'package:vulpix/utils/universalvariables.dart';
import 'package:vulpix/utils/utils.dart';
import 'package:vulpix/widgets/appbar.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

final FirebaseRepository _repository=FirebaseRepository();

class _ChatListScreenState extends State<ChatListScreen> {

  String currentUserid;
  String initials;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getCurrentUser().then((user) => {
      setState((){
        currentUserid=user.uid;
        initials=Utils.getInitials(user.displayName);
      })
    });
  }

    CustomAppBar customAppBar( BuildContext context)
    {
      return CustomAppBar(
        leading:IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.white), 
            onPressed: null),
            title:UserCircle(initials),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search,
                color: Colors.white),
                onPressed: (){},
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
      body: ChatListContainer(currentUserid),
    );
  }
}

class ChatListContainer extends StatefulWidget {
  final String currentUserId;
  ChatListContainer(this.currentUserId);
  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

class UserCircle extends StatelessWidget {
  final String text;
  UserCircle(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: UniversalVariables.separatorColor,
        borderRadius: BorderRadius.circular(50)),

        child: Stack(children: <Widget>[
          Align(
            child: Text(text,
            style: TextStyle(
              color:UniversalVariables.lightBlueColor,
              fontWeight: FontWeight.bold,
              fontSize: 13),),
            alignment: Alignment.center,
          ),

        Align(
          alignment: Alignment.bottomRight,
          child:Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(
            color: UniversalVariables.onlineDotColor,
              shape: BoxShape.circle,
              border:Border.all(
                color:UniversalVariables.blackColor,
                width: 2,
              ),
            ),
          ),
        ),
        ],),
    );
  }
}

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: UniversalVariables.fabGradient,
        shape: BoxShape.circle,
        border:Border.all(
          width: 1,
          color: Colors.white,
        ),
      ),
      child: Icon(Icons.send,
      color: Colors.white,
      size: 25,
     ),
     padding: EdgeInsets.all(15),
    );
  }
}