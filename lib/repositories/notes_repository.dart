import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/models/note.dart';

class NotesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Note>> watchNotes(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList());
  }

  Future<List<Note>> fetchNotes(String userId) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('updatedAt', descending: true)
        .get();
    return querySnapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
  }

  Future<Note> addNote(String text, String userId) async {
    final now = DateTime.now();
    final note = Note(
      id: '',
      title: '', // You may want to update this to accept title
      content: text, // For now, treat text as content
      createdAt: now,
      updatedAt: now,
      userId: userId,
    );
    final docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .add(note.toFirestore());
    return note.copyWith(id: docRef.id);
  }

  Future<Note> updateNote(String id, String text, String userId) async {
    final updatedAt = DateTime.now();
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(id);
    await docRef.update({
      'content': text,
      'updatedAt': Timestamp.fromDate(updatedAt),
    });
    final doc = await docRef.get();
    return Note.fromFirestore(doc);
  }

  Future<void> deleteNote(String id, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(id)
        .delete();
  }
}