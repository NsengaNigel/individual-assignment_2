import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/models/note.dart';

class NotesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'notes';

  Future<List<Note>> fetchNotes(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Note.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  Future<Note> addNote(String text, String userId) async {
    try {
      final now = DateTime.now();
      final note = Note(
        id: '',
        text: text,
        createdAt: now,
        updatedAt: now,
        userId: userId,
      );

      final docRef = await _firestore
          .collection(_collection)
          .add(note.toFirestore());

      return note.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Failed to add note: $e');
    }
  }

  Future<Note> updateNote(String id, String text) async {
    try {
      final updatedAt = DateTime.now();
      
      await _firestore
          .collection(_collection)
          .doc(id)
          .update({
        'text': text,
        'updatedAt': Timestamp.fromDate(updatedAt),
      });

      final doc = await _firestore
          .collection(_collection)
          .doc(id)
          .get();

      return Note.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(id)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }

  Stream<List<Note>> watchNotes(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList());
  }
} 