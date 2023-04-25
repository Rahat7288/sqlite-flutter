import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/note_database.dart';
import '../model/note.dart';
import '../page/edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;
  const NoteDetailPage({super.key, required this.noteId});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);
    this.note = await NoteDatabase.instance.readNote(widget.noteId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [
            editButton(),
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      note.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      DateFormat.yMMMd().format(note.createdTime),
                      // DateFormat('EEEE').format(note.createdTime),
                      style: TextStyle(color: Colors.white38),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      note.description,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
              ),
      );

  Widget editButton() => IconButton(
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddEditNotePage(note: note),
          ),
        );
        refreshNote();
      },
      icon: Icon(Icons.edit_outlined));
}

// Widget deleteButton() => IconButton(onPressed: () async {
//   await NoteDatabase.
// }, icon: Icon(Icons.delete));
