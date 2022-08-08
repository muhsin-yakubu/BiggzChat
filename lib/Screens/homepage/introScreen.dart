import 'package:fiberchat/Configs/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            // color: Colors.green,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png' , width: 150,),
                Center(
                  child: Text('Welcome to BigChat' , style: TextStyle(color: Colors.deepPurpleAccent , fontWeight: FontWeight.bold , fontSize: 20),),
                ),

                SizedBox(height: 19.6,),


                Container(
                  height: 90,
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Tap ',
                          style: TextStyle(color: Colors.black),
                          children: const <TextSpan>[
                            TextSpan(text: '"Start Messaging"', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ' to accept the'),
                          ],
                        ),
                      ),

                      RichText(
                        text: TextSpan(
                          text: 'BigChat  ',
                          style: TextStyle(color: Colors.black),
                          children: const <TextSpan>[
                            TextSpan(text: 'Terms of Service', style: TextStyle(color: Colors.pink)),
                            TextSpan(text: ' and'),
                            TextSpan(text: ' Privacy' , style: TextStyle(color: Colors.pink)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            // height: 160,
            child: Column(
              children: [
                InkWell(

                  onTap: (){
                    Navigator.of(context).pop();
                  },

                  child: Container(
                    padding: EdgeInsets.all(15),
                    color: Color(0xFF0D6695),
                    alignment: Alignment.center,
                    child: Text('Log In' , style: TextStyle(color: Colors.white , fontSize: 20),),
                  ),
                ),

                InkWell(

                  onTap: (){
                    Navigator.of(context).pop();
                  },

                  child: Container(
                    padding: EdgeInsets.all(15),
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: Text('Sign Up' , style: TextStyle(color: Colors.white , fontSize: 20),),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
