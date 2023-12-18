import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:recipely/adminscreen/admin_page.dart';
import 'package:recipely/loginpage/signup_screen.dart';
import 'package:recipely/models/user_model.dart';
import 'package:recipely/userhome/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  bool _passwordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String _errorText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(
              height: 70,
            ),
            Text(
              'Welcome Back!',
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 23),
            ),
            Lottie.asset('assets/images/adminlogin.json', height: 340),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'EMAIL',
                        errorText: _errorText.isNotEmpty ? _errorText : null,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        if (!value.contains("@gmail.com")) {
                          return "please enter your valid Email";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  Material(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          labelText: 'PASSWORD',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            icon: Icon(_passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          errorText: _errorText.isNotEmpty ? _errorText : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => const AdminLogin())));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 250),
                        child: Text(
                          "Admin module",
                          style: GoogleFonts.poppins(
                              color: const Color(0xFF1EDEC7), fontSize: 10),
                        ),
                      )),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          ////// Check if the user exists in Hive//////
                          // var usersBox = Hive.box<User>('users');
                          final usersBox = await Hive.openBox<User>('users');
                          User? user;
                          try {
                            user = usersBox.values.firstWhere(
                              (user) => user.email == emailController.text,
                            );
                          } catch (e) {
                            setState(() {
                              _errorText = 'Invalid username or password';
                            });
                            return;
                          }

                          if (user.email == emailController.text &&
                              user.password == passwordController.text) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool('isLoggedIn', true);
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                     Bottomnavigationscreen(userEmailId: emailController.text),
                              ),
                            );
                            //  snackbar
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Welcome, ${user.username}!'),
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            setState(() {
                              _errorText = 'Invalid username or password';
                            });
                          }
                        } else {
                          setState(() {
                            _errorText =
                                'Please fill in both username and password';
                          });
                        }
                      },
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Color(0xFF1EDEC7))),
                      child: const Text('LOG IN'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()),
                      );
                    },
                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(color: Color.fromARGB(255, 21, 67, 105)),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
