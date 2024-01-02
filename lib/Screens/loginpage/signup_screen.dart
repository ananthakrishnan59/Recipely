import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:recipely/screens/loginpage/login_page.dart';
import 'package:recipely/models/user_model.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _passwordVisible = false;bool _cpasswordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  String _userEmailError = '';
  String _passwordError = '';
  String _confirmPasswordError = '';
  String _usernameError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text('Sign up to continue',
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 23)),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Lottie.asset('assets/images/sign up.json')),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: userNameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          errorText:
                              _usernameError.isNotEmpty ? _usernameError : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Username';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 27),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'EMAIL',
                          errorText: _userEmailError.isNotEmpty
                              ? _userEmailError
                              : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Email';
                          }
                          if (!value.contains("@gmail.com")) {
                            return "please enter your valid Email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 27),
                      TextFormField( 
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
                          errorText:
                              _passwordError.isNotEmpty ? _passwordError : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 27),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText:! _cpasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'CONFIRM PASSWORD',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _cpasswordVisible = !_cpasswordVisible;
                              });
                            },
                            icon: Icon(_cpasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          errorText: _confirmPasswordError.isNotEmpty
                              ? _confirmPasswordError
                              : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 27),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _usernameError = userNameController.text.isEmpty
                                ? 'Please enter your username'
                                : '';
                            _userEmailError = emailController.text.isEmpty
                                ? 'Please enter your Email Id'
                                : '';
                            _passwordError = passwordController.text.isEmpty
                                ? 'Please enter your password'
                                : '';
                            _confirmPasswordError =
                                confirmPasswordController.text.isEmpty
                                    ? 'Please confirm your password'
                                    : (confirmPasswordController.text !=
                                            passwordController.text
                                        ? 'Passwords do not match'
                                        : '');

                            if (_formKey.currentState!.validate()) {
                              // Generate a unique id for the user
                              String userId = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();

                              // Create a new User object
                              User newUser = User(
                                  username: userNameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  id: userId);

                              // Save the user to Hive
                              var usersBox = Hive.box<User>('users');
                              usersBox.put(userId, newUser);

                              // Show snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Signed up successfully!',
                                  ),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>const Loginpage(),
                              ));
                            }
                          });
                        },
                        child: const Text('SIGN UP'),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF1EDEC7),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
