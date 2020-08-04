import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vulpix/const/profilepage_constants.dart';
import 'package:vulpix/enum/view_state.dart';
import 'package:vulpix/models/user.dart';
import 'package:vulpix/provider/image_upload_provider.dart';
import 'package:vulpix/provider/userprovider.dart';
import 'package:vulpix/resources/auth_methods.dart';
import 'package:vulpix/resources/storage_methods.dart';
import 'package:vulpix/screens/pageview/widgets/profile_list_items.dart';
import 'package:vulpix/utils/utils.dart';

import '../../login_screen.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: kDarkTheme,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeProvider.of(context),
            home: ProfileScreen(context),
          );
        },
      ),
    );
  }
}


class ProfileScreen extends StatefulWidget {
  final BuildContext cont;
  ProfileScreen(this.cont);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {

    ImageUploadProvider _imageUploadProvider;
    StorageMethods _storageMethods=StorageMethods();
    AuthMethods authMethods=AuthMethods();
    _imageUploadProvider=Provider.of<ImageUploadProvider>(context);
    final UserProvider userProvider=Provider.of<UserProvider>(context);
    User user=userProvider.getUser;
    
    ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);

 void refresh(){
      userProvider.refreshUser();
      user=userProvider.getUser;
    }

  Future<void>pickImage(ImageSource source) async {
      File selectedImage=await Utils.pickImage(source: source);

      await _storageMethods.uploadProfilePic(
        selectedImage,
        user.uid,
        _imageUploadProvider,
      );
      refresh();
  }

    

    var profileInfo = Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: kSpacingUnit.w * 10,
            width: kSpacingUnit.w * 10,
            margin: EdgeInsets.only(top: kSpacingUnit.w * 3),
            child: Stack(
              children: <Widget>[
                _imageUploadProvider.getViewState==ViewState.LOADING?
                CircleAvatar(
                  radius: kSpacingUnit.w * 5,
                  child: CircularProgressIndicator(),):
                CircleAvatar(
                  radius: kSpacingUnit.w * 5,
                  backgroundImage: NetworkImage(user.profilePhoto),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                              child: Container(
                      height: kSpacingUnit.w * 2.5,
                      width: kSpacingUnit.w * 2.5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        heightFactor: kSpacingUnit.w * 1.5,
                        widthFactor: kSpacingUnit.w * 1.5,
                        child: Icon(
                          LineAwesomeIcons.pen,
                          color: kDarkPrimaryColor,
                          size: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
                        ),
                      ),
                    ),
                    onTap: () =>
                    pickImage(ImageSource.gallery),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: kSpacingUnit.w * 2),
          Text(
            user.name,
            style: kTitleTextStyle,
          ),
          SizedBox(height: kSpacingUnit.w * 0.5),
          Text(
            user.email,
            style: kCaptionTextStyle,
          ),
          SizedBox(height: kSpacingUnit.w * 2),
          Container(
            height: kSpacingUnit.w * 4,
            width: kSpacingUnit.w * 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
              color: Theme.of(context).accentColor,
            ),
            child: Center(
              child: Text(
                'Upgrade to PRO',
                style: kButtonTextStyle,
              ),
            ),
          ),
        ],
      ),
    );

    var themeSwitcher = ThemeSwitcher(
      builder: (context) {
        return AnimatedCrossFade(
          duration: Duration(milliseconds: 200),
          crossFadeState:
              ThemeProvider.of(context).brightness == Brightness.dark
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
          firstChild: GestureDetector(
            onTap: () =>
                ThemeSwitcher.of(context).changeTheme(theme: kLightTheme),
            child: Icon(
              LineAwesomeIcons.sun,
              size: ScreenUtil().setSp(kSpacingUnit.w * 3),
            ),
          ),
          secondChild: GestureDetector(
            onTap: () =>
                ThemeSwitcher.of(context).changeTheme(theme: kDarkTheme),
            child: Icon(
              LineAwesomeIcons.moon,
              size: ScreenUtil().setSp(kSpacingUnit.w * 3),
            ),
          ),
        );
      },
    );

    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: kSpacingUnit.w * 3),
        GestureDetector(
                  child: Icon(
            LineAwesomeIcons.arrow_left,
            size: ScreenUtil().setSp(kSpacingUnit.w * 3),
          ),
          onTap: ()=>Navigator.pop(widget.cont),
        ),
        profileInfo,
        themeSwitcher,
        SizedBox(width: kSpacingUnit.w * 3),
      ],
    );

    signOut() async{
      final bool isLoggedOut=await authMethods.signOut();
         if(isLoggedOut){
           Navigator.pushAndRemoveUntil(context, 
           MaterialPageRoute(builder: (context)=>LoginScreen()),
            (route) => false);
         } 
    }
    
    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Column(
              children: <Widget>[
                SizedBox(height: kSpacingUnit.w * 5),
                header,
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      ProfileListItem(
                        icon: LineAwesomeIcons.user_shield,
                        text: 'Privacy',
                      ),
                      ProfileListItem(
                        icon: LineAwesomeIcons.history,
                        text: 'Purchase History',
                      ),
                      ProfileListItem(
                        icon: LineAwesomeIcons.question_circle,
                        text: 'Help & Support',
                      ),
                      ProfileListItem(
                        icon: LineAwesomeIcons.cog,
                        text: 'Settings',
                      ),
                      ProfileListItem(
                        icon: LineAwesomeIcons.user_plus,
                        text: 'Invite a Friend',
                      ),
                      ProfileListItem(
                        icon: LineAwesomeIcons.alternate_sign_out,
                        text: 'Logout',
                        onTap: ()=>signOut(),
                        hasNavigation: false,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
