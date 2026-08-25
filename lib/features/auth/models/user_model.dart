class UserModel{
  final String uid;
  final String email;
  final String token;

  UserModel({required this.uid, required this.email, required this.token});

  // Convert Model to Map for secure local persistence
  Map<String, dynamic> toMap(){
    return {
      "uid":uid,
      "email":email,
      "token":token
    };
  }

  // Parse Map back to Model upon initialization
  factory UserModel.fromMap(Map<String,dynamic> map){
    return UserModel(
        uid: map['uid']??'',
        email: map['email']??'',
        token: map['token']??'',
    );
  }
}