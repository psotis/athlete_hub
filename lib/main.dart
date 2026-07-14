import 'package:athlete_hub/blocs/exports.dart';
import 'package:athlete_hub/helpers/imports.dart';
import 'package:athlete_hub/utils/snackbars/snackbar.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final SecureTokenStorage tokenStorage;
  late final AuthRepository authRepository;
  late final AuthBloc authBloc;
  late final AppRouter appRouter;

  @override
  void initState() {
    super.initState();

    tokenStorage = SecureTokenStorage();
    authRepository = AuthRepository(
      authService: AuthService(),
      tokenStorage: tokenStorage,
    );

    authBloc = AuthBloc(
      tokenStorage: tokenStorage,
      authRepository: authRepository,
    )..add(const AuthStarted());

    ApiClient.init(
      getToken: () => tokenStorage.getToken(),
      onUnauthorized: () =>
          authBloc.add(const AuthLoggedOut(notifyServer: false)),
    );

    appRouter = AppRouter(authBloc: authBloc);
  }

  @override
  void dispose() {
    authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SecureTokenStorage>.value(value: tokenStorage),
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(userService: UserService()),
        ),
        RepositoryProvider<ErgometricsRepository>(
          create: (context) =>
              ErgometricsRepository(ergometricsService: ErgometricsService()),
        ),
        RepositoryProvider<SessionRepository>(
          create: (context) =>
              SessionRepository(sessionService: SessionService()),
        ),
        RepositoryProvider<MedicalRepository>(
          create: (context) =>
              MedicalRepository(medicalService: MedicalService()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<InternetConnectionCubit>(
            create: (_) => InternetConnectionCubit(),
          ),
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<ProfileCubit>(
            create: (context) =>
                ProfileCubit(userRepository: context.read<UserRepository>()),
          ),
          BlocProvider<ErgometricsCubit>(
            create: (context) =>
                ErgometricsCubit(context.read<ErgometricsRepository>()),
          ),
          BlocProvider<SessionCubit>(
            create: (context) =>
                SessionCubit(context.read<SessionRepository>()),
          ),
          BlocProvider<MedicalCubit>(
            create: (context) =>
                MedicalCubit(context.read<MedicalRepository>()),
          ),
        ],

        child: MaterialApp.router(
          builder: (context, child) {
            return BlocListener<
              InternetConnectionCubit,
              InternetConnectionState
            >(
              listener: (context, state) {
                if (state.internetConnectionStatus ==
                    InternetConnectionStatus.disconnected) {
                  IotSnackbar.show(context, "No internet Connection");
                }
              },
              child: child!,
            );
          },
          title: 'Athlete Hub',
          routerConfig: appRouter.router,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightBlueTheme,
          // darkTheme: AppTheme.dark(),
          themeMode: ThemeMode.system,
        ),
      ),
    );
  }
}
