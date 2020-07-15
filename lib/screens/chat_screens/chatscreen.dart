import 'package:flutter/material.dart';
import 'package:vulpix/models/user.dart';
import 'package:vulpix/utils/universalvariables.dart';
import 'package:vulpix/widgets/appbar.dart';
import 'package:vulpix/widgets/custom_tile.dart';

class ChatScreen extends StatefulWidget {
  final User receiver;
  ChatScreen({this.receiver});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  bool isWriting=false;

  setWritingTo(bool v)
          {
            setState(() {
              isWriting=v;
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
        ],
      ),
      );
      
  }
  
  Widget messageList(){
    return ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 10,
        itemBuilder:(context,index){
          return chatMessageItem();
        }
    );
  }

    Container chatMessageItem(){
        return Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Container(
            alignment: Alignment.centerRight,
            child:senderLayout(),
          )
        );
    }

    Widget senderLayout()
    {
      Radius msgradius=Radius.circular(10);
      return Container(
        margin: EdgeInsets.only(top:12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width*0.65
        ),
        decoration: BoxDecoration(
          color:UniversalVariables.senderColor,
          borderRadius: BorderRadius.only(
            topLeft: msgradius,
            topRight: msgradius,
            bottomLeft: msgradius,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Hey, wassup?",
          style: TextStyle(color:Colors.white,fontSize: 16),),)
      );
    }

    Widget receiverLayout()
    {
      Radius msgradius=Radius.circular(10);
      return Container(
        margin: EdgeInsets.only(top:12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width*0.1
        ),
        decoration: BoxDecoration(
          color:UniversalVariables.receiverColor,
          borderRadius: BorderRadius.only(
            bottomRight: msgradius,
            topRight: msgradius,
            bottomLeft: msgradius,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Hey, wassup?",
            softWrap: true,
          style: TextStyle(color:Colors.white,fontSize: 16,),),)
      );
    }

    TextEditingController textFieldController=TextEditingController();

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
          child: TextField(
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
              suffixIcon: GestureDetector(
                onTap: (){},
                child: Icon(Icons.face),
              )
            ),
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

  sendMessage(){}

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