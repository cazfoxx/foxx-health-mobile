import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart'
    show FirebaseCrashlytics;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/core/utils/app_storage.dart';
import 'package:foxxhealth/features/presentation/cubits/appointment_info/appointment_info_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/appointment_type/appointment_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/checklist/checklist_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/forgot_password/forgot_password_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/check_list/health_assesment_checklist_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessment_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/login/login_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/profile/profile_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_tracker/symptom_tracker_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/symptoms/symptoms_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/home_screen.dart';
import 'package:foxxhealth/features/presentation/screens/splash/splash_screen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:get_storage/get_storage.dart';


void main() async {
  // Initialize storage for API logs
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Lock typography scaling
  MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).textScaler;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();

  const fatalError = true;
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      // FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      // FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final email = prefs.getString('user_email');

    if (token != null && token.isNotEmpty) {
      // Store in global storage
      AppStorage.setCredentials(token: token, email: email);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => LoginCubit()),
            BlocProvider(create: (context) => AppointmentCubit()),
            BlocProvider(create: (context) => ChecklistCubit()),
            BlocProvider(create: (context) => HealthAssessmentCubit()),
            BlocProvider(create: (context) => ProfileCubit()),
            BlocProvider(create: (context) => SymptomTrackerCubit()),
            BlocProvider(create: (context) => SymptomsCubit()),
            BlocProvider(create: (context) => ForgotPasswordCubit()),
            BlocProvider(create: (context) => HealthAssessmentChecklistCubit()),
            BlocProvider(create: (context) => AppointmentInfoCubit()),
          ],
          child: GetMaterialApp(
            scaffoldMessengerKey: ApiClient.scaffoldKey,
            title: 'FoxxHealth',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme:
                  ColorScheme.fromSeed(seedColor: const Color(0xFF6B4EFF)),
              useMaterial3: true,
            ),
            builder: (context, child) {
              // Lock typography scaling
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child!,
              );
            },
            home: FutureBuilder<bool>(
              future: _checkAuthToken(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SplashScreen();
                }

                if (snapshot.hasData && snapshot.data == true) {
                  return  HomeScreen();
                }

                return const SplashScreen();
              },
            ),
          ),
        );
      },
    );
  }
}
