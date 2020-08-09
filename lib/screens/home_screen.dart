import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:vulpix/const/profilepage_constants.dart';
import 'package:vulpix/enum/user_state.dart';
import 'package:vulpix/provider/themeprovider.dart';
import 'package:vulpix/provider/userprovider.dart';
import 'package:vulpix/resources/auth_methods.dart';
import 'package:vulpix/screens/call_screens/pick_up/pickup_layout.dart';
import 'package:vulpix/screens/pageview/chatListScreen.dart';
import 'package:vulpix/utils/universalvariables.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
  PageController pageController;
  int _page=0;
  AuthMethods _authMethods=AuthMethods();
  UserProvider userProvider;

  @override
  void initState() {

    super.initState();
    
    SchedulerBinding.instance.addPostFrameCallback((_) async{
    userProvider=Provider.of<UserProvider>(context,listen:false);
    await userProvider.refreshUser();
    _authMethods.setUserState(userId: userProvider.getUser.uid, userState: UserState.Online);
     });

     WidgetsBinding.instance.addObserver(this);

    pageController=PageController();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){

    String currentUserId=
          (userProvider!=null&&userProvider.getUser!=null)
          ?userProvider.getUser.uid:"";
    
    super.didChangeAppLifecycleState(state);

    switch(state){
      case AppLifecycleState.resumed:
              currentUserId!=null?_authMethods.setUserState(
              userId: currentUserId, userState: UserState.Online)
              :print("resumed state");
            break;
      case AppLifecycleState.inactive:
              currentUserId!=null?_authMethods.setUserState(
              userId: currentUserId, userState: UserState.Offline)
              :print("Inactive state");
            break;
      case AppLifecycleState.paused:
            currentUserId!=null?_authMethods.setUserState(
              userId: currentUserId, userState: UserState.Waiting)
              :print("paused state");
            break;
      case AppLifecycleState.detached:
            currentUserId!=null?_authMethods.setUserState(
              userId: currentUserId, userState: UserState.Offline)
              :print("Inactive state");
            break;            
    }

  }

  void onpagechange(int page){
    setState(() {
      _page=page;
    });
  }

  void navigationTapped(int page)
  {
    pageController.jumpToPage(page);
  }
  
  @override
  Widget build(BuildContext context) {
    Theme_Provider themeProvider=Provider.of<Theme_Provider>(context);
    return  PickupLayout(
       scaffold:Scaffold(
        backgroundColor:(themeProvider.theme=="D")?UniversalVariables.blackColor: kLightSecondaryColor,
        body: PageView(children: <Widget>[
          Container(child: ChatListScreen(),),
          Center(child: Text("Call Logs",style:TextStyle(color: Colors.white),),),
          Center(child: Text("Contact Screen",style:TextStyle(color: Colors.white)),)
        ],
        
        controller:pageController,
        onPageChanged: onpagechange),
        bottomNavigationBar: Container(
          child:Padding(padding: EdgeInsets.symmetric(vertical:10),
          child: CupertinoTabBar(backgroundColor:(themeProvider.theme=="D")?UniversalVariables.blackColor: kLightSecondaryColor,
          items: <BottomNavigationBarItem>[

            buildBottomNavigationBarItem(0,"Chats",Icons.chat),
            buildBottomNavigationBarItem(1,"Calls",Icons.call),
            buildBottomNavigationBarItem(2,"Contacts",Icons.contact_phone),

          ],
          onTap: navigationTapped,
          currentIndex: _page,
          ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(int pgno,String title,IconData name) {
    return BottomNavigationBarItem(
        icon: Icon(name,
        color:(_page==pgno)
        ?UniversalVariables.lightBlueColor
        :UniversalVariables.greyColor,),
        title: Text(title,
        style: TextStyle(
          fontSize: 10,
          color: (_page==pgno)
        ?UniversalVariables.lightBlueColor
        :UniversalVariables.greyColor
        ),)
        );
  }
}
