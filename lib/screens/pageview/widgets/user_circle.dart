import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vulpix/provider/userprovider.dart';
import 'package:vulpix/screens/pageview/widgets/user_detaildContainer.dart';
import 'package:vulpix/utils/universalvariables.dart';
import 'package:vulpix/utils/utils.dart';

class UserCircle extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider=Provider.of<UserProvider>(context);
    return GestureDetector(
          onTap: (){
            return showModalBottomSheet(
              context: context, 
              builder: (context)=>UserDetailsContainer(),
              isScrollControlled: true,
              backgroundColor: UniversalVariables.blackColor);
          },


          child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: UniversalVariables.separatorColor,
          borderRadius: BorderRadius.circular(50)),

          child: Stack(children: <Widget>[
            Align(
              child: Text(
                Utils.getInitials(userProvider.getUser.name)??"",
              style: TextStyle(
                color:UniversalVariables.lightBlueColor,
                fontWeight: FontWeight.bold,
                fontSize: 13),),
              alignment: Alignment.center,
            ),

                     Align(
                       alignment: Alignment.bottomRight,
                       child: Container(
                         height: 15,
                         width: 15,
                         decoration: BoxDecoration(
                           color: UniversalVariables.onlineDotColor,
                           shape: BoxShape.circle,
                           border: Border.all(
                             color:UniversalVariables.blackColor,
                             width: 2,
                           )
                         ),
                         ),)
          ],),
      ),
    );
  }
}