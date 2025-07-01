import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/repositories/notes_repository.dart';

// Events
abstract class NotesEvent {}

class NotesLoadRequested extends NotesEvent {}
class NotesAddRequested extends NotesEvent {
  final String text;
  NotesAddRequested({required this.text});
}
class NotesUpdateRequested extends NotesEvent {
  final String id;
  final String text;
  NotesUpdateRequested({required this.id, required this.text});
}
class NotesDeleteRequested extends NotesEvent {
  final String id;
  NotesDeleteRequested({required this.id});
}
class NotesWatchRequested extends NotesEvent {}

// States
abstract class NotesState {
  List<Note> get notes => [];
}
class NotesInitial extends NotesState {}
class NotesLoading extends NotesState {}
class NotesLoaded extends NotesState {
  final List<Note> notes;
  NotesLoaded({required this.notes});
}
class NotesOperationInProgress extends NotesState {
  final List<Note> notes;
  NotesOperationInProgress({required this.notes});
}
class NotesOperationSuccess extends NotesState {
  final List<Note> notes;
  final String message;
  NotesOperationSuccess({required this.notes, required this.message});
}
class NotesError extends NotesState {
  final String message;
  final List<Note> notes;
  NotesError({required this.message, this.notes = const []});
}

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository notesRepository;
  final String userId;

  NotesBloc({required this.notesRepository, required this.userId}) : super(NotesInitial()) {
    on<NotesLoadRequested>(_onLoadRequested);
    on<NotesAddRequested>(_onAddRequested);
    on<NotesUpdateRequested>(_onUpdateRequested);
    on<NotesDeleteRequested>(_onDeleteRequested);
    on<NotesWatchRequested>(_onWatchRequested);
  }

  Future<void> _onLoadRequested(NotesLoadRequested event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    try {
      final notes = await notesRepository.fetchNotes(userId);
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onAddRequested(NotesAddRequested event, Emitter<NotesState> emit) async {
    final currentNotes = state.notes;
    emit(NotesOperationInProgress(notes: currentNotes));
    try {
      final note = await notesRepository.addNote(event.text, userId);
      final notes = await notesRepository.fetchNotes(userId);
      emit(NotesOperationSuccess(notes: notes, message: 'Note added'));
    } catch (e) {
      emit(NotesError(message: e.toString(), notes: currentNotes));
    }
  }

  Future<void> _onUpdateRequested(NotesUpdateRequested event, Emitter<NotesState> emit) async {
    final currentNotes = state.notes;
    emit(NotesOperationInProgress(notes: currentNotes));
    try {
      await notesRepository.updateNote(event.id, event.text);
      final notes = await notesRepository.fetchNotes(userId);
      emit(NotesOperationSuccess(notes: notes, message: 'Note updated'));
    } catch (e) {
      emit(NotesError(message: e.toString(), notes: currentNotes));
    }
  }

  Future<void> _onDeleteRequested(NotesDeleteRequested event, Emitter<NotesState> emit) async {
    final currentNotes = state.notes;
    emit(NotesOperationInProgress(notes: currentNotes));
    try {
      await notesRepository.deleteNote(event.id);
      final notes = await notesRepository.fetchNotes(userId);
      emit(NotesOperationSuccess(notes: notes, message: 'Note deleted'));
    } catch (e) {
      emit(NotesError(message: e.toString(), notes: currentNotes));
    }
  }

  void _onWatchRequested(NotesWatchRequested event, Emitter<NotesState> emit) {
    emit(NotesLoading());
    notesRepository.watchNotes(userId).listen((notes) {
      add(NotesLoadRequested());
    });
  }
} 