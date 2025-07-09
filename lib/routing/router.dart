import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/data/repositories/auth_repository.dart';
import 'package:poupix/data/services/auth_service.dart';
import 'package:poupix/ui/add/view_models/add_viewmodel.dart';
import 'package:poupix/ui/add/widgets/add_expense.dart';
import 'package:poupix/ui/auth/view_models/loading_viewmodel.dart';
import 'package:poupix/ui/auth/view_models/login_viewmodel.dart';
import 'package:poupix/ui/auth/view_models/new_password_viewmodel.dart';
import 'package:poupix/ui/auth/view_models/recovery_viewmodel.dart';
import 'package:poupix/ui/auth/view_models/signup_viewmodel.dart';
import 'package:poupix/ui/auth/view_models/verify_viewmodel.dart';
import 'package:poupix/ui/auth/widgets/loading.dart';
import 'package:poupix/ui/auth/widgets/login.dart';
import 'package:poupix/ui/auth/widgets/new_password.dart';
import 'package:poupix/ui/auth/widgets/policy.dart';
import 'package:poupix/ui/auth/widgets/recovery.dart';
import 'package:poupix/ui/auth/widgets/signup.dart';
import 'package:poupix/ui/auth/widgets/verify.dart';
import 'package:poupix/ui/categories/view_models/categories_viewmodel.dart';
import 'package:poupix/ui/categories/widgets/categories.dart';
import 'package:poupix/ui/expenses/view_models/expenses_viewmodel.dart';
import 'package:poupix/ui/expenses/widgets/expenses.dart';
import 'package:poupix/ui/home/view_models/home_viewmodel.dart';
import 'package:poupix/ui/home/widgets/home.dart';
import 'package:poupix/ui/profile/view_models/profile_viewmodel.dart';
import 'package:poupix/ui/profile/widgets/donate.dart';
import 'package:poupix/ui/profile/widgets/profile.dart';
import 'package:provider/provider.dart';

GoRouter router(AuthRepository authRepository, AppState appState) => GoRouter(
        initialLocation: '/loading',
        refreshListenable: authRepository,
        routes: [
          GoRoute(
            path: '/login',
            pageBuilder: (context, state) {
              final viewModel = LoginViewModel(authRepository: context.read());
              return buildPageWithTransition(
                state: state,
                child: Login(viewModel: viewModel),
              );
            },
          ),
          GoRoute(
            path: '/home',
            redirect: (context, state) async {
              if (!await isLoggedIn(authRepository)) return '/login';
              return null;
            },
            pageBuilder: (context, state) {
              final viewModel = HomeViewModel(appState: appState);
              return buildPageWithTransition(
                state: state,
                child: Home(viewModel: viewModel),
              );
            },
          ),
          GoRoute(
            path: '/loading',
            redirect: (context, state) async {
              if (!await isLoggedIn(authRepository)) return '/login';
              return null;
            },
            pageBuilder: (context, state) {
              final viewModel = LoadingViewModel(appState: appState);
              return buildPageWithTransition(
                state: state,
                child: Loading(viewModel: viewModel),
              );
            },
          ),
          GoRoute(
            path: '/signup',
            pageBuilder: (context, state) {
              final authService = AuthService();
              final viewModel = SignUpViewModel(authService: authService);
              return buildPageWithTransition(
                state: state,
                child: SignUp(viewModel: viewModel),
              );
            },
          ),
          GoRoute(
            path: '/expenses',
            redirect: (context, state) async {
              if (!await isLoggedIn(authRepository)) return '/login';
              return null;
            },
            pageBuilder: (context, state) {
              final viewModel = ExpensesViewModel(appState: appState);
              return buildPageWithTransition(
                state: state,
                child: Expenses(viewModel: viewModel),
              );
            },
          ),
          GoRoute(
            path: '/add',
            redirect: (context, state) async {
              if (!await isLoggedIn(authRepository)) return '/login';
              return null;
            },
            pageBuilder: (context, state) {
              final viewModel = AddViewModel();
              return buildPageWithTransition(
                state: state,
                child: Add(viewModel: viewModel),
              );
            },
          ),
          GoRoute(
            path: '/categories',
            redirect: (context, state) async {
              if (!await isLoggedIn(authRepository)) return '/login';
              return null;
            },
            pageBuilder: (context, state) {
              final viewModel = CategoriesViewModel(appState: appState);
              return buildPageWithTransition(
                state: state,
                child: Categories(viewModel: viewModel),
              );
            },
          ),
          GoRoute(
            path: '/profile',
            redirect: (context, state) async {
              if (!await isLoggedIn(authRepository)) return '/login';
              return null;
            },
            pageBuilder: (context, state) {
              final viewModel = ProfileViewModel();
              return buildPageWithTransition(
                state: state,
                child: Profile(viewModel: viewModel),
              );
            },
          ),
          GoRoute(
            path: '/verify',
            redirect: (context, state) async {
              if (!await isLoggedIn(authRepository)) return '/login';
              return null;
            },
            pageBuilder: (context, state) {
              final authService = AuthService();
              final viewModel =
                  VerifyViewModel(authService: authService, appState: appState);
              return buildPageWithTransition(
                state: state,
                child: Verify(viewModel: viewModel),
              );
            },
          ),
          GoRoute(
            path: '/donate',
            pageBuilder: (context, state) {
              return buildPageWithTransition(
                state: state,
                child: Donate(),
              );
            },
          ),
          GoRoute(
            path: '/policy',
            pageBuilder: (context, state) {
              return buildPageWithTransition(
                state: state,
                child: Policy(),
              );
            },
          ),
          GoRoute(
            path: '/recovery',
            pageBuilder: (context, state) {
              final authService = AuthService();
              final viewModel = RecoveryViewModel(authService: authService);
              return buildPageWithTransition(
                state: state,
                child: Recovery(
                  viewModel: viewModel,
                ),
              );
            },
          ),
          GoRoute(
            path: '/new-password',
            pageBuilder: (context, state) {
              final authService = AuthService();
              final email = state.uri.queryParameters['email'];
              final viewModel = NewPasswordViewModel(authService: authService);
              return buildPageWithTransition(
                state: state,
                child: NewPassword(
                  viewModel: viewModel,
                  email: email,
                ),
              );
            },
          ),
        ]);

CustomTransitionPage<T> buildPageWithTransition<T>({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

Future<bool> isLoggedIn(AuthRepository authRepository) async {
  return await authRepository.isAuthenticated;
}
