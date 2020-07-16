import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:vulpix/const/const.dart';
import 'package:vulpix/models/message.dart';
import 'package:vulpix/models/user.dart';
import 'package:vulpix/utils/universalvariables.dart';
import 'package:vulpix/widgets/appbar.dart';
import 'package:vulpix/widgets/custom_tile.dart';
import 'package:vulpix/resources/firebase_repository.dart';

FirebaseRepository _repository=FirebaseRepository();

class ChatScreen extends StatefulWidget {
  final User receiver;
  ChatScreen({this.receiver});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  User sender;
  String _currentUserId;

  bool isWriting=false;
  bool showEmojiPicker=false;

  FocusNode textFieldFocus=FocusNode();

  setWritingTo(bool v)
          {
            setState(() {
              isWriting=v;
            });
          }

  @override
  void initState() {
    super.initState();

    _repository.getCurrentUser().then((value) {
      _currentUserId=value.uid;   

      setState(() {
        sender=User(
          name:value.displayName,
          profilePhoto: value.photoUrl,
          uid: value.uid );
      });
    });
  }

  showKeyboard()=>textFieldFocus.requestFocus();
  hideKeyboard()=>textFieldFocus.unfocus();

  hideEmojiContainer(){
    setState(() {
      showEmojiPicker=false;
    });
  }

showEmojiContainer(){
    setState(() {
      showEmojiPicker=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column( 
        children: <Widget>[
          Flexible(         //Or we can use expandable
            child: messageList(),
          ),
          chatControls(),
          showEmojiPicker?Container(child: emojiContainer(),):Container(),
        ],
      ),
      );
      
  }

  emojiContainer()
  {
    return EmojiPicker(
      bgColor: UniversalVariables.separatorColor,
      indicatorColor: UniversalVariables.blueColor,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji,category){
        setState(() {
          isWriting=true;
        });

        textFieldController.text=textFieldController.text+emoji.emoji;
      },
      recommendKeywords: ["face","happy","sad","party"],
      numRecommended: 50,
    );
  }
  
