import 'package:flutter/material.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constant.dart';
import 'package:brew_crew/shared/loading.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthServices _auth=AuthServices();
  final _formKey=GlobalKey<FormState>();
  bool loading=false;

  //text field state
  String email='';
  String password='';
  String error='';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign up to Brew Crew'),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person,color: Colors.black,),
            label: Text('Sign In',style: TextStyle(color: Colors.black),),
            onPressed: () {
              widget.toggleView();
            },
          ),
        ],
      ),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val==null || val.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() {email=val;});
                  },
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  obscureText: true,
                  validator: (val) => val==null || val.length<6 ? 'Enter a password 6+ chars long' : null,
                  onChanged: (val) {
                    setState(() {password=val;});
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[400],
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async{
                    if(_formKey.currentState?.validate()==true){
                      setState(() => loading=true);
                      dynamic result=await _auth.registerWithEmailAndPassword(email,password);
                      if(result==null){
                        setState(() {
                          error='Please provide a valid email';
                          loading=false;
                        });
                      }
                    }
                  },
                ),
                SizedBox(height: 12.0,),
                Text(
                  error,
                  style: TextStyle(color: Colors.red,fontSize: 14.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}