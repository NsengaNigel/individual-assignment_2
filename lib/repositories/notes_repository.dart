import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory Note.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'userId': userId,
    };
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user's notes stream
  Stream<List<Note>> getUserNotes(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList());
  }

  // Add a new note
  Future<void> addNote(Note note) async {
    try {
      await _firestore
          .collection('users')
          .doc(note.userId)
          .collection('notes')
          .add(note.toFirestore());
    } catch (e) {
      print('Error adding note: $e');
      throw e;
    }
  }

  // Update a note
  Future<void> updateNote(Note note) async {
    try {
      await _firestore
          .collection('users')
          .doc(note.userId)
          .collection('notes')
          .doc(note.id)
          .update(note.toFirestore());
    } catch (e) {
      print('Error updating note: $e');
      throw e;
    }
  }

  // Delete a note
  Future<void> deleteNote(String userId, String noteId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .doc(noteId)
          .delete();
    } catch (e) {
      print('Error deleting note: $e');
      throw e;
    }
  }

  // Get a single note
  Future<Note?> getNote(String userId, String noteId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .doc(noteId)
          .get();

      if (doc.exists) {
        return Note.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting note: $e');
      throw e;
    }
  }
}