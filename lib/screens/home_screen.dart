import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:app_hive/constants.dart';
import 'package:app_hive/models/note_model.dart';
import 'package:app_hive/screens/add_note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            color: kTitleColor,
            fontSize: 35.0,
          ),
        ),
        centerTitle: true,
        elevation: 1.0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MyNavigator(context, 'add', -1, '', '');
        },
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 55.0, bottom: 5.0),
              child: Text(
                'Your Note',
                style: TextStyle(
                  fontSize: 25.0,
                  color: kIconColor,
                ),
              ),
            ),
            const SizedBox(
              width: 350.0,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Divider(
                  thickness: 1.5,
                  color: kNoteColor,
                ),
              ),
            ),
            FutureBuilder(
              future: Hive.openBox('note'),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return NoteList();
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget NoteList() {
    Box noteBox = Hive.box('note');
    return ValueListenableBuilder(
      valueListenable: noteBox.listenable(),
      builder: (context, Box box, child) {
        if (box.values.isEmpty) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.all(50.0),
            child: Text(
              'There is not any note!',
              style: TextStyle(
                fontSize: 25.0,
                color: kWhiteColor,
              ),
            ),
          ));
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: noteBox.length,
              itemBuilder: (context, index) {
                final Note note = box.getAt(index);
                return InkWell(
                  onTap: () => MyNavigator(
                      context, 'update', index, note.text, note.des),
                  child: Card(
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: kNoteColor,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.edit,
                        color: kIconColor,
                      ),
                      title: Text(
                        note.text,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: KBlackColor,
                        ),
                      ),
                      subtitle: Text(
                        note.des,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: KBlackColor,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Icon(
                                    Icons.delete,
                                    size: 45,
                                    color:
                                        const Color.fromARGB(255, 255, 17, 0),
                                  ),
                                  content:
                                      Text("Do you want to delete the note?"),
                                  actions: [
                                    IconButton(
                                        onPressed: () {
                                          remove(index);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Color.fromARGB(
                                                  255, 86, 86, 86),
                                              content: Text(
                                                "Done Seccessfully!",
                                              ),
                                            ),
                                          );
                                          Navigator.pop(context);
                                        },
                                        icon: Text("Yes")),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Text("No")),
                                  ],
                                );
                              });
                        },
                        icon: const Icon(Icons.delete),
                        color: KRedColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  MyNavigator(context, String type, int index, String text, String des) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteScreen(
          type: type,
          index: index,
          text: text,
          des: des,
        ),
      ),
    );
  }

  void remove(index) {
    Box box = Hive.box('note');
    box.deleteAt(index);
  }
}
