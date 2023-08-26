import 'package:car_app/screens/MainScreen.dart';
import 'package:car_app/services/user_service.dart';
import 'package:flutter/material.dart';

import '../helpers/theme_helper.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDDDD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/test.png'), // Replace this with your logo SVG file
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Pn ID',
                  prefixIcon: Icon(Icons.numbers),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Passord',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  validateLogin(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeHelper.buttonPrimaryColor,
                  minimumSize: Size(double.infinity, 40)
                ),
                child: Text('Logg Inn'.toUpperCase(), style: TextStyle(fontSize: 18)),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void validateLogin(BuildContext context) async{
    bool isLogged = await UserServices.login(email: _emailController.text, password: _passwordController.text);
    if(isLogged){
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen())
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kunne ikke logge på'))
      );
    }
  }
}
