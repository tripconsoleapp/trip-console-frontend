/// Centralized non-visual constants — API config and user-facing strings.
/// Screens must pull text from here instead of inlining string literals.
class AppConstants {
  AppConstants._();

  static const String baseUrl = "https://api.tripconsole.app/v1";
}

class SplashStrings {
  SplashStrings._();

  static const String appName = "TripConsole";
  static const String tagline = "DIGITAL CONCIERGE SERVICE";
  static const String loadingMessage = "Initializing travel protocols...";
}

class OnboardingStrings {
  OnboardingStrings._();

  static const String slide1Headline = "Plan Your Escape";
  static const String slide1Body =
      "Discover and organize your next adventure with our seamless trip planning tools designed for the discerning traveler.";
  static const String next = "Next";
  static const String skip = "Skip";

  static const String slide2Badge = "FINAL STEP";
  static const String slide2Headline = "Book Your\nJourney";
  static const String slide2Body =
      "Experience lightning-fast planning with our secure console. Your next great adventure is just a tap away.";
  static const String socialProof = "Join 50k+ travelers";
  static const String getStarted = "Get Started";
  static const String aboutUs = "ABOUT US";
}

class GetStartedStrings {
  GetStartedStrings._();

  static const String appName = "TripConsole";
  static const String tagline = "Institutional trip management, simplified.";
  static const String createAccount = "Create an Account";
  static const String haveAccount = "I already have an account";
  static const String legalPrefix = "By continuing you agree to our ";
  static const String terms = "Terms";
  static const String legalJoiner = " & ";
  static const String privacyPolicy = "Privacy Policy";
}

class EnterPhoneStrings {
  EnterPhoneStrings._();

  static const String heading = "Enter your mobile number";
  static const String subheading = "We'll send a 4-digit OTP to verify it's you.";
  static const String label = "MOBILE NUMBER";
  static const String placeholder = "98765 43210";
  static const String countryCode = "+91";
  static const String smsRatesNotice = "Standard SMS rates may apply";
  static const String sendOtp = "Send OTP";
  static const String securityNote = "Your number is only used for verification and trip alerts";
  static const String invalidNumber = "Enter a valid 10-digit mobile number";
}

class VerifyOtpStrings {
  VerifyOtpStrings._();

  static const String heading = "Verify your number";
  static const String otpSentTo = "OTP sent to ";
  static const String changeNumber = "Wrong number? Change";
  static const String resendPrefix = "Resend OTP in ";
  static const String resendSecondsSuffix = "s";
  static const String resendNow = "Resend OTP";
  static const String verifyAndContinue = "Verify & Continue";
  static const String securityNote = "Your number is only used for verification and trip alerts";
}

class SignUpStrings {
  SignUpStrings._();

  static const String title = "Let's get you set up.";
  static const String subtitle = "Takes less than 2 minutes.";
  static const String fullName = "FULL NAME";
  static const String fullNameHint = "Enter your full name";
  static const String emailAddress = "EMAIL ADDRESS";
  static const String emailHint = "you@school.edu";
  static const String mobileNumber = "MOBILE NUMBER";
  static const String mobileHint = "98765 43210";
  static const String mobileNote = "Used for trip alerts and coordination.";
  static const String password = "PASSWORD";
  static const String confirmPassword = "CONFIRM PASSWORD";
  static const String termsPrefix = "I agree to the ";
  static const String termsOfService = "Terms of Service";
  static const String termsJoiner = " and ";
  static const String privacyPolicy = "Privacy Policy";
  static const String termsSuffix = " of TripConsole.";
  static const String createAccount = "Create Account";
  static const String or = "OR";
  static const String haveAccountPrefix = "Already have an account? ";
  static const String logIn = "Log In";
  static const String passwordTooShort = "Password must be at least 8 characters";
  static const String passwordsDontMatch = "Passwords don't match";
  static const String invalidEmail = "Enter a valid email address";
  static const String mustAgreeToTerms = "Please agree to the Terms & Privacy Policy";
}

class RoleSelectionStrings {
  RoleSelectionStrings._();

  static const String stepLabel = "STEP 2 OF 3 — CHOOSE YOUR ROLE";
  static const String title = "Choose your role";
  static const String subtitle = "Select how you'll be using TripConsole. This cannot be changed later without contacting support.";
  static const String continueAsPrefix = "Continue as ";
}

class VerifyEmailStrings {
  VerifyEmailStrings._();

  static const String header = "Onboarding";
  static const String title = "Verify your email";
  static const String sentToPrefix = "We've sent a 6-digit verification code to ";
  static const String sentToSuffix = ". Enter it below to activate your account.";
  static const String resendPrefix = "Resend code in ";
  static const String resendSecondsSuffix = "s";
  static const String resendNow = "Resend code";
  static const String verifyAndContinue = "Verify & Continue";
  static const String changeEmail = "Change email address";
  static const String securityNote = "Your email is only used for account verification.";
}

class ForgotPasswordStrings {
  ForgotPasswordStrings._();

  static const String appBarTitle = "Forgot Password";
  static const String title = "Reset your password";
  static const String subtitleEmail = "Enter your registered email and we'll send you a reset link.";
  static const String subtitlePhone = "Enter your registered mobile number and we'll send you an OTP.";
  static const String emailTab = "Email";
  static const String phoneTab = "Phone";
  static const String registeredEmail = "REGISTERED EMAIL";
  static const String emailHint = "you@school.edu";
  static const String registeredPhone = "REGISTERED MOBILE NUMBER";
  static const String phoneHint = "98765 43210";
  static const String sendResetLink = "Send Reset Link";
  static const String sendOtp = "Send OTP";
  static const String backToLogin = "Back to Login";
  static const String checkInboxTitle = "Check your inbox";
  static const String checkInboxPrefix = "We sent a reset link to ";
  static const String resendEmail = "Resend email";
  static const String invalidEmail = "Enter a valid email address";
  static const String invalidPhone = "Enter a valid 10-digit mobile number";
}

