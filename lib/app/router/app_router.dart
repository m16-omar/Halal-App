import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/welcome_screen.dart';
import '../../features/onboarding/presentation/role_selection_screen.dart';
import '../../features/onboarding/presentation/seeker_setup_screen.dart';
import '../../features/verification/presentation/verification_screen.dart';
import '../../features/matchmaking/presentation/home_screen.dart';
import '../../features/matchmaking/presentation/matches_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/group_chat/presentation/wali_chat_screen.dart';
import '../../features/meetings/presentation/propose_meeting_screen.dart';
import '../../features/authentication/presentation/login_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/role-selection',
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: '/seeker-setup',
      builder: (context, state) => const SeekerSetupScreen(),
    ),
    GoRoute(
      path: '/verification',
      builder: (context, state) => const VerificationScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/matches',
      builder: (context, state) => const MatchesScreen(),
    ),
    GoRoute(
      path: '/wali-chat',
      builder: (context, state) => const WaliChatScreen(),
    ),
    GoRoute(
      path: '/propose-meeting',
      builder: (context, state) => const ProposeMeetingScreen(),
    ),
  ],
);
