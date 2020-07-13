import 'package:flutter/material.dart';
import 'package:vulpix/utils/universalvariables.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{

  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;

  const CustomAppBar({
    Key key,
    @required this.title,
    @required this.actions,
    @required this.leading,
    @required this.centerTitle,
  }):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(
        backgroundColor: UniversalVariables.blackColor,
        leading: leading,
        elevation: 0,
        actions:actions,
        centerTitle: centerTitle,
        title: title,
      ),
      
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: UniversalVariables.blackColor,
        border: Border(bottom:BorderSide(
          color: UniversalVariables.separatorColor,
          width: 1.4,
          style: BorderStyle.solid))
      ),

      
    );
  }
  final Size preferredSize=const Size.fromHeight(kToolbarHeight+10);
}