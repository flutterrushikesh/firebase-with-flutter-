import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:player_info/model/player_model.dart';
import 'package:player_info/view/login_screen.dart';
import 'package:player_info/view/session_data.dart';

class PlayerDataScreen extends StatefulWidget {
  const PlayerDataScreen({super.key});

  @override
  State<PlayerDataScreen> createState() => _PlayerDataScreenState();
}

class _PlayerDataScreenState extends State<PlayerDataScreen> {
  TextEditingController playerNameController = TextEditingController();
  TextEditingController jerseyNoController = TextEditingController();

  String? id;

  final ImagePicker _imagePicker = ImagePicker();

  XFile? selectedImage;
  List<PlayerModel> listOfPlayer = [];

  bool isUpdateDate = false;

  bool isAddLoading = false;
  bool isGetLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    listOfPlayer.clear();
    QuerySnapshot response =
        await FirebaseFirestore.instance.collection('Player Info').get();
    for (int i = 0; i < response.docs.length; i++) {
      listOfPlayer.add(
        PlayerModel(
          id: response.docs[i].id,
          jNo: response.docs[i]['jNo'],
          pName: response.docs[i]['pName'],
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Players Info",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();

              SessionData.setSessionData(setLogin: false);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                selectedImage =
                    await _imagePicker.pickImage(source: ImageSource.gallery);
                setState(() {});
              },
              child: CircleAvatar(
                radius: 70,
                foregroundImage: (selectedImage == null)
                    ? const AssetImage('assets/images/profile.jpeg')
                    : FileImage(File(selectedImage!.path)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: playerNameController,
              decoration: const InputDecoration(
                hintText: "Enter Player Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: jerseyNoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Jersey No.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  isAddLoading = true;
                  setState(() {});
                  if (isUpdateDate) {
                    FirebaseFirestore.instance
                        .collection('Player Info')
                        .doc(id)
                        .update(
                      {
                        'pName': playerNameController.text.trim(),
                        'jNo': jerseyNoController.text.trim(),
                      },
                    );
                    playerNameController.clear();
                    jerseyNoController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Update Successfully"),
                      ),
                    );
                    getData();
                    isUpdateDate = false;
                    setState(() {});
                  } else {
                    if (playerNameController.text.trim().isNotEmpty &&
                        jerseyNoController.text.trim().isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection("Player Info")
                          .add({
                        'pName': playerNameController.text.trim(),
                        'jNo': jerseyNoController.text.trim(),
                      });
                      playerNameController.clear();
                      jerseyNoController.clear();
                      listOfPlayer.clear();

                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Data Added"),
                        ),
                      );
                      listOfPlayer.clear();
                      QuerySnapshot response = await FirebaseFirestore.instance
                          .collection('Player Info')
                          .get();
                      for (int i = 0; i < response.docs.length; i++) {
                        listOfPlayer.add(
                          PlayerModel(
                            id: response.docs[i].id,
                            jNo: response.docs[i]['jNo'],
                            pName: response.docs[i]['pName'],
                          ),
                        );
                      }
                      setState(() {});
                      // setState() {}
                      ;
                    }
                  }

                  setState(() {});
                  isAddLoading = false;
                },
                style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.all(8)),
                  backgroundColor: WidgetStatePropertyAll(Colors.blue),
                  minimumSize: WidgetStatePropertyAll(
                    Size(double.infinity, 40),
                  ),
                ),
                child: isAddLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : isUpdateDate
                        ? const Text(
                            "Update data",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )
                        : const Text(
                            "Add data",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listOfPlayer.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              listOfPlayer[index].pName,
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              listOfPlayer[index].jNo,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            await FirebaseFirestore.instance
                                .collection('Player Info')
                                .doc(listOfPlayer[index].id)
                                .delete();
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "${listOfPlayer[index].pName} deleted successfully",
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                            listOfPlayer.removeAt(index);
                            setState(() {});
                          },
                          child: const Icon(Icons.delete),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: () async {
                              isUpdateDate = true;
                              setState(() {});
                              QuerySnapshot response = await FirebaseFirestore
                                  .instance
                                  .collection('Player Info')
                                  .get();

                              id = response.docs[index].id;
                              playerNameController.text =
                                  response.docs[index]['pName'];
                              jerseyNoController.text =
                                  response.docs[index]['jNo'];
                              setState(() {});
                            },
                            child: const Icon(Icons.edit)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
