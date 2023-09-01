// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_series/screens/email_auth/login_screen.dart';
import 'package:firebase_series/utils.dart';
import 'package:firebase_series/widgets/my_text_field.dart';
import 'package:firebase_series/widgets/round_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  File? profilePicture;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase-Series'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
              onPressed: () {
                logOut();
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black12, width: 4),
                        ),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              backgroundImage: (profilePicture != null)
                                  ? FileImage(profilePicture!)
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade400,
                                ),
                                child: const Icon(
                                  Icons.file_upload_outlined,
                                  size: 35,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    MyTextField(
                        name: 'Name',
                        controller: nameController,
                        hintText: 'Enter Name',
                        icon: Icons.person_2_rounded,
                        keyboardType: TextInputType.name),
                    MyTextField(
                        name: 'Email',
                        controller: emailController,
                        hintText: 'Enter Email',
                        icon: Icons.email_rounded,
                        keyboardType: TextInputType.emailAddress),
                    MyTextField(
                        name: 'Age',
                        controller: ageController,
                        hintText: 'Enter Age',
                        icon: CupertinoIcons.person_2,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 20),
                    RoundButton(
                        title: 'Save',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            saveUser();
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .snapshots(), //snapshots gives realtime data.
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  debugPrint('ConnectionStateIsActive');
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.docs.isNotEmpty) {
                    debugPrint('Snapshot has data.');
                    return RefreshIndicator(
                        key: _refreshIndicatorKey,
                        onRefresh: () async {
                          // Replace this delay with the code to be executed during refresh
                          // and return a Future when code finishes execution.
                          return Future<void>.delayed(
                              const Duration(seconds: 3));
                        },
                        child: ListView.builder(
                            // shrinkWrap: true,
                            // physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> userMap =
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;
                              return Card(
                                  child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            userMap["profilePicture"]),
                                      ),
                                      title: Text(userMap["name"] +
                                          " (${userMap["age"]})"),
                                      subtitle: Text(userMap["email"]),
                                      trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {},
                                            ),
                                            // Adjust the spacing between icons if needed
                                            IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () {
                                                  try {
                                                    FirebaseFirestore.instance
                                                        .collection("users")
                                                        .doc(snapshot.data!
                                                            .docs[index].id)
                                                        .delete();
                                                    Utils().toastMessage(
                                                        "User Deleted Successfully!");
                                                  } catch (error) {
                                                    Utils().toastMessage(
                                                        error.toString());
                                                  }
                                                })
                                          ])));
                            }));
                  } else {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Image(
                            image: AssetImage('assets/images/nodata.PNG')),
                      ),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const LoginScreen(),
        ));
  }

  void saveUser() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String stringAge = ageController.text.trim();

    int age = int.parse(stringAge);

    try {
      if (profilePicture == null) {
        Utils().toastMessage("Please select the image first!");
      } else {
        UploadTask uploadTask = FirebaseStorage.instance
            .ref() //this is the complete dashboard.
            .child(
                "Profile-Pictures") //this makes a folder in FirebaseStorage using .child().
            .child(const Uuid()
                .v1()) //this is actual file not a folder because putfile lagaya hai iske aage.
            .putFile(profilePicture!);

        //to check that how much the file is being uploaded.

        // StreamSubscription taskSubscription =
        //     uploadTask.snapshotEvents.listen((event) {
        //   double percentageOfImageUploaded =
        //       event.bytesTransferred / event.totalBytes * 100;
        //   log(percentageOfImageUploaded.toString() as num);
        // });

        //After running and finishing the uploadTask, we get TaskSnapshot
        TaskSnapshot taskSnapshot = await uploadTask;
        //to get the downloaded URL
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        //taskSubscription.cancel();
        Map<String, dynamic> userData = {
          "name": name,
          "email": email,
          "age": age,
          "profilePicture": downloadUrl
        };
        await FirebaseFirestore.instance.collection("users").add(userData);
        Utils().toastMessage("User Added Successfully!");
        debugPrint("User Added Successfully!");
        setState(() {
          nameController.clear();
          emailController.clear();
          ageController.clear();
          profilePicture = null;
        });
      }
    } catch (error) {
      Utils().toastMessage(error.toString());
      debugPrint("User did notAdded Successfully!");
    }
  }

  pickImage() async {
    XFile? selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    //Converted XFile into File

    if (selectedImage != null) {
      File convertedFile = File(selectedImage.path);
      setState(() {
        profilePicture = convertedFile;
      });
      Utils().toastMessage("Image selected Successfully!");
    } else {
      Utils().toastMessage("No Image selected.");
    }
  }
}
