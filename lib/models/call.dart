class Call{
  String callerName;
  String callerPic;
  String callerId;
  String receiverName;
  String receiverPic;
  String receiverId;
  String channelId;
  bool hasDialled;

  Call({
  this.callerName,
  this.callerPic,
  this.callerId,
  this.receiverName,
  this.receiverPic,
  this.receiverId,
  this.channelId,
  this.hasDialled,
  });

  Map<String,dynamic> toMap(Call call){
      Map<String,dynamic> map=Map();
      map["caller_id"]=call.callerId;
      map["caller_pic"]=call.callerPic;
      map["caller_name"]=call.callerName;
      map["receiver_id"]=call.receiverId;
      map["receiver_pic"]=call.receiverPic;
      map["receiver_name"]=call.receiverName;
      map["channel_id"]=call.channelId;
      map["has_dialled"]=call.hasDialled;

    return map;
  }

  Call.fromMap(Map map)
  {
    this.callerId=map["caller_id"];
    this.callerName= map["caller_name"];
    this.callerPic=map["caller_pic"];
    this.receiverName=map["receiver_name"];
    this.receiverPic=map["receiver_pic"];
    this.receiverId=map["receiver_id"];
    this.channelId=map["channel_id"];
    this.hasDialled= map["has_dialled"];
  }
}