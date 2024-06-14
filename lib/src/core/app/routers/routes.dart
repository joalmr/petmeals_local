import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:petmeals_local/src/features/pet/domain/entities/pet.dart';
import 'package:petmeals_local/src/features/pet/presentation/views/add/pet_add.dart';
import 'package:petmeals_local/src/features/pet/presentation/views/detail/pet_detail.dart';
import 'package:petmeals_local/src/features/pet/presentation/views/home/home.dart';
import 'package:petmeals_local/src/features/user/presentation/views/login.dart';

final GoRouter goRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
        // ? const HomePage()
        // : const LoginPage();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
    GoRoute(
      path: '/add',
      builder: (BuildContext context, GoRouterState state) {
        return const PetAddPage(myPet: null);
      },
    ),
    //context.push('/petdetail/update', extra: true);
    GoRoute(
      path: '/petdetail',
      builder: (BuildContext context, GoRouterState state) {
        var myPet = state.extra as PetEntity;
        return PetDetailPage(
          myPet: myPet,
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'update',
          builder: (BuildContext context, GoRouterState state) {
            var myPet = state.extra as PetEntity;
            return PetAddPage(
              myPet: myPet,
            );
          },
        ),
      ],
    ),
  ],
);
