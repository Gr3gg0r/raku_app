
class UserAuth{
  final String userID;
  final String displayName;
  final String email;
  UserAuth({this.displayName,this.userID,this.email});
}

class UserProfile{
  final String username,uid,researcher_id,email,image_url,contact_no;
  final friends;
  final group;


  UserProfile({this.uid,this.email,this.username,this.contact_no,this.friends,this.group,this.image_url,this.researcher_id});

  factory UserProfile.fromMap(Map data){
    if(data.length!=0) {
      return UserProfile(
          username: data['username'],
          uid: data['uid'],
          image_url: data['image_url'],
          researcher_id: data['researcher_id'],
          group: data['group'],
          friends: data['friends'],
          contact_no: data['contact_no']);
    }
    return null;
  }

}