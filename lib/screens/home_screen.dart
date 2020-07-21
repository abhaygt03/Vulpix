import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:vulpix/provider/userprovider.dart';
import 'package:vulpix/screens/call_screens/pick_up/pickup_layout.dart';
import 'package:vulpix/screens/pageview/chatListScreen.dart';
import 'package:vulpix/utils/universalvariables.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController;
  int _page=0;

  UserProvider userProvider;

  @override
  void initState() {

    super.initState();
    
    SchedulerBinding.instance.addPostFrameCallback((_) {
    userProvider=Provider.of<UserProvider>(context,listen:false);
    userProvider.refreshUser();

     });

    pageController=PageController();
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
    return  PickupLayout(
       scaffold:Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: PageView(children: <Widget>[
          Container(child: ChatListScreen(),),
          Center(child: Text("Call Logs",style:TextStyle(color: Colors.white),),),
          Center(child: Text("Contact Screen",style:TextStyle(color: Colors.white)),)
        ],
        
        controller:pageController,
        onPageChanged: onpagechange),
        bottomNavigationBar: Container(
          child:Padding(padding: EdgeInsets.symmetric(vertical:10),
          child: CupertinoTabBar(backgroundColor: UniversalVariables.blackColor,
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
