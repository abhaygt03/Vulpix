import 'package:flutter/material.dart';
import 'package:vulpix/utils/universalvariables.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{

  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;
  final String backcolor;

  const CustomAppBar({
    Key key,
    @required this.title,
    @required this.actions,
    @required this.leading,
    @required this.centerTitle,
    this.backcolor="D",
  }):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(
        backgroundColor: (backcolor=="D")?UniversalVariables.blackColor:Colors.red,
        leading: leading,
        elevation: 0,
        actions:actions,
        centerTitle: centerTitle,
        title: title,
      ),
      
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: (backcolor=="D")?UniversalVariables.blackColor:Colors.red,
        border: Border(bottom:BorderSide(
          color: (backcolor=="D")?UniversalVariables.separatorColor:Colors.red,
          width: 1.4,
          style: BorderStyle.solid)),
      ),

      
    );
  }
  final Size preferredSize=const Size.fromHeight(kToolbarHeight+20);
}