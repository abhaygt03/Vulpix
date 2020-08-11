import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
 
 final Widget leading;
 final Widget title;
 final Widget icon;
 final Widget subtitle;
 final Widget trailing;
 final EdgeInsets margin;
 final bool mini;
 final GestureTapCallback onTap;
 final GestureLongPressCallback onLongPress;

 CustomTile({
  @required this.leading,
  @required this.title,
   this.icon,
  @required this.subtitle,
  this.trailing,
   this.margin=const EdgeInsets.all(0),
   this.mini=true,
   this.onTap,
   this.onLongPress,
 });
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
    padding: EdgeInsets.symmetric(horizontal: mini?10:0) ,
    margin: margin,
    child: Row(
      children: <Widget>[
        leading,
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left:mini?10:13),
            padding: EdgeInsets.symmetric(vertical: mini?3:15),
            decoration: BoxDecoration(
              border: Border(
              bottom: BorderSide(
                width: 0.6,
                color: Colors.grey
              ),),),
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    title,
            trailing!=null?trailing:Container(),
                  ],
                ),
                SizedBox(height:8),
                Row(
                  children: <Widget>[
                    icon!=null?icon:Container(),
                    subtitle,

                  ],
                )
              ],
            ),),),
      ],),),
      );
  }
}