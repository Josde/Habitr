import 'package:bloc/bloc.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:meta/meta.dart';

part 'self_event.dart';
part 'self_state.dart';

class SelfBloc extends Bloc<SelfEvent, SelfState> {
  SelfBloc() : super(SelfInitial()) {
    on<LoadSelfEvent>(_onLoadSelf);
  }

  void _onLoadSelf(SelfEvent event, Emitter<SelfState> emitter) async {
    try {
      emitter.call(SelfLoading());
      if (supabase.auth.currentUser == null) {
        emitter.call(SelfError('User is not logged in.'));
        return;
      }
      final myselfResponse = await supabase
          .from('user')
          .select()
          .eq('id', supabase.auth.currentUser!.id.toString());
      final User myself = myselfResponse as User;
    } catch (e) {
      print(e);
    }
  }
}
