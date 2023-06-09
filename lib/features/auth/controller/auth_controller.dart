import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';
import 'package:twitter_clone/models/user_model.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});
final currentUserDetailsProvider = FutureProvider((ref) async {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  // print("userID from currentUserDetailsProvider: $currentUserId");
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  // print(
  //     "profilePic from currentUserDetailsProvider: ${userDetails.value?.profilePic}");
  return userDetails.value!;
});
final userDetailsProvider = FutureProvider.family((ref, String uid) async {
  print("the userID 4rm userDetailsProvider: $uid");
  final authController = ref.watch(authControllerProvider.notifier);
  // print("userDetailsProvider result: $authController");
  return authController.getUserData(uid);
});
final currentUserAccountProvider = FutureProvider((ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({
    required UserAPI userAPI,
    required AuthAPI authAPI,
  })  : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);

  Future<User?> currentUser() async {
    final user = await _authAPI.currentUserAccount();
    print("userID: ${user?.$id}");
    // print("User value: ${user?.then((value) => value!.$id)}");
    return user;
  }

//Sign Authentication
  Future<void> signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        showSnackBar(context, "Account created! Please login");
        Navigator.push(context, LoginView.route());
        UserModel userModel = UserModel(
          email: email,
          name: getNameFromEmail(email),
          followers: const [],
          following: const [],
          profilePic: "",
          bannerPic: "",
          uid: r.$id,
          bio: "",
          isTwitterBlue: false,
        );
        final res2 = await _userAPI.saveUserData(userModel);
        res2.fold(
          (l) => showSnackBar(context, l.message),
          (r) {
            showSnackBar(context, "Account created! Please login");
            Navigator.push(context, LoginView.route());
          },
        );
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        print("This is logged in userID: ${r.userId}");
        Navigator.push(context, HomeView.route());
      },
    );
  }

  Future<UserModel> getUserData(String uid) async {
    print("usermodelID: $uid");
    final document = await _userAPI.getUserData(uid);
    print("userDocument: ${document.data}");
    final updatedUser = UserModel.fromMap(document.data);
    print("UserModel.fromMap: ${updatedUser.profilePic}");
    return updatedUser;
  }
}
