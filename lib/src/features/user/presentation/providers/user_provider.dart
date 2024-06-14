import 'package:flutter/material.dart';
import 'package:petmeals_local/src/features/user/domain/use_cases/signin_person_auth_usecase.dart';
import 'package:petmeals_local/src/features/user/domain/use_cases/signout_person_auth_usecase.dart';

class UserProvider extends ChangeNotifier {
  // final UserUsecase userUsecase;
  final SigninPersonAuthUsecase signInUsecase;
  final SignoutPersonAuthUsecase signOutUsecase;

  UserProvider(this.signInUsecase, this.signOutUsecase);
}
