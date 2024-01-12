import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:app_hive/constants.dart';

import '../models/note_model.dart';

class NoteScreen extends StatefulWidget {
  NoteScreen(
      {Key? key,
      required this.type,
      required this.index,
      required this.text,
      required this.des})
      : super(key: key);

  final String type;
  final int index;
  final String text;
  final String des;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController controller = TextEditingController();
  TextEditingController dcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.type == 'update') {
      controller.text = widget.text;
      dcontroller.text = widget.des;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1.0,
        title: Text(
          widget.type == 'add' ? 'Add Note' : 'Update Note',
          style: TextStyle(
            color: kTitleColor,
            fontSize: 25.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            //
            TextField(
              autofocus: true,
              controller: controller,
              decoration: InputDecoration(
                icon: Icon(Icons.title),
                border: InputBorder.none,
              ),
            ),
            Divider(
              endIndent: 250,
            ),
            TextField(
              controller: dcontroller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Description...",
              ),
              maxLines: 15,
            ),
            Divider(),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    onButtonPressed(controller.text, dcontroller.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Color.fromARGB(255, 86, 86, 86),
                        content: Text(
                          "Done Seccessfully!",
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: Text(
                    widget.type == 'add' ? 'Add' : 'Update',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kIconColor),
                    fixedSize: MaterialStateProperty.all(
                      const Size(90.0, 40.0),
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kIconColor),
                    fixedSize: MaterialStateProperty.all(
                      const Size(90.0, 40.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onButtonPressed(String text, String des) {
    if (widget.type == 'add') {
      add(text, des);
    } else {
      update(text, des);
    }
  }

  add(String text, String des) async {
    var box = await Hive.openBox('note');
    Note note = Note(text, des);
    await box.add(note);
  }

  update(String text, String des) async {
    var box = await Hive.openBox('note');
    Note note = Note(text, des);
    box.putAt(widget.index, note);
  }

}
