
import 'package:ai_quizitive/bits/signin_button.dart';
import 'package:ai_quizitive/bits/square_tile.dart';
import 'package:ai_quizitive/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ai_quizitive/bits/textfield.dart';
class SignUpPage extends StatefulWidget{

  final Function()? onTap;
   const SignUpPage ({super.key, required this.onTap });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final unameController = TextEditingController();

  final pwdController = TextEditingController();
  final confirmPwdController = TextEditingController();
  //sign up method
  void userSignIn() async{
//loading
   showDialog(  
    context: context, 
    builder: (context){
      return const Center(
        child: CircularProgressIndicator()
        ,);});
    try{
      if(pwdController.text == confirmPwdController.text){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: unameController.text, 
      password: pwdController.text);
      }else {
        showErrorMsg("Passwords don't match");

      }
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: unameController.text, 
      password: pwdController.text);


      //loading circle pop
    //  Navigator.pop(context);
       } on FirebaseAuthException catch (e){
       //Navigator.pop(context);
          showErrorMsg(e.code);
        
       }
      
  }
 
  void showErrorMsg(String message){
    showDialog(
      context: context, 
      builder: (context) {
     return  AlertDialog(
      backgroundColor: Color.fromARGB(255, 243, 115, 106),
      title: Center(
        child: Text(message,
        style: const TextStyle(color: Colors.white),
        ),
        

      ),);
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body:SafeArea(     
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                 const SizedBox(height: 30),
            
                //logo
                const Icon(
                  Icons.question_mark_outlined,
                  size: 100,
                  ),
                  const SizedBox(height: 30),
            
                //welcome back
                  const Text('Ready to ace that test?',
                  style :TextStyle(color: Colors.black,
                  fontSize: 14,
                  ),),
                  const SizedBox(height: 20),
                //username field
                
            
                TheTextfield(controller: unameController, hintText: 'Username', obscureText: false),
              
                const SizedBox(height: 15),
                //pasword textfield
                TheTextfield(
                  controller: pwdController, 
                  hintText: 'Password', 
                  obscureText: true),
                const SizedBox(height: 15),
                //confirm password
                TheTextfield(
                controller: confirmPwdController,
                 hintText: 'Confirm Password',
                 obscureText: true),
                  
                const SizedBox(height: 15),
                //sign in button
                SigninButton(
                  text: 'Sign Up',
                  onTap: userSignIn
                  ),
                 const SizedBox(height: 15),
                //or continue with
                const Padding(
                  padding:  EdgeInsets.symmetric(),
                  child: Text(
                    "Sign In with",
                    style: TextStyle(color:Colors.black),
                  ),),
                const SizedBox(height: 35),
            
                //google + apple sign in button
               Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  //google button
                  
                  SquareTile(
                    onTap: () => AuthService().signInWithGoogle(),
                    imagePath: 'lib/images/google.png'),
                    SizedBox(width: 15),
                  //apple button
                  SquareTile(
                    onTap: (){},
                    imagePath: 'lib/images/applethe.png')
            
            
                ],),
            
                //register now
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  const  Text('Already have an account?',
                    style: TextStyle(color: Colors.black),
                    ),
                  const  SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text('Login now',
                      style: TextStyle(
                        color: Colors.blueAccent, fontWeight: FontWeight.bold
                      ),),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),

    );
  }
}