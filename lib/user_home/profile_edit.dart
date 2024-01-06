import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipely/datas/hive_db.dart';
import 'package:recipely/models/user_model.dart';
import 'package:recipely/screens/adminscreen/admin_add.dart';
import 'package:recipely/user_home/profile_page.dart';
import 'package:recipely/util/user_profile_ref.dart';


class UserProfileEdit extends StatefulWidget {
  final User? userdetails;
  final int? index;
  const UserProfileEdit(
      {super.key, required this.userdetails, required this.index});

  @override
  State<UserProfileEdit> createState() => _UserProfileEditState();
}

class _UserProfileEditState extends State<UserProfileEdit> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController namecontroller;

  late TextEditingController emailcontroller;

  late TextEditingController passwordcontroller;

  File? _selectedImage;

RegExp get _emailRegex => RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

  RegExp get _nameRegex => RegExp(r'^[a-zA-Z ]+$');
  RegExp get _passwordRegex => RegExp(r'^(?=.*[0-9].*[0-9].*[0-9])[0-9]+$');
  late Box userBox;
  @override
  void initState() {
    super.initState();
    userBox = Hive.box<User>('users');
    namecontroller = TextEditingController(text: widget.userdetails!.username);
    emailcontroller = TextEditingController(text: widget.userdetails!.email);
    passwordcontroller =
        TextEditingController(text: widget.userdetails!.password.toString());
    _selectedImage = widget.userdetails?.image != null
        ? File(widget.userdetails!.image??'')
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: const Color(0xFF1EDEC7),
          title: const Padding(
            padding: EdgeInsets.only(left: 60),
            child: Text(
              'Edit Profile',
              style: TextStyle(fontSize: 20),
            ),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    maxRadius: 60,
                    child: GestureDetector(
                        onTap: () async {
                          File? selectedImages =
                              await selectImageFromGallery(context);
                          setState(() {
                            _selectedImage = selectedImages;
                          });
                        },
                        child: _selectedImage != null
                            ? ClipOval(
                                child: Image.file(
                                  File(_selectedImage!.path),
                                  fit: BoxFit.cover,
                                  width: 140,
                                  height: 140,
                                ),
                              )
                            : const Icon(
                                Icons.person_add,
                                color: Colors.black,
                              )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _selectedImage != null ? 'Edit Image' : 'Add Image',
                    style: GoogleFonts.ubuntu(
                        textStyle:
                            const TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                ),
                textformfieldUserEdit('Name', namecontroller, _nameRegex,
                    'Name is required', 'Name only contain alphabets'),
                textformfieldUserEdit('Email', emailcontroller, _emailRegex,
                    'Email is required', 'Enter a valid Email !'),
                textformfieldUserEdit(
                    'Password',
                    passwordcontroller,
                    _passwordRegex,
                    'Password is Needed !',
                    'Password contain atleast 3 charecters'),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30, top: 50),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300, 50),
                        backgroundColor: const Color(0xFF1EDEC7)),
                    onPressed: () {
                      validate();
                    },
                    child: Text('Save',
                        style: GoogleFonts.ubuntu(
                            textStyle: const TextStyle(fontSize: 20),
                            color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

validate() {
  final isvalid = _formKey.currentState?.validate();
  if (isvalid!) {
    final value = User(
      image: _selectedImage?.path ?? '', 
      username: namecontroller.text.trim(),
      email: emailcontroller.text,
      password: passwordcontroller.text.trim(),
    );

    updateUserInDb(value, widget.index!);

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) {
      return const UserProfileScreen();
    }));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully Update'),
      backgroundColor: Colors.green,
    ));
  }
}

}
