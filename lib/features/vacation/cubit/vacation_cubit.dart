import 'package:boilerplate/core/bloc_core/ui_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'vacation_cubit.freezed.dart';

part 'vacation_state.dart';

class VacationCubit extends Cubit<VacationState> {
  VacationCubit() : super(const VacationState()) {
    // _authService = Injector.instance<AuthService>();
    // loginEndTime =
    //     DateFormat('dd/MM/yyyy HH:mm:ss').parse(_authService.loginEndTime);
    // final DateTime now = DateTime.now();
    // isExpiredSession = now.isAfter(loginEndTime);
  }
  //
  // void checkAuthentication() {
  //   if (isExpiredSession) {
  //     FirebaseAuth.instance.signOut();
  //     emit(
  //       state.copyWith(
  //         status: const UILoadFailed(message: ''),
  //       ),
  //     );
  //   }
  // }
  //
  // late DateTime loginEndTime;
  // late AuthService _authService;
  // late bool isExpiredSession;
}