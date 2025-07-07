import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';

class NoteDialog extends StatefulWidget {
  final Note? note;
  final Function(String) onSave;

  const NoteDialog({
    Key? key,
    this.note,
    required this.onSave,
  }) : super(key: key);

  @override
  _NoteDialogState createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  late TextEditingController _textController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.note == null ? 'Add Note' : 'Edit Note',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Enter your note...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                autofocus: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveNote,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: Text(widget.note == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      final text = _textController.text.trim();
      widget.onSave(text);
      Navigator.of(context).pop();
    }
  }
} 