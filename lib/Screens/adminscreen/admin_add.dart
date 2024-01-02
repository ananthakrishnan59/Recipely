// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipely/screens/adminscreen/admin_gridview.dart';
import 'package:recipely/datas/hive_db.dart';
import 'package:recipely/models/model_recipe.dart';
import 'package:recipely/util/refactory.dart';

class Addingscreen extends StatefulWidget {
  const Addingscreen({Key? key}) : super(key: key);

  @override
  State<Addingscreen> createState() => _AddingscreenState();
}

File? selectedImage;
String category = "Indian";
List<String> categories = [
  "Indian",
  "Chinese",
  "Italian",
  "Mexican",
  "Burgers",
  "Salads",
  "Fries",
  "Arabian"
]; // List of categories

class _AddingscreenState extends State<Addingscreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController proceduresController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1EDEC7),
        centerTitle: true,
        title: Text(
          'Welcome Admin',
          style: GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      image: selectedImage == null
                          ? null
                          : DecorationImage(
                              image: FileImage(selectedImage!),
                              fit: BoxFit.cover,
                            ),
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(255, 205, 202, 202),
                    ),
                    child: selectedImage == null
                        ? IconButton(
                            onPressed: () async {
                              File? selectedImages =
                                  await selectImageFromGallery(context);
                              setState(() {
                                selectedImage = selectedImages;
                              });
                            },
                            icon: const Icon(Icons.add_a_photo),
                          )
                        : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    TextFormFieldWidget(
                        controller: titleController,
                        hintText: "Title",
                        labelText: "Title",validator:(value) {
                      if (value == null || value.isEmpty) {
                        return 'Title is required';
                        }
                        return null;
                           }, ),
                    const SizedBox(height: 20),
                    TextFormFieldWidget(
                        controller: timeController,
                        hintText: "Time",
                        labelText: "Time",validator: (value) {
                         if (value == null || value.isEmpty) {
                         return 'Time is required';
                       }
                          return null;
                       },),
                    const SizedBox(height: 20),
                    TextFormFieldWidget(
                        controller: descriptionController,
                        maxLines: null,validator:  (value) {
                           if (value == null || value.isEmpty) {
                         return 'Description is required';
                         }
                        return null;
                         },
                        hintText: "Description",
                        labelText: "Description"),
                    const SizedBox(height: 20),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Categories",
                      ),
                      items: categories.map((String category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        categoryController.text = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldWidget(
                        controller: ingredientsController,
                        hintText: "Incredients",maxLines: null,
                        labelText: "Incredients",validator: (value) {
                       if (value == null || value.isEmpty) {
                       return 'Incredients is required';
        }
                  return null;
                  },),
                    const SizedBox(height: 20),
                    TextFormFieldWidget(
                        controller: proceduresController,maxLines: null,
                        hintText: "Procedure",
                        labelText: "Procedure",validator: (value) {
                   if (value == null || value.isEmpty) {
                 return 'Procedure is required';
                    }
        return null;
      },),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Color(0xFF1EDEC7))),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    if (selectedImage != null) {
                      final variableReceipes = Recipes(
                        title: titleController.text,
                        time: timeController.text,
                        description: descriptionController.text,
                        category: categoryController.text,
                        procedure: proceduresController.text,
                        // Use an empty string if selectImage is null
                        photo: selectedImage?.path ?? '',
                        incredients: ingredientsController.text,
                        // favoritesUserIds: [],
                        // ProfileImage: _image?.path ?? "",
                      );

                      addRecipe(variableReceipes);

                      titleController.clear();

                      timeController.clear();
                      descriptionController.clear();
                      categoryController.clear();
                      ingredientsController.clear();
                      proceduresController.clear();
                      selectedImage = null;
                    }
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Admingridview(),
                    ));
                  } else {
                    snackbarFunction(context, "Datas uploaded successfully ",
                        Colors.amberAccent);
                    setState(() {
                      selectedImage = null;
                    });
                  }
                },
                child: Text(
                  'Add',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void snackbarFunction(
      BuildContext context, String s, MaterialAccentColor redAccent) {}
}



Future<File?> selectImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    snackBarImage(e.toString(), context);
  }
  return image;
}

void snackBarImage(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

void snackBarFunction(BuildContext context, String content, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
    backgroundColor: color,
  ));
}
