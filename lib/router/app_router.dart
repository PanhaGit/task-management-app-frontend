import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
extension AppRouter on BuildContext {

  // ************************** Use for Go **************************
  /**
   * @author Tho Panha
   * Authentication Route: auth
   * Route: auth/login , auth/signup, auth/change_password, auth/email ,auth/verify_otp
   * */

  void goToLogin () => go("auth/login");
  void goToSignup() => go('/auth/signup');


  // Initial screens with Go
  void goToSplash() => go('/splash');
  void goToGetStart() => go('/get_start');
  void goToHome() => go('/');

  // ************************** Use for Push **************************

  /**
   * @author Tho Panha
   * Authentication Route: auth
   * Route: >> / << is Home Screen
   * Route: / , /calendar, /add_task, /notification ,/profile
   * */

  void pushToHome() => push('/');
  void pushToCalendar() => push('/calendar');
  void pushToAddTask() => push('/add_task');
  void pushToNotification() => push('/notification');
  void pushToProfile() => push('/profile');

  /**
   * @author Tho Panha
   * Authentication Route: auth
   * Route: auth/login , auth/signup, auth/change_password, auth/email ,auth/verify_otp
   * */
  void pushToLogin () => push("/auth/login");
  void pushToSignup() => push('/auth/signup');
  void pushToDOB() => push('/auth/dob');

  // Initial screens with push
  void pushToGetStart() => push('/get_start');
}