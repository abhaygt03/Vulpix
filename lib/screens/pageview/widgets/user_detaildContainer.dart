import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vulpix/enum/user_state.dart';
import 'package:vulpix/models/user.dart';
import 'package:vulpix/provider/userprovider.dart';
import 'package:vulpix/resources/auth_methods.dart';
import 'package:vulpix/screens/login_screen.dart';
import 'package:vulpix/widgets/appbar.dart';


// class UserDetailsContainer extends StatelessWidget {
//   final AuthMethods authMethods = AuthMethods();

//   @override
//   Widget build(BuildContext context) {
//      final UserProvider userProvider = Provider.of<UserProvider>(context);
//      signOut() async{
//       final bool isLoggedOut=await authMethods.signOut();
//          if(isLoggedOut){
//            authMethods.setUserState(
//           userId: userProvider.getUser.uid,
//           userState: UserState.Offline,
//         );
//            Navigator.pushAndRemoveUntil(context, 
//            MaterialPageRoute(builder: (context)=>LoginScreen()),
//             (route) => false);
//          } 
//     }
//     return Container(
//       margin: EdgeInsets.only(top:25),
//       child: Column(
//         children: <Widget>[
//           CustomAppBar(
//            title: null,
//            centerTitle: true,
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back,color:Colors.white,),
//                onPressed: ()=>Navigator.maybePop(context)),
               
//               actions: <Widget>[
//                 FlatButton(
//                   onPressed: ()=>signOut(),
//                   child: Text("Sign out",
//                             style: TextStyle(color:Colors.white,
//                                               fontSize: 12),),
//                 )
//               ],),

//               UserDetailsBody(),
//         ],
//       ),
//     );
//   }
// }

// class UserDetailsBody extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//      final UserProvider userProvider = Provider.of<UserProvider>(context);
//     final User user = userProvider.getUser;
//     return  Container(
//       padding: EdgeInsets.all(20),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
            
//          CircleAvatar(
//                      maxRadius: 26.5,
//                      backgroundColor: Colors.grey,
//                      backgroundImage: NetworkImage(user.profilePhoto),
//                    ),

//                    SizedBox(width: 15,),
                   
//                    Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        SizedBox(height: 5,),
//                      Text(
//                        user.name,
//                        style: TextStyle(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 16,
//                          color: Colors.white
//                        ),
//                      ),

//                       SizedBox(height:5),

//                       Text(
//                        user.email,
//                        style: TextStyle(
//                          fontSize: 12,
//                          color: Colors.white
//                        ),
//                      ),
//                    ],)
//       ],),
//     );
//   }
// }




class UserDetailsContainer extends StatefulWidget {
  @override
  _UserDetailsContainerState createState() => _UserDetailsContainerState();
}

class _UserDetailsContainerState extends State<UserDetailsContainer> {
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


class UserDetailsBody extends StatefulWidget {
  @override
  _UserDetailsBodyState createState() => _UserDetailsBodyState();
}

class _UserDetailsBodyState extends State<UserDetailsBody> {
  bool edit=false;
  IconData ic=Icons.edit;
  AuthMethods authMethods=AuthMethods();
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
     User user=userProvider.getUser;
    TextEditingController controller=TextEditingController(text: user.name);
    void refresh(){
      userProvider.refreshUser();
      user=userProvider.getUser;
    }
    return Container(
      padding: EdgeInsets.only(top:35),
      child: Column(children: <Widget>[
       CircleAvatar(
              radius: 58,
              backgroundColor: Colors.lightBlueAccent,
              child:CircleAvatar(
                           maxRadius: 53,
                           backgroundColor: Colors.grey,
                           backgroundImage: NetworkImage(user.profilePhoto),
                         ),
            ),
                   SizedBox(height: 12,),

                   Row(
                     children: <Widget>[
                       SizedBox(width: 60,),
                       Expanded(
                                child: Center(
                                  child: (!edit)?
                                  (Text(
                                 user.name,
                             style: TextStyle(
                               fontWeight: FontWeight.bold,
                               fontSize: 22,
                               color: Colors.white
                             ),))
                             :(TextField(
                             controller: controller,
                             textAlign: TextAlign.center,
                             style: TextStyle(
                               fontWeight: FontWeight.bold,
                               fontSize: 22,
                               color: Colors.white
                             ),)),
                                ),
                                ),
                           IconButton(icon: Icon(ic),
                           iconSize: 27,
                           onPressed: (){
                           
                             setState((){
                          if(edit)
                            {
                             authMethods.changeUserName(name: controller.text, userId: user.uid);
                             refresh();
                            }
                             edit=!edit;
                             if(edit)
                             ic=Icons.check;
                             else
                             ic=Icons.edit;
                           }
                           );
                           
                           },),
                       SizedBox(width: 10,),
                     ],
                   ),
      ],),
    );
  }
}