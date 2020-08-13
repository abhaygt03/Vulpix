import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vulpix/models/message.dart';

class LastMessageContainer extends StatelessWidget {
  final stream;
  final requirement;
  LastMessageContainer({
    @required this.stream,
    @required this.requirement
  }); 
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder:(context,AsyncSnapshot<QuerySnapshot> snapshot){
        
        if(requirement=="lastmsg")
        {
        if(snapshot.hasData)
        {
          var docList=snapshot.data.documents;

          if(docList.isNotEmpty){
            Message message=Message.fromMap(docList.last.data);

            return SizedBox(
              width: MediaQuery.of(context).size.width*0.7,
              child: Text(
                message.message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color:Colors.grey[600],
                  fontSize: 14
                ),
              ),
            );
          }
            return Text("No Message",
                style: TextStyle(
                  color:Colors.grey,
                  fontSize: 14
                ),
              );

        }
        return Text("...",
                style: TextStyle(
                  color:Colors.grey,
                  fontSize: 14
                ),
              );
        }

        else if(requirement=="time")
        {
          if(snapshot.hasData)
        {
          var docList=snapshot.data.documents;

          if(docList.isNotEmpty){
            Message message=Message.fromMap(docList.last.data);
            var msgstamp=message.timestamp.toDate();
            var msgdate=DateTime(msgstamp.year,msgstamp.month,msgstamp.day,msgstamp.hour,msgstamp.minute,msgstamp.second);
            var now=DateTime.now();
            String text;
            final difference=now.difference(msgdate).inSeconds;
            if(difference<60)
            text="secs ago";
            else if(difference<3600)
            text=(difference~/60).toString()+"m ago";
            else if(difference<86400)
            text=(difference~/3600).toString()+"h ago";
            else if(difference<864000)
            text=(difference~/86400).toString()+"d ago";
            else if(difference<2592000)
            text=(difference~/604800).toString()+"w ago";
            else
            text=msgstamp.day.toString()+"/"+msgstamp.month.toString()+"/"+msgstamp.year.toString();
            return Text(text!=null?text:"",style: TextStyle(color:Colors.grey),);
          }
        }
        }

        return Container();
      });
  }
}