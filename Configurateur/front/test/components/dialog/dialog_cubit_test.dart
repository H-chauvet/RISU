import 'package:flutter_test/flutter_test.dart';
import 'package:front/components/dialog/dialog_cubit.dart';

void main() {
  
  group('DialogCubit', () {
    test('Initial state is correct', () {
      final cubit = DialogCubit();

      expect(cubit.state.rating, 0);
      expect(cubit.state.message, '');
    });

    test('updateRating emits correct state', () {
      final cubit = DialogCubit();

      cubit.updateRating(5);

      expect(cubit.state.rating, 5);
      expect(cubit.state.message, ''); // Message should remain unchanged
    });

    test('updateMessage emits correct state', () {
      final cubit = DialogCubit();

      cubit.updateMessage('Test Message');

      expect(cubit.state.rating, 0); // Rating should remain unchanged
      expect(cubit.state.message, 'Test Message');
    });

    test('copyWith creates a new state with specified changes', () {
      final initialState = DialogState(rating: 3, message: 'Initial Message');
      final newState = initialState.copyWith(rating: 4);

      expect(newState.rating, 4);
      expect(newState.message, 'Initial Message'); // Message should remain unchanged
    });
  });
}
