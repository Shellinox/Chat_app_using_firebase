import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

//  Reference to collection
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("Users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("Groups");
//  saving user data
  Future savingUserData(String name, String email) async {
    return await userCollection.doc(uid).set({
      "Fullname": name,
      "Email": email,
      "Groups": [],
      "ProfilePic": " ",
      "Uid": uid
    });
  }

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("Email", isEqualTo: email).get();
    return snapshot;
  }

//Getting user Groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  Future createGroup(String username, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "GroupName": groupName,
      "GroupIcon": "",
      "Admin": "${id}_$username",
      "Members": [],
      "GroupID": "",
      "RecentMessage": "",
      "RecentMessageSender": ""
    });
    //update the members
    await groupDocumentReference.update({
      "Members": FieldValue.arrayUnion(["${uid}_$username"]),
      "GroupID": groupDocumentReference.id
    });
    DocumentReference useDocumentReference = userCollection.doc(uid);
    return await useDocumentReference.update({
      "Groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
    }
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection('Messages')
        .orderBy("Time")
        .snapshots();
  }
  Future getGroupAdmin(String groupId) async{
    DocumentReference d=groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot=await d.get();
    return documentSnapshot['Admin'];
  }
//  get group members
getGroupMembers(String groupId) async{
    return groupCollection.doc(groupId).snapshots();
}
//search
searchByName(String groupName){
    return groupCollection.where('GroupName',isEqualTo: groupName).get();
}
//user Joined or not
Future<bool> isUserJoined(String groupName,String groupId,String userName)async{
    DocumentReference userDocReference=userCollection.doc(uid);
    DocumentSnapshot documentSnapshot=await userDocReference.get();
   List<dynamic> groups = await documentSnapshot["Groups"];
   if(groups.contains("${groupId}_$groupName")){
     return true;
   }
   else{
     return false;
   }
}
//toggle Group Join
Future toggleGroupJoin(String groupId,String userName, String groupName) async {
  //doc reference
  DocumentReference userDocReference = userCollection.doc(uid);
  DocumentReference groupDocReference = groupCollection.doc(groupId);
  DocumentSnapshot documentSnapshot = await userDocReference.get();
  List<dynamic> groups = await documentSnapshot["Groups"];
//  if user in in group remove or add
  if (groups.contains("${groupId}_$groupName")) {
    await userDocReference.update({
      "Groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
    });
    await groupDocReference.update({
      "Members": FieldValue.arrayRemove(["${uid}_$userName"])
    });
  }
  else{
    await userDocReference.update({
      "Groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
    });
    await groupDocReference.update({
      "Members": FieldValue.arrayUnion(["${uid}_$userName"])
    });
  }
}
}
