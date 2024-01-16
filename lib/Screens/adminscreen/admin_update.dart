// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipely/screens/adminscreen/admin_gridview.dart';
import 'package:recipely/datas/hive_db.dart';
import 'package:recipely/models/model_recipe.dart';
import 'package:recipely/util/refactory.dart';

class Updatescrren extends StatefulWidget {
  const Updatescrren({Key? key, required this.reciepeOfIndexForEditng, required this.docid})
      : super(key: key);
  final Recipes reciepeOfIndexForEditng;
  final String docid;
  @override
  State<Updatescrren> createState() => _AddingscreenState();
}

List<File>? selectedImage = [];
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

class _AddingscreenState extends State<Updatescrren> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController titleController = TextEditingController();
  late TextEditingController timeController = TextEditingController();
  late TextEditingController categoryController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();
  late TextEditingController ingredientsController = TextEditingController();
  late TextEditingController proceduresController = TextEditingController();

  @override
  void initState() {
    selectedImage =
        widget.reciepeOfIndexForEditng.photo.map((e) => File(e)).toList();
    titleController =
        TextEditingController(text: widget.reciepeOfIndexForEditng.title);
    timeController = TextEditingController(
        text: widget.reciepeOfIndexForEditng.time.toString());
    categoryController =
        TextEditingController(text: widget.reciepeOfIndexForEditng.category);
    descriptionController =
        TextEditingController(text: widget.reciepeOfIndexForEditng.description);
    ingredientsController =
        TextEditingController(text: widget.reciepeOfIndexForEditng.incredients);
    proceduresController =
        TextEditingController(text: widget.reciepeOfIndexForEditng.procedure);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1EDEC7),
        centerTitle: true,
        title: Text(
          ' Update',
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
                  child: SizedBox(
                    width: 160,
                    height: 160,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Display the selected image or show an icon to add a photo
                          selectedImage == null
                              ? IconButton(
                                  onPressed: () async {
                                    final images =
                                        await selectImageFromGallery(context);
                                    if (images != null) {
                                      setState(() {
                                        selectedImage = images;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.add_a_photo),
                                )
                              : Image.file(
                                  selectedImage![0],
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                          // You can add an edit icon or button here
                          // This is just an example; customize it as needed
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: InkWell(
                              onTap: () async {
                                final images =
                                    await selectImageFromGallery(context);
                                setState(() {
                                  selectedImage = images;
                                });
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    TextFormFieldWidget(
                      controller: titleController,
                      hintText: "Title",
                      labelText: "Title",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldWidget(
                      controller: timeController,
                      hintText: "Time",
                      labelText: "Time",
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Time is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldWidget(
                        controller: descriptionController,
                        maxLines: null,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Description is required';
                          }
                          return null;
                        },
                        hintText: "Description",
                        labelText: "Description"),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 350,
                      child: DropdownButtonFormField(
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
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldWidget(
                      controller: ingredientsController,
                      hintText: "Incredients",
                      maxLines: null,
                      labelText: "Incredients",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Incredients is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldWidget(
                      controller: proceduresController,
                      maxLines: null,
                      hintText: "Procedure",
                      labelText: "Procedure",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Procedure is required';
                        }
                        return null;
                      },
                    ),
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
                      print(categoryController.text);
                      final variableReceipes = Recipes(
                          timeKey: widget.reciepeOfIndexForEditng.timeKey,
                          title: titleController.text,
                          time: int.parse(timeController.text),
                          description: descriptionController.text,
                          category: categoryController.text,
                          procedure: proceduresController.text,
                          // Use an empty string if selectImage is null
                          photo: selectedImage!.map((e) => e.path).toList(),
                          incredients: ingredientsController.text,
                          favoritesUserIds:
                              widget.reciepeOfIndexForEditng.favoritesUserIds
                          // favoritesUserIds: [],
                          // ProfileImage: _image?.path ?? "",
                          );
                      Map<String, dynamic> dataToUpdate = {
                        'title': titleController.text,
                        'time': int.parse(timeController.text),
                        'description': descriptionController.text,
                        'category': categoryController.text,
                        'procedure': proceduresController.text,
                        // Use an empty string if selectImage is null
                        'photo': selectedImage!.map((e) => e!.path).toList(),
                        'incredients': ingredientsController.text,
                        'favoritesUserIds': [], 'docid': widget.docid,
                      };
                      updateRecipe(variableReceipes,
                          widget.reciepeOfIndexForEditng.timeKey ?? '');
                      updateDocument(widget.docid, dataToUpdate);
                      titleController.clear();

                      timeController.clear();
                      descriptionController.clear();
                      categoryController.clear();
                      ingredientsController.clear();
                      proceduresController.clear();
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
                  'update',
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

Future<List<File>?> selectImageFromGallery(BuildContext context) async {
  try {
    final pickedImage = await ImagePicker().pickMultiImage();
    if (pickedImage.isEmpty) {
      return null;
    }
    return pickedImage.map((e) => File(e.path)).toList();
  } catch (e) {
    snackBarImage(e.toString(), context);
  }
  return null;
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

void updateDocument(String documentId, Map<String, dynamic> dataToUpdate) {
  FirebaseFirestore.instance
      .collection('Recipies')
      .doc(documentId)
      .update(dataToUpdate);
}
