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
    emitter.call(SelfLoading());
    try {
      if (supabase.auth.currentUser == null) {
        emitter.call(SelfError('User is not logged in.'));
        return;
      }
      print(supabase.auth.currentUser!.id);
      final myselfResponse = await supabase
          .from('profiles')
          .select()
          .eq('uuid', supabase.auth.currentUser!.id.toString());
      print(myselfResponse);
      // final User myself = myselfResponse as User;
      emitter.call(SelfLoaded(self: myselfResponse.toString()));
    } catch (e) {
      print(e);
    }
  }
}
