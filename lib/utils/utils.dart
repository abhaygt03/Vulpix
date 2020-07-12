class Utils{
static String getUsername(String email){
  return "live:${email.split('@')[0]}";
}

static String getInitials(String name){
List<String> nameSplit=name.split(" ");
String fstname=nameSplit[0][0];
String lstname=nameSplit[1][0];
return fstname+lstname;
} 
}