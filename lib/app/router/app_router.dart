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
import '../../features/authentication/presentation/forgot_password_screen.dart';
import '../../features/counseling/presentation/counseling_screen.dart';
import '../../features/matchmaking/presentation/match_detail_screen.dart';
import '../../features/group_chat/presentation/direct_chat_screen.dart';
import '../../features/group_chat/presentation/messages_screen.dart';
import '../../features/matchmaking/presentation/search_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/interest_requests/presentation/interest_requests_screen.dart';

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
      path: '/forgot-password',
      builder: (context, state) {
        final email = state.uri.queryParameters['email'];
        return ForgotPasswordScreen(prefilledEmail: email);
      },
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
    GoRoute(
      path: '/counseling',
      builder: (context, state) => const CounselingScreen(),
    ),
    GoRoute(
      path: '/match-detail',
      builder: (context, state) {
        final candidate = state.extra as Map<String, dynamic>?;
        return MatchDetailScreen(candidateData: candidate);
      },
    ),
    GoRoute(
      path: '/direct-chat',
      builder: (context, state) {
        final candidate = state.extra as Map<String, dynamic>?;
        return DirectChatScreen(candidateData: candidate);
      },
    ),
    GoRoute(
      path: '/messages',
      builder: (context, state) => const MessagesScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/interest-requests',
      builder: (context, state) => const InterestRequestsScreen(),
    ),
  ],
);