class ResetPasswordStrings {
  ResetPasswordStrings._();

  static const String appBarTitle = "Reset Password";
  static const String title = "Create a new password";
  static const String subtitle = "Must be at least 8 characters.";
  static const String newPassword = "NEW PASSWORD";
  static const String confirmPassword = "CONFIRM PASSWORD";
  static const String updatePassword = "Update Password";
  static const String passwordTooShort = "Password must be at least 8 characters";
  static const String passwordsDontMatch = "Passwords don't match";
  static const String successTitle = "Password updated!";
  static const String successBody = "Your security is our priority. You can now login with your new credentials.";
  static const String goToLogin = "Go to Login";
  static const String linkExpiredTitle = "Link expired";
  static const String linkExpiredBody = "For your security, reset links expire after 24 hours. Please request a new one.";
  static const String requestNewLink = "Request New Link";
  static const String backToLogin = "Back to Login";
}

class SessionExpiredStrings {
  SessionExpiredStrings._();

  static const String appBarTitle = "TripConsole";
  static const String title = "Session expired";
  static const String body = "For your security, you've been logged out. Please log in again to continue.";
  static const String logInAgain = "Log In Again";
  static const String needHelpPrefix = "Need help? ";
  static const String contactSupport = "Contact support.";
  static const String footerCopyright = "© 2026 Travel Concierge";
}

class LoginStrings {
  LoginStrings._();

  static const String appName = "TripConsole";
  static const String welcomeBack = "Welcome back";
  static const String emailTab = "Email";
  static const String phoneTab = "Phone / OTP";
  static const String email = "EMAIL";
  static const String emailHint = "you@school.edu";
  static const String password = "PASSWORD";
  static const String forgotPassword = "Forgot Password?";
  static const String logIn = "Log In";
  static const String or = "OR";
  static const String noAccountPrefix = "Don't have an account? ";
  static const String signUp = "Sign Up";
  static const String coordinatorNotice = "Specialized access for Field Coordinators only.";
  static const String newCoordinatorPrefix = "New coordinator? ";
  static const String contactAdmin = "Contact Admin";
}

class HomeDashboardStrings {
  HomeDashboardStrings._();

  static const String appName = "TripConsole";
  static const String greetingPrefix = "Good morning, ";
  static const String organizerBadge = "ORGANIZER";
  static const String subtitle = "Ready to manage your next great adventure?";
  static const String serviceOnlyLabel = "SERVICE ONLY";
  static const String hotel = "Hotel";
  static const String vehicle = "Vehicle";
  static const String restaurant = "Restaurant";
  static const String planFullTripTitle = "Plan a Full Trip";
  static const String planFullTripBody =
      "Create an end-to-end itinerary with transport, food and stays for your group.";
  static const String planPilgrimageTitle = "Plan Pilgrimage Program";
  static const String planPilgrimageBody =
      "Sabarimala and other pilgrimage trips — pilgrim records, transport, accommodation and coordinator management.";
  static const String browseTemplates = "Browse reference templates";
  static const String serviceOnlyNotice = "Service-only bookings are independent — they won't appear in your trip list.";
  static const String recommendedForYou = "Recommended for You";
  static const String viewAll = "View All";
}

class WizardStrings {
  WizardStrings._();

  static const List<String> stepLabels = ['Basics', 'Destinations', 'Services', 'Itinerary', 'Review'];
  static const String newTrip = "New Trip";
  static const String saveDraft = "Save Draft";
}

class TripBasicsStrings {
  TripBasicsStrings._();

  static const String tripName = "TRIP NAME";
  static const String tripNameHint = "Western Ghats Expedition";
  static const String tripType = "TRIP TYPE";
  static const String travelingWithCompanion = "Traveling with a companion?";
  static const String companionName = "COMPANION NAME";
  static const String companionNameHint = "Enter companion's full name";

  static const String groupName = "GROUP NAME";
  static const String groupNameHint = "Enter group name";
  static const String members = "Members";
  static const String membersSublabel = "Primary participants";
  static const String companions = "Companions";
  static const String companionsSublabel = "Additional guests";
  static const String groupPricingNote =
      "Pricing is calculated per member. Companions may be subject to different rates depending on the destination.";

  static const String institutionName = "INSTITUTION NAME";
  static const String institutionNameHintCollege = "Enter college or university name";
  static const String institutionNameHintSchool = "Enter school or institution name";
  static const String students = "Students";
  static const String studentsSublabel = "Cost applicable";
  static const String staff = "Staff";
  static const String staffSublabel = "No cost applied";
  static const String institutionPricingNote =
      "Per-student cost is calculated for enrolled students. Staff travel is included at no extra cost.";

  static const String emergencyContact = "Emergency Contact";
  static const String name = "NAME";
  static const String contactNameHint = "Contact person name";
  static const String phoneNumber = "PHONE NUMBER";
  static const String phoneHint = "+91 00000-00000";
  static const String inspirationCaption = "Inspiration for your route";
  static const String nextDestinations = "Next: Destinations";
}

class DestinationsStrings {
  DestinationsStrings._();

  static const String title = "Destinations & Route";
  static const String totalStops = "TOTAL STOPS";
  static const String totalNights = "TOTAL NIGHTS";
  static const String estDistance = "EST. DISTANCE";
  static const String driveTime = "DRIVE TIME";
  static const String itineraryStops = "ITINERARY STOPS";
  static const String reorder = "Reorder";
  static const String addDestination = "Add Another Destination";
  static const String nextServices = "Next: Services";
}
