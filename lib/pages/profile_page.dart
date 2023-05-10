import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';
import 'auth/login_page.dart';
import 'home_page.dart';
class ProfilePage extends StatefulWidget {
  String userName;
  String userEmail;
   ProfilePage({Key? key,required this.userName,required this.userEmail}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService=AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
        centerTitle: true ,
        title: const Text("Profile",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          children: [
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey.shade700,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              leading: Icon(Icons.group),
              selectedColor: Theme.of(context).primaryColor,
              title:
              const Text('Groups', style: TextStyle(color: Colors.black)),
              onTap: () {
                nextScreen(context, Homepage());
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              selected: true,
              selectedColor: Theme.of(context).primaryColor,
              title:
              const Text('Profile', style: TextStyle(color: Colors.black)),
              onTap: () {
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_rounded),
              selected: false,
              selectedColor: Theme.of(context).primaryColor,
              title:
              const Text('Logout', style: TextStyle(color: Colors.black)),
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Logout"),
                        content: Text("Are you sure you want to logout?"),
                        actions: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red, // Background color
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel")),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0,left: 5),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green, // Background color
                                ),
                                onPressed: () {
                                  authService.signOut().whenComplete(() {
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const LoginPage()), (route) => false);
                                  });
                                },
                                child: Text("Confirm")),
                          )
                        ],
                      );
                    });
              },
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50,vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.account_circle,size: 200,),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment:  MainAxisAlignment.spaceBetween,
              children: [
                const Text("Username:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                Text(widget.userName,style: TextStyle(fontSize: 17)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment:  MainAxisAlignment.spaceBetween,
              children: [
                Text("Email:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                Text(widget.userEmail,style: TextStyle(fontSize: 17)),
              ],
            )
          ],
        ),
      ),
      );
  }
}