  Widget messageList(){
    return StreamBuilder(
      stream: Firestore.instance.collection('messages')
      .document(_currentUserId).collection(widget.receiver.uid).orderBy("timestamp",descending: true).snapshots(),
      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.data==null)
        return Center(child: CircularProgressIndicator(),);

        // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        //   _listScrollController.animateTo(
        //     _listScrollController.position.minScrollExtent,
        //     duration: Duration(milliseconds: 250),
        //     curve: Curves.easeOut,
        //   );
        //  });

        return ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: snapshot.data.documents.length,
        reverse: true,
        controller: _listScrollController,
        itemBuilder:(context,index){
          return chatMessageItem(snapshot.data.documents[index]);
        }
    );
      },
    );
  }

    Container chatMessageItem(DocumentSnapshot snapshot){

      Message _message=Message.fromMap(snapshot.data);
        return Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Container(
            alignment: _message.senderId==_currentUserId? 
            Alignment.centerRight:
            Alignment.centerLeft,
            
            child:_message.senderId==_currentUserId? 
            messageLayout(_message,senderBubble):

          messageLayout(_message,receiverBubble),
          )
        );
    }

    Widget messageLayout(Message message,BorderRadiusGeometry brad)
    {
      
      return Container(
        margin: EdgeInsets.only(top:12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width*0.65
        ),
        decoration: BoxDecoration(
          color:UniversalVariables.senderColor,
          borderRadius: brad,
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            message.message,
          style: TextStyle(color:Colors.white,fontSize: 16),),)
      );
    }

    TextEditingController textFieldController=TextEditingController();

    ScrollController _listScrollController=ScrollController();

  Widget chatControls(){
    return Container(
      padding:EdgeInsets.all(10),
      child:Row(children: <Widget>[
        GestureDetector(
                  child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              gradient: UniversalVariables.fabGradient,
              shape:BoxShape.circle,
            ),
            child: Icon(Icons.add),
          ),
          onTap: (){
            addMediaModal(context);
          },
        ),
        SizedBox(width:8),
        Expanded(
          child: Stack(
            alignment: Alignment.centerRight,
            children:[
               TextField(
                 onTap: ()=>hideEmojiContainer(),
                 focusNode: textFieldFocus,
              controller: textFieldController,
              style: TextStyle(
                color: Colors.white,
              ),
              onChanged: (value){
              (value.length>0&&value.trim()!="")
              ?setWritingTo(true):
              setWritingTo(false);   
              },
              decoration: InputDecoration(
                hintText: "Type a message..",
                hintStyle: TextStyle(
                  color: UniversalVariables.greyColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    const Radius.circular(50)
                  ),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                filled: true,
                fillColor: UniversalVariables.separatorColor,

              ),
            ),
              IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: (){
                  if(showEmojiPicker)
                  {
                  hideEmojiContainer();
                  showKeyboard();
                  }
                  else{
                    showEmojiContainer();
                    hideKeyboard();
                  }
                },
                icon: Icon(Icons.face),
              )
            ]
          ),),

         isWriting ?Container():Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.keyboard_voice,size: 30)),

           isWriting ?Container(): Icon(Icons.camera_alt,size: 30),

          isWriting? Container(
            margin:EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              gradient: UniversalVariables.fabGradient,
              shape: BoxShape.circle,
            ),

           child: IconButton(
            icon: Icon(Icons.send,color: Colors.white,), 
            onPressed: (){
              sendMessage();
            })
          ):
            Container(),
            
      ],)
    );
  }

  addMediaModal(context){
    showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: UniversalVariables.blackColor,
      builder: (context){
        return Column(
          children: <Widget>[
            Container(
            padding: EdgeInsets.symmetric(vertical:15),
            child: Row(children: <Widget>[
              FlatButton(
                child: Icon(Icons.close),
                onPressed: ()=>Navigator.pop(context),),

                Expanded(child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Content and tools",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),),
                  
                ))
            ],),
            ),

            Flexible(
              child: ListView(
                children: <Widget>[
                  ModalTile(
                    icon: Icons.image,
                    title: "Media",
                    subtitle: "Share photos and videos",),

                    ModalTile(
                    icon: Icons.tab,
                    title: "File",
                    subtitle: "Share files",),
                    
                    ModalTile(
                    icon: Icons.contacts,
                    title: "Contact",
                    subtitle: "Share contacts",),

                    ModalTile(
                    icon: Icons.add_location,
                    title: "Location",
                    subtitle: "Share a location",),

                    ModalTile(
                    icon: Icons.schedule,
                    title: "Schedule Call",
                    subtitle: "Arrange a Vulpix call and get reminders",),

                    ModalTile(
                    icon: Icons.poll,
                    title: "Create Poll",
                    subtitle: "Share polls",),
                ],
              ),
            )
          ],
        );
      }
    );
  }

  sendMessage(){
    String text=textFieldController.text;

    Message _message=Message(
      receiverId: widget.receiver.uid,
      senderId: sender.uid,
      timestamp: Timestamp.now(),
      message: text,
      type: 'text',
    );

    setState(() {
      isWriting=false;
    });

    textFieldController.text="";
    _repository.addMessageToDb(_message,sender,widget.receiver);
  }

  CustomAppBar customAppBar(context)
  {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          Navigator.pop(context);
        },
        ),
      centerTitle: false,
      title: Text(
        widget.receiver.name,
      ), 
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.video_call),
          onPressed: (){},),

          IconButton(
          icon: Icon(Icons.phone),
          onPressed: (){},),
      ], );
  }
}

  class ModalTile extends StatelessWidget {
   final String title;
   final String subtitle;
   final IconData icon;
   
   const ModalTile({
     this.icon,
     this.subtitle,
     this.title,
   });

    @override
    Widget build(BuildContext context) {
      return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                    child: CustomTile(mini:false,
                    leading: Container(
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: UniversalVariables.receiverColor
                      ),
                      padding: EdgeInsets.all(10),
                      child: Icon( icon,
                      color: UniversalVariables.greyColor,
                      size: 38,)),

                     title: Text(title,
                     style: TextStyle(
                       color: UniversalVariables.greyColor,
                       fontSize: 18 ,
                     ),), 
                     subtitle:Text(subtitle,
                     style: TextStyle(
                       color:UniversalVariables.greyColor,
                       fontSize: 14,
                     ),)),
      );
    }
  }