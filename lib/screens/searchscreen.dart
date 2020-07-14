import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:vulpix/models/user.dart';
import 'package:vulpix/resources/firebase_repository.dart';
import 'package:vulpix/screens/chat_screens/chatscreen.dart';
import 'package:vulpix/utils/universalvariables.dart';
import 'package:vulpix/widgets/custom_tile.dart';

FirebaseRepository _repository=FirebaseRepository();

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<User> userList=List();
  String query="";
TextEditingController searchController=TextEditingController();

  @override
  void initState() {
 
    super.initState();
    _repository.getCurrentUser().then((FirebaseUser user){
       _repository.fetchAllUsers(user).then((List<User> value) {
       setState((){
          userList=value;
       });
       });
    });
  }

  GradientAppBar searchAppBar(BuildContext context)
  {
    return GradientAppBar(
      gradient: LinearGradient(colors: [UniversalVariables.gradientColorStart,UniversalVariables.gradientColorEnd]),
      leading: IconButton(
        icon:Icon(Icons.arrow_back,color: Colors.white,), 
       onPressed: ()=>Navigator.pop(context),),
       elevation: 0,
       bottom: PreferredSize(
         preferredSize: const Size.fromHeight(kToolbarHeight+20),
        child:Padding(
          padding: EdgeInsets.only(left:20),
          child: TextField(
            controller: searchController,
            onChanged: (value){
              setState(() {
                query=value;
              });
            },
            cursorColor: Colors.white,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 35,
            ),
            decoration: InputDecoration(
              suffixIcon:IconButton(
                color: Colors.white,
                icon:Icon(Icons.close),
                onPressed: (){
                  searchController.clear();
                },
              ),
              border: InputBorder.none,
              hintText: "Search...",
              hintStyle: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Color(0x88ffffff),
              )
            ),
          ),),
       ),
    );
  }

  buildSuggestion(String query)
  {
    final List<User> suggestionList=query.isEmpty?[]:
              userList.where((User user) => 
              (user.username.toLowerCase().contains(query.toLowerCase())||
              (user.name.toLowerCase().contains(query.toLowerCase())))).toList();  
              
             return ListView.builder(
                itemCount: suggestionList.length,
                itemBuilder:(context,index){
                  User searchedUser=User(
                      uid: suggestionList[index].uid,
                      name: suggestionList[index].name,
                      profilePhoto: suggestionList[index].profilePhoto,
                      username: suggestionList[index].username,
                  );
          
                  return CustomTile(
                    mini:false,
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>ChatScreen(
                          receiver:searchedUser
                        )));
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(searchedUser.profilePhoto),
                      backgroundColor: Colors.grey,), 
                    title: Text(
                      searchedUser.username,
                      style: TextStyle(
                        color:Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ), 
                    subtitle: Text(
                      searchedUser.name,
                      style: TextStyle(
                        color: UniversalVariables.greyColor,
                      ),
                    ),);
                },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal:20),
        child:buildSuggestion(query),
      ),
    );
  }
}
