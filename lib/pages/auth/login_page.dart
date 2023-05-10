import 'package:chat_app/pages/auth/register_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email="";
  String password="";
  bool _isLoading=false;
  AuthService authService=AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,)):SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 80),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Chatter",
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Box",
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Join the convo about your favourite topics!!",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                  ),
                  Image.asset("lib/assets/images/login.png"),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email_outlined,color: Theme.of(context).primaryColor,),
                    ),
                    onChanged: (val){
                      setState(() {
                        email=val;
                      });
                    },
                    validator: (val){
                      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!)? null : "Please enter a valid email";
                    },
                  ),
                  SizedBox(height: 15,),
                  TextFormField(
                    obscureText: true,
                    decoration: textInputDecoration.copyWith(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.password_sharp,color: Theme.of(context).primaryColor,),
                    ),
                    onChanged: (val){
                      setState(() {
                        password=val;
                      });
                    },
                    validator: (val){
                      if(val!.length<6){
                        return "Password must be at least 6 characters";
                      }
                      else{
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 15,),
                  GestureDetector(
                    onTap: (){
                      login();
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(6)),
                      child: const Center(
                        child: Text(
                          "Sign in",
                          style: (TextStyle(color: Colors.white,fontSize: 16)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          child: GestureDetector(
                            onTap: () {
                              nextScreen(context, const RegisterPage());
                            },
                            child:  Text(
                              "Register here",
                              style: (TextStyle(
                                  color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );

  }
  login()async{
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.login(email, password).then((value)async{
        if(value==true){
         QuerySnapshot snapshot= await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);
          //saving user data
         await HelperFunctions.saveUserLoginStatus(true);
         await HelperFunctions.saveUserEmail(email);
         HelperFunctions.saveUserName(snapshot.docs[0]['Fullname']);
          nextScreenReplacement(context, Homepage());
        }
        else{
          setState(() {
            showSnackBar(context, Colors.red, value);
            _isLoading=false;
          });
        }
      });
    }
  }
}
