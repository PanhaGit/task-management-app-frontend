import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension AppRouter on BuildContext {
    // ************************** Use for Go **************************
    /**
     * @author Tho Panha
     * Authentication Routes: /auth/
     * Initial Routes: /splash, /get_start
     * Main Routes: /, /calendar, /add_task, /notification, /profile
        */
        void goToLogin() => go('/auth/login');
        void goToSignup() => go('/auth/signup');
        void goToForgetPassword() => go('/auth/forget_password');
        void goToDOB() => go('/auth/dob');

        // Initial screens
        void goToSplash() => go('/splash');
        void goToGetStart() => go('/get_start');

        // Main routes (within StatefulShellRoute)
        void goToHome() => go('/');
        void goToCalendar() => go('/calendar');
        void goToAddTask() => go('/add_task');
        void goToNotification() => go('/notification');
        void goToProfile() => go('/profile');

        // ************************** Use for Push **************************
        /**
     * @author Tho Panha
     * Use push only for routes within StatefulShellRoute
        */
        void pushToHome() => push('/');
        void pushToCalendar() => push('/calendar');
        void pushToAddTask() => push('/add_task');
        void pushToNotification() => push('/notification');
        void pushToProfile() => push('/profile');

        // Push for auth routes (use go to avoid stack issues)
        void pushToLogin() => push('/auth/login');
        void pushToSignup() => push('/auth/signup');
        void pushToDOB() => push('/auth/dob');
        void pushToForgetPass() => push('/auth/forget_password');
        void pushToGetStart() => push('/get_start');

        /**
         * Utility Methods
         * */
        void popScreen() => pop();
        void goBack() => canPop() ? pop() : push('/');
}