// dialog_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';

class DialogCubit extends Cubit<DialogState> {
  DialogCubit() : super(DialogState());

  void updateRating(int rating) {
    emit(state.copyWith(rating: rating));
  }

  void updateMessage(String message) {
    emit(state.copyWith(message: message));
  }
}

class DialogState {
  final int rating;
  final String message;

  DialogState({this.rating = 0, this.message = ''});

  DialogState copyWith({int? rating, String? message}) {
    return DialogState(
      rating: rating ?? this.rating,
      message: message ?? this.message,
    );
  }
}
