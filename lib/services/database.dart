import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_notes/services/firebase.dart';

import '../models/note.dart';

class DataBase {
  //Add a Note
  Future<void> addNote(String title, String content) async {
    final userId = FirebaseService.instance.authInstance.currentUser!.uid;

    final notesCollection = FirebaseService.instance.firestoreInstance
        .collection('users')
        .doc(userId)
        .collection('notes');

    await notesCollection.add(
      {
        'title': title,
        'content': content,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );
  }

  //Retrieve Notes
  Stream<List<Note>> getUserNotes() {
    final userId = FirebaseService.instance.authInstance.currentUser!.uid;
    final notesCollection = FirebaseService.instance.firestoreInstance
        .collection('users')
        .doc(userId)
        .collection('notes');

    return notesCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return Note(
            id: doc.id,
            title: doc['title'],
            content: doc['content'],
            createdAt: (doc['createdAt'] as Timestamp).toDate(),
            updatedAt: (doc['updatedAt'] as Timestamp).toDate(),
          );
        }).toList();
      },
    );
  }

  //Edit a Note
  Future<void> updateNote(String noteId, String title, String content) async {
    final userId = FirebaseService.instance.authInstance.currentUser!.uid;
    final notesCollection = FirebaseService.instance.firestoreInstance
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId);

    await notesCollection.update(
      {
        'title': title,
        'content': content,
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );
  }

  //Remove a Note
  Future<void> deleteNote(String noteId) async {
    final userId = FirebaseService.instance.authInstance.currentUser!.uid;
    final notesCollection = FirebaseService.instance.firestoreInstance
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId);

    await notesCollection.delete();
  }
}
