import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vulpix/models/user.dart';
import 'package:vulpix/provider/userprovider.dart';
import 'package:vulpix/resources/auth_methods.dart';
import 'package:vulpix/screens/login_screen.dart';
import 'package:vulpix/widgets/appbar.dart';


class UserDetailsContainer extends StatelessWidget {
  final AuthMethods authMethods = AuthMethods();
  @override
  Widget build(BuildContext context) {

    signOut() async{
      final bool isLoggedOut=await authMethods.signOut();
         if(isLoggedOut){
           Navigator.pushAndRemoveUntil(context, 
           MaterialPageRoute(builder: (context)=>LoginScreen()),
            (route) => false);
         } 
    }
    return Container(
      margin: EdgeInsets.only(top:25),
      child: Column(
        children: <Widget>[
          CustomAppBar(
           title: null,
           centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back,color:Colors.white,),
               onPressed: ()=>Navigator.maybePop(context)),
               
              actions: <Widget>[
                FlatButton(
                  onPressed: ()=>signOut(),
                  child: Text("Sign out",
                            style: TextStyle(color:Colors.white,
                                              fontSize: 12),),
                )
              ],),

              UserDetailsBody(),
        ],
      ),
    );
  }
}

class UserDetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user=userProvider.getUser;
    
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
            
         CircleAvatar(
                     maxRadius: 26.5,
                     backgroundColor: Colors.grey,
                     backgroundImage: NetworkImage(user.profilePhoto),
                   ),

                   SizedBox(width: 15,),
                   
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[
                       SizedBox(height: 5,),
                     Text(
                       user.name,
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 16,
                         color: Colors.white
                       ),
                     ),

                      SizedBox(height:5),

                      Text(
                       user.email,
                       style: TextStyle(
                         fontSize: 12,
                         color: Colors.white
                       ),
                     ),
                   ],)
      ],),
    );
  }
}