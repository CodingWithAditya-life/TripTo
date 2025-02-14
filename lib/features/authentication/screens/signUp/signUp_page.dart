import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tripto/features/authentication/screens/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    final _auth = AuthService();
    TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp Page'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                "Enter your Number",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                    hintText: "+91",
                    fillColor: Colors.grey,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
          
              SizedBox(height: 10,),
              ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor: Color(0xFF8FD8F8),foregroundColor:Colors.black),
                  onPressed: () {
          
              }, child: Text("Continue",)),
              Row(
                children: [
                  Divider(
                    height: 40,
                    thickness: 1,
                  ),
                  Text('or'),
                  Divider(
                    height: 40,
                    thickness: 1,
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton.icon(icon: Icon(Icons.ac_unit), style:ElevatedButton.styleFrom(backgroundColor: Color(0xFF8FD8F8),foregroundColor:Colors.black),
                      onPressed: () async{
                  await _auth.logInWithGoogle();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Scaffold()));
                      }, label: Text("Continue with"),
                      ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
