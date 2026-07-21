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
  static const String recentActivity = "Recent Activity";
}

class WizardStrings {
  WizardStrings._();

  static const List<String> stepLabels = ['Basics', 'Destinations', 'Participants', 'Services', 'Review'];
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
  static const String mapPreview = "Map Preview";
  static const String addDestination = "Add Another Destination";
  static const String nextParticipants = "Next: Participants";
  static const String prefilledFromPrefix = "Prefilled from: ";
  static const String prefilledFromSuffix = " template — all destinations are editable — customize as needed.";
}

class ParticipantsStrings {
  ParticipantsStrings._();

  static const String title = "Who's going on this trip?";
  static const String subtitle = "Student costs are calculated from logistics. Staff travel free as part of the group package.";
  static const String costApplicableYes = "COST APPLICABLE · Yes";
  static const String costApplicableNo = "COST APPLICABLE · No";
  static const String minParticipantsError = "At least 1 participant is required to create a trip";
  static const String vehicleCapacity = "Vehicle Capacity";
  static const String fitsComfortably = "All participants fit comfortably";
  static const String seatsSpareSuffix = "seats spare";
  static const String overCapacity = "Over capacity for this vehicle class";
  static const String ratioLabel = "Current Student-to-Staff Ratio is";
  static const String ratioOptimal = "OPTIMAL";
  static const String ratioReview = "REVIEW";
  static const String summaryPreview = "Summary Preview";
  static const String totalHeads = "TOTAL HEADS";
  static const String estPerStudent = "EST. /STUDENT";
  static const String estimatedTotal = "Estimated Total Cost";
  static const String nextServices = "Next: Services";
}

class ServicesStrings {
  ServicesStrings._();

  static const String title = "Services";
  static const String infoNote = "All services are optional. Toggle on only what your trip needs. You can refine these details later during the finalization stage.";
  static const String vehicle = "Vehicle";
  static const String vehicleSubtitle = "Transport";
  static const String hotel = "Hotel";
  static const String hotelSubtitle = "Accommodation";
  static const String restaurant = "Restaurant / Food";
  static const String restaurantSubtitle = "Dining";
  static const String activities = "Activities";
  static const String activitiesSubtitle = "Experiences";
  static const String chooseVehicle = "Choose Vehicle";
  static const String chooseHotel = "Choose Hotel";
  static const String chooseRestaurant = "Choose Restaurant";
  static const String chooseActivities = "Choose Activities";
  static const String addAnotherActivity = "+ Add Another Activity";
  static const String change = "Change";
  static const String costBreakdown = "SERVICES COST BREAKDOWN";
  static const String vehicleTotal = "Vehicle Total";
  static const String hotelTotal = "Hotel Total";
  static const String diningTotal = "Dining Total";
  static const String activitiesTotal = "Activities Total";
  static const String subtotal = "Subtotal";
  static const String managementBuffer = "Management Buffer (5%)";
  static const String grandTotal = "GRAND TOTAL";
  static const String perStudent = "PER STUDENT";
  static const String nextReview = "Next: Review";
  static const String generateItinerary = "Generate Itinerary";
}

class TransportSelectionStrings {
  TransportSelectionStrings._();

  static const String title = "Transport Selection";
  static const String privateOperators = "Private Operators";
  static const String privateOperatorsSubtitle = "Existing vendor network";
  static const String recommended = "RECOMMENDED";
  static const String ksrtc = "KSRTC";
  static const String ksrtcSubtitle = "Kerala's official state transport corporation";
  static const String mostTrusted = "MOST TRUSTED · BEST RATES";
  static const String tapToContinue = "Tap a card to continue";
}

class VehicleTypeStrings {
  VehicleTypeStrings._();

  static const String title = "Select Vehicle Type";
  static const String selectToView = "Select a type to view available fleet";
  static const String acSleeperBus = "AC Sleeper Bus";
  static const String acSleeperBusSubtitle = "Best for long-distance, large groups";
  static const String nonAcSleeperBus = "Non-AC Sleeper Bus";
  static const String nonAcSleeperBusSubtitle = "Budget-friendly option";
  static const String tempoTraveller = "Tempo Traveller";
  static const String tempoTravellerSubtitle = "Ideal for small to mid-size groups";
  static const String miniBus = "Mini Bus";
  static const String miniBusSubtitle = "Compact groups, shorter routes";
  static const String car = "Car";
  static const String carSubtitle = "Best for small groups, up to 7 people";
}

class VendorListingStrings {
  VendorListingStrings._();

  static const String bestMatch = "BEST MATCH";
  static const String select = "Select";
  static const String perTrip = "/trip";
  static const String tripsSuffix = "trips";
  static const String fitsYourGroup = "Fits your group";
  static const String seatCapacity = "SEAT CAPACITY";
}

class SelectHotelStrings {
  SelectHotelStrings._();

  static const String title = "Select Hotel";
  static const String searchHint = "Search hotels...";
  static const String allDestinations = "All Destinations";
  static const String allRatings = "All Ratings";
  static const String budget = "Budget";
  static const String fitsYourGroup = "Fits your group";
  static const String insufficientCapacityPrefix = "Max";
  static const String insufficientCapacitySuffix = "guests — insufficient";
  static const String selectThisHotel = "Select This Hotel";
  static const String perNight = "/night";
}

class HotelDetailStrings {
  HotelDetailStrings._();

  static const String about = "About";
  static const String amenities = "Amenities";
  static const String roomTypes = "Room Types";
  static const String guestsSuffix = "GUESTS";
  static const String roomsNeeded = "ROOMS NEEDED";
  static const String mealPlan = "Meal Plan";
  static const String breakfast = "Breakfast";
  static const String lunch = "Lunch";
  static const String dinner = "Dinner";
  static const String addToTrip = "Add to Trip";
}

class ChooseRestaurantStrings {
  ChooseRestaurantStrings._();

  static const String title = "Choose a Restaurant";
  static const String searchHint = "Search restaurants";
  static const String vegOnly = "Veg Only";
  static const String nonVegAvailable = "Non-Veg Available";
  static const String underBudget = "Under ₹150";
  static const String capacity = "CAPACITY";
  static const String plan = "PLAN";
  static const String mealsPerDaySuffix = "meals/day";
  static const String avgCost = "AVG COST";
  static const String perHead = "/head";
  static const String viewMenu = "View Menu";
}

class RestaurantMenuStrings {
  RestaurantMenuStrings._();

  static const String titlePrefix = "Menu — ";
  static const String stepPrefix = "STEP ";
  static const String stepOf = " OF ";
  static const String selectingDishesFor = "Selecting dishes for Day ";
  static const String veg = "Veg";
  static const String nonVeg = "Non-Veg";
  static const String noDishesSelected = "No dishes selected yet";
  static const String browseMenuHint = "Browse the menu below and tap + to add dishes for this day";
  static const String continueToDay = "Continue to Day ";
  static const String reviewAll = "Review All";
  static const String dishesSelected = "dishes selected";
  static const String planQuantities = "Plan quantities for this menu";
}

class RestaurantReviewStrings {
  RestaurantReviewStrings._();

  static const String title = "Review & Confirm";
  static const String subtitle = "Final menu across all days";
  static const String grandTotal = "Grand Total";
  static const String addToTrip = "Add to Trip";
}

class VehicleDetailStrings {
  VehicleDetailStrings._();

  static const String operatorInfo = "OPERATOR INFO";
  static const String fleetSize = "Fleet Size";
  static const String baseLocation = "Base Location";
  static const String contactNote = "Contact details managed by TripConsole — direct contact not permitted before booking confirmation.";
  static const String tripSummary = "TRIP SUMMARY";
  static const String reviews = "REVIEWS";
  static const String viewAll = "View all";
  static const String viewPricingDetails = "View Pricing Details";
  static const String pricingDetailsTitle = "Pricing Details";
  static const String baseFare = "Base Fare";
  static const String driverAllowance = "Driver Allowance";
  static const String nightHaltCharge = "Night Halt Charge";
  static const String tollParking = "Toll and Parking";
  static const String tollParkingNote = "Excluded — billed separately by the operator.";
  static const String total = "Total";
  static const String confirmSelection = "Confirm Selection";
  static const String close = "Close";
}

class VehicleCapacityMismatchStrings {
  VehicleCapacityMismatchStrings._();

  static const String title = "Capacity Mismatch";
  static const String heading = "The selected vehicle cannot accommodate your group";
  static const String selectedVehicle = "SELECTED VEHICLE";
  static const String yourParticipants = "YOUR PARTICIPANTS";
  static const String shortfall = "SHORTFALL";
  static const String chooseResolution = "CHOOSE A RESOLUTION";
  static const String selectLargerTitle = "Select a larger vehicle";
  static const String selectLargerRecommended = "RECOMMENDED";
  static const String selectLargerBody = "Choose a vehicle class that fits all your participants.";
  static const String browseVehicles = "Browse vehicles";
  static const String addSecondTitle = "Add a second vehicle";
  static const String addSecondBody = "Combine two vehicles to cover all participants.";
  static const String browseSecondVehicle = "Browse second vehicle";
  static const String reduceTitle = "Reduce participant count";
  static const String reduceBody = "Go back and update participant numbers.";
  static const String editParticipants = "Edit participants";
}

class MultiVehicleStrings {
  MultiVehicleStrings._();

  static const String needSuffix = "seats — need";
  static const String vehiclesSelected = "vehicles selected";
  static const String seatsCovered = "seats covered";
  static const String continueLabel = "Continue";
  static const String combineNotice = "This vehicle class seats fewer than your group — combine multiple vehicles to cover everyone.";
}

class RoutePreviewStrings {
  RoutePreviewStrings._();

  static const String title = "Route Preview";
  static const String itineraryOverview = "Itinerary Overview";
  static const String distance = "DISTANCE";
  static const String estTime = "EST. TIME";
  static const String routeLegs = "ROUTE LEGS";
  static const String reorderRoute = "Reorder Route";
  static const String mapPreview = "Map Preview";
  static const String disclaimer = "Route and times are estimated. Actual times depend on traffic and stops.";
  static const String looksGoodContinue = "Looks good — Continue";
}

class PickOnMapStrings {
  PickOnMapStrings._();

  static const String title = "Pick on Map";
  static const String searchHint = "Search a location or place";
  static const String confirmLocation = "Confirm Location";
}

class ReviewStrings {
  ReviewStrings._();

  static const String title = "Review Trip";
  static const String finalReviewBanner = "Final Review: All components validated. Proceed to final confirmation.";
  static const String tripSummary = "Trip Summary";
  static const String destinations = "Destinations";
  static const String participants = "Participants";
  static const String services = "Services";
  static const String estimatedCost = "Estimated Cost";
  static const String submitForVerification = "Submit for Verification";
  static const String routeDetails = "Route Details";
  static const String departure = "DEPARTURE";
  static const String arrival = "ARRIVAL";
  static const String travelersTotal = "Travelers Total";
  static const String servicesAndLogistics = "Services & Logistics";
  static const String costSnapshot = "Cost Snapshot";
  static const String baseExpeditionCost = "Base Expedition Cost";
  static const String premiumAddOns = "Premium Add-ons";
  static const String totalEstimate = "Total Estimate";
  static const String itineraryPreview = "Itinerary Preview";
  static const String continueToDeclarations = "Continue to Declarations";
}

class DeclarationsStrings {
  DeclarationsStrings._();

  static const String title = "Declarations";
  static const String beforeYouSubmit = "Before you submit";
  static const String subtitle = "Please review and confirm the following declarations to finalize your itinerary.";
  static const String infoAccuracyTitle = "Information Accuracy";
  static const String infoAccuracyBody = "I hereby declare that all information provided regarding trip dates, passengers, and destinations is accurate to the best of my knowledge.";
  static const String institutionalApprovalTitle = "Institutional Approval";
  static const String institutionalApprovalBody = "I confirm that I have the necessary authority to submit this itinerary for official processing and that it aligns with organizational travel policies.";
  static const String costReviewTitle = "Cost Review & Acceptance";
  static const String costReviewBodyPrefix = "I acknowledge the estimated total cost of ";
  static const String costReviewBodySuffix = " and the non-refundable processing fee.";
  static const String confirmAllPrompt = "Confirm all 3 declarations to submit";
  static const String submitTrip = "Submit Trip";
  static const String backToEdit = "Back to Edit";
}

class SubmitConfirmationStrings {
  SubmitConfirmationStrings._();

  static const String title = "Submit this trip?";
  static const String body = "Please review your expedition details before finalizing your submission.";
  static const String totalCost = "TOTAL COST";
  static const String budgetAuthenticated = "Budget Authenticated";
  static const String timelineConfirmed = "Timeline Confirmed";
  static const String permitsVerified = "Permits & Risks Verified";
  static const String yesSubmit = "Yes, Submit Trip";
  static const String goBack = "Go Back — Review Again";
}

class ItineraryGeneratingStrings {
  ItineraryGeneratingStrings._();

  static const String title = "Building your itinerary…";
  static const String step1 = "Validating destinations";
  static const String step2 = "Syncing travel preferences";
  static const String step3 = "Generating day timeline";
  static const String step4 = "Finalizing itinerary";
}

class ItineraryDayStrings {
  ItineraryDayStrings._();

  static const String title = "Trip Itinerary";
  static const String addBlock = "Add block";
  static const String totalDailyExpense = "TOTAL DAILY EXPENSE";
  static const String nextDayPrefix = "Next: Day ";
  static const String reviewTrip = "Review Trip";
}

class EditBlockStrings {
  EditBlockStrings._();

  static const String title = "Edit Block";
  static const String addTitle = "Add Block";
  static const String blockType = "BLOCK TYPE";
  static const String activityName = "ACTIVITY NAME";
  static const String location = "LOCATION";
  static const String startTime = "START TIME";
  static const String duration = "DURATION";
  static const String costPerStudent = "COST PER STUDENT";
  static const String staffFree = "Staff Free";
  static const String organizerNotes = "ORGANIZER NOTES";
  static const String organizerNotesHint = "Wear comfortable shoes, carry water bottles...";
  static const String saveBlock = "Save Block";
  static const String deleteBlock = "Delete block";
  static const String cancel = "Cancel";
}

class PlanQuantitiesStrings {
  PlanQuantitiesStrings._();

  static const String title = "Plan Quantities";
  static const String stepPrefix = "STEP ";
  static const String settingQuantitiesFor = "Setting quantities for Day ";
  static const String totalAttendees = "TOTAL ATTENDEES";
  static const String vegMeals = "Veg meals";
  static const String nonVegMeals = "Non-veg meals";
  static const String scopeNote = "These totals apply across all days — only dish choices differ per day.";
  static const String unassignedPrefix = "portions unassigned for Day ";
  static const String unassignedSuffix = " — adjust quantities below.";
  static const String pricingSummary = "PRICING SUMMARY";
  static const String subtotal = "Subtotal";
  static const String serviceTax = "Service Tax (5%)";
  static const String dayTotal = "Total";
  static const String continueToDay = "Continue to Day ";
  static const String continueToReview = "Continue to Review";
  static const String portionsPlannedSuffix = "portions planned";
}

class SubmittingTripStrings {
  SubmittingTripStrings._();

  static const String title = "Submitting your trip…";
  static const String step1 = "Validating details";
  static const String step2 = "Locking cost snapshot";
  static const String step3 = "Sending to admin queue";
  static const String step4 = "Generating confirmation";
}

class TripSubmittedStrings {
  TripSubmittedStrings._();

  static const String title = "Trip Submitted!";
  static const String body = "Your journey has been officially logged. Our concierge team is now preparing the final logistics for your premium travel experience.";
  static const String tripReference = "TRIP REFERENCE";
  static const String totalInvestment = "TOTAL INVESTMENT";
  static const String submissionDate = "Submission Date";
  static const String whatHappensNext = "What Happens Next";
  static const String adminReviewTitle = "Admin Review";
  static const String adminReviewBody = "A travel specialist verifies your itinerary details.";
  static const String operatorTitle = "Operator Assignment";
  static const String operatorBody = "Local logistics partners are booked and confirmed.";
  static const String paymentTitle = "Payment";
  static const String paymentBody = "Final secure link sent to complete your booking.";
  static const String payment = "Payment";
  static const String backToDashboard = "Back to Dashboard";
  static const String emailNote = "Confirmation sent to your registered email";
  static const String conciergeActive = "24/7 Digital Concierge Support Active";
}

class TripDetailStrings {
  TripDetailStrings._();

  static const String title = "Trip Details";
  static const String underAdminReview = "UNDER ADMIN REVIEW";
  static const String underAdminReviewBody = "Estimated confirmation within 24-48 hours";
  static const String verifiedTitle = "You're Verified! 🎉";
  static const String verifiedBody = "Your trip has been confirmed by our team. Complete your payment to lock in your booking.";
  static const String balanceCleared = "Balance Cleared";
  static const String balanceDue = "BALANCE DUE";
  static const String fullyPaid = "Fully Paid";
  static const String verificationStatus = "VERIFICATION STATUS";
  static const String stepSubmitted = "Submitted";
  static const String stepAdminVerification = "Admin Verification";
  static const String stepOperatorAssignment = "Operator Assignment";
  static const String stepPayment = "Payment";
  static const String inProgress = "IN PROGRESS";
  static const String pending = "PENDING";
  static const String lockedNote = "Locked until verification completes";
  static const String assignedOperator = "Assigned Operator";
  static const String fieldCoordinator = "Field Coordinator";
  static const String costBreakdown = "COST BREAKDOWN";
  static const String transport = "Transport";
  static const String accommodation = "Accommodation";
  static const String activities = "Activities";
  static const String total = "Total";
  static const String documents = "Documents";
  static const String choosePaymentPlan = "Choose Payment Plan";
  static const String remindMeLater = "Remind me later";
  static const String payBalanceNow = "Pay Balance Now";
  static const String viewItinerary = "View Itinerary";
  static const String downloadReceipt = "Download Receipt";
  static const String needHelp = "Need Help?";
  static const String conciergeSupportBody = "24/7 Digital Concierge Support";
  static const String chatNow = "Chat Now";
}

class PaymentPlanStrings {
  PaymentPlanStrings._();

  static const String title = "Payment";
  static const String choosePlanPrompt = "Choose your preferred payment plan";
  static const String payFullAmount = "Pay Full Amount";
  static const String recommended = "RECOMMENDED";
  static const String payFullBody = "Pay everything now and confirm your booking immediately.";
  static const String payAdvance = "Pay Advance";
  static const String flexible = "FLEXIBLE";
  static const String payAdvanceBodyPrefix = "Remaining ";
  static const String payAdvanceBodySuffix = " due by ";
  static const String payNowPrefix = "Pay ₹";
  static const String payNowSuffix = " Now";
}

class PaymentMethodStrings {
  PaymentMethodStrings._();

  static const String title = "Payment Method";
  static const String totalTripCost = "TOTAL TRIP COST";
  static const String advanceAmount = "ADVANCE AMOUNT";
  static const String payingInFull = "Paying in full";
  static const String payingAdvance = "Paying Advance (20%)";
  static const String remainingDuePrefix = "Remaining ₹";
  static const String remainingDueSuffix = " due by ";
  static const String choosePaymentMethod = "CHOOSE PAYMENT METHOD";
  static const String creditDebitCard = "Credit / Debit Card";
  static const String cardNetworks = "Visa, Mastercard, AMEX";
  static const String upi = "UPI";
  static const String upiApps = "GPay, PhonePe, BHIM";
  static const String netBanking = "Net Banking";
  static const String netBankingBody = "All major Indian banks";
  static const String securityNote = "SSL Encrypted & PCI DSS Compliant";
}

class PaymentProcessingStrings {
  PaymentProcessingStrings._();

  static const String title = "Processing your payment…";
  static const String body = "Please don't close this screen. This usually takes a few seconds.";
  static const String securityNote = "Your payment is secured and encrypted";
}

class PaymentResultStrings {
  PaymentResultStrings._();

  static const String fullSuccessTitle = "Payment Successful — Trip Fully Confirmed!";
  static const String fullSuccessBody = "Your trip is now fully paid and booked. No further payments needed.";
  static const String advanceSuccessTitle = "Advance Payment Received — Trip Reserved!";
  static const String advanceSuccessBody = "Your spot is secured. Please complete the remaining balance before your trip start date to fully confirm your booking.";
  static const String balanceSuccessTitle = "Balance Cleared — Trip Fully Confirmed!";
  static const String balanceSuccessBody = "You've completed all payments for this trip. We'll see you there!";
  static const String amountPaid = "AMOUNT PAID";
  static const String balanceAmountPaid = "BALANCE AMOUNT PAID";
  static const String transactionId = "Transaction ID";
  static const String dateTime = "Date & Time";
  static const String paymentMethod = "Payment Method";
  static const String amountPaidLabel = "Amount Paid";
  static const String remainingBalance = "Remaining Balance";
  static const String balanceDueDate = "Balance Due Date";
  static const String paidPercent = "paid";
  static const String remainingPercent = "remaining";
  static const String viewTripDetails = "View Trip Details";
  static const String downloadReceipt = "Download Receipt";
  static const String emailNote = "Confirmation email sent to";
  static const String needHelp = "Need help?";
  static const String contactConcierge = "Contact Concierge";
}

class PaymentFailedStrings {
  PaymentFailedStrings._();

  static const String title = "Payment Failed";
  static const String body = "We couldn't process your transaction";
  static const String transactionDetails = "TRANSACTION DETAILS";
  static const String reasonPrefix = "Reason: ";
  static const String defaultReason = "Card declined by issuing bank";
  static const String whatToDoNext = "What to do next";
  static const String tip1 = "Check card limits and balance for sufficient funds.";
  static const String tip2 = "Try another payment method or credit card.";
  static const String tip3 = "Contact your issuing bank for more details.";
  static const String tryAgain = "Try Again";
  static const String payLater = "Pay Later";
}

class BookHotelStrings {
  BookHotelStrings._();

  static const String title = "Book Hotel";
  static const String saveDraft = "Save Draft";
  static const String hotelOnlyBanner = "Hotel Only Booking · No full trip required";
  static const String stepPrefix = "STEP 1 OF 5 — STAY DETAILS";
  static const String bookingFor = "Booking for";
  static const String tripType = "TRIP TYPE";
  static const String destinationAndDates = "DESTINATION & DATES";
  static const String stayLocation = "STAY LOCATION";
  static const String stayLocationHint = "Where are you heading?";
  static const String purposeOfStay = "PURPOSE OF STAY";
  static const String purposeOfStayHint = "e.g. Team offsite, corporate event";
  static const String checkIn = "CHECK-IN";
  static const String checkOut = "CHECK-OUT";
  static const String selectDates = "Select dates";
  static const String nightsSuffix = "NIGHTS";
  static const String groupRequirements = "GROUP REQUIREMENTS";
  static const String guests = "GUESTS";
  static const String soloTraveler = "SOLO TRAVELER";
  static const String roomsRequired = "Rooms Required";
  static const String autoCalculatedPrefix = "Auto-calculated: ~";
  static const String roomPreferences = "ROOM PREFERENCES";
  static const String hotelRating = "HOTEL RATING";
  static const String amenities = "AMENITIES";
  static const String specialRequirements = "SPECIAL REQUIREMENTS";
  static const String vegetarianMeals = "Vegetarian meals included";
  static const String breakfastIncluded = "Breakfast included";
  static const String acRooms = "AC rooms required";
  static const String conferenceHall = "Conference hall";
  static const String accessibleRooms = "Accessible rooms needed";
  static const String earlyCheckIn = "Early check-in";
  static const String estimatedTotal = "ESTIMATED TOTAL";
  static const String perPerson = "PER PERSON";
  static const String searchHotels = "Search Hotels";
}

class SelectStayLocationStrings {
  SelectStayLocationStrings._();

  static const String title = "Select Stay Location";
  static const String searchHint = "Search city, town or landmark…";
  static const String mapPreviewPrefix = "MAP PREVIEW: ";
  static const String recentAndSuggested = "RECENT & SUGGESTED";
  static const String confirmDestination = "Confirm Destination";
}

class SelectStayDatesStrings {
  SelectStayDatesStrings._();

  static const String title = "Select Stay Dates";
  static const String checkInPrefix = "Check-in: ";
  static const String checkOutPrefix = "Check-out: ";
  static const String confirmStayDates = "Confirm Stay Dates";
}

class RoomTypePreferenceStrings {
  RoomTypePreferenceStrings._();

  static const String title = "Room Type Preference";
  static const String tripleSharing = "Triple Sharing";
  static const String tripleSharingBody = "3 per room, most economical";
  static const String dormitory = "Dormitory";
  static const String dormitoryBody = "8-12 per room, lowest cost";
  static const String doubleRoom = "Double Room";
  static const String doubleRoomBody = "2 per room, for teachers";
  static const String applyRoomType = "Apply Room Type";
}

class HotelResultsStrings {
  HotelResultsStrings._();

  static const String title = "Hotel Results";
  static const String filterAll = "All";
  static const String filterBudget = "Budget";
  static const String filterHeritage = "Heritage";
  static const String filterWithMeal = "With Meal";
  static const String hotelsFoundSuffix = "HOTELS";
  static const String paxSuffix = "PAX";
  static const String viewRooms = "View Rooms";
  static const String perNight = "/night";
  static const String total = "Total";
}

class ServiceHotelDetailStrings {
  ServiceHotelDetailStrings._();

  static const String capacity = "CAPACITY";
  static const String rating = "RATING";
  static const String since = "SINCE";
  static const String town = "TOWN";
  static const String about = "About";
  static const String amenities = "Amenities";
  static const String roomTypes = "Room Types";
  static const String selected = "Selected";
  static const String select = "Select";
  static const String fullyBooked = "N/A";
  static const String mealPlan = "Meal Plan";
  static const String reviews = "Reviews";
  static const String seeAll = "See all";
  static const String roomsNightsPrefix = "Rooms · ";
  static const String nightsSuffix = " Nights";
  static const String proceed = "Proceed";
}

class SelectMealPlanStrings {
  SelectMealPlanStrings._();

  static const String title = "Select Meal Plan";
  static const String roomOnly = "Room Only (EP)";
  static const String continentalPlan = "Continental Plan (CP)";
  static const String continentalBody = "Breakfast only";
  static const String modifiedAmerican = "Modified American Plan (MAP)";
  static const String modifiedAmericanBody = "Breakfast + Dinner";
  static const String perDaySuffix = "/day";
  static const String confirmMealPlan = "Confirm Meal Plan";
}

class HotelBookingSummaryStrings {
  HotelBookingSummaryStrings._();

  static const String title = "Hotel Booking Summary";
  static const String stepPrefix = "STEP 4 OF 5 — REVIEW BOOKING";
  static const String stayDetails = "Stay Details";
  static const String hotel = "Hotel";
  static const String roomType = "Room Type";
  static const String checkIn = "Check-In";
  static const String checkOut = "Check-Out";
  static const String duration = "Duration";
  static const String guests = "Guests";
  static const String mealPlan = "Meal Plan";
  static const String costBreakdown = "Cost Breakdown";
  static const String roomCost = "Room Cost";
  static const String mealCost = "Meal Cost";
  static const String taxes = "Taxes (18% GST)";
  static const String totalAmount = "Total Amount";
  static const String allInclusive = "ALL INCLUSIVE";
  static const String cancellationPolicy = "Cancellation Policy";
  static const String cancellationPolicyBody = "Cancellations made up to 7 days before check-in will receive a 100% refund. For cancellations within 48 hours, a 50% refund is applicable. No-shows are non-refundable.";
  static const String hotelManager = "Hotel Manager (Verified Contact)";
  static const String confirmAndProceed = "Confirm & Proceed";
}

class ConfirmHotelBookingStrings {
  ConfirmHotelBookingStrings._();

  static const String title = "Confirm Booking";
  static const String totalPrice = "TOTAL PRICE";
  static const String confirmCheckbox = "I confirm the stay details and group count are correct and agree to the resort's cancellation policy.";
  static const String confirmHotelBooking = "Confirm Hotel Booking";
  static const String goBackAndEdit = "Go Back & Edit";
}

class BookRestaurantStrings {
  BookRestaurantStrings._();

  static const String title = "Book Restaurant";
  static const String restaurantOnlyBanner = "Restaurant / Catering Only · No full trip required";
  static const String stepPrefix = "STEP 1 OF 5 — MEAL REQUIREMENTS";
  static const String tripType = "TRIP TYPE";
  static const String mealLocation = "MEAL LOCATION";
  static const String mealLocationHint = "Where do you need meals?";
  static const String mealDates = "MEAL DATE(S)";
  static const String selectDates = "Select date(s)";
  static const String daysSelectedSuffix = " days selected";
  static const String mealsRequired = "MEALS REQUIRED";
  static const String breakfast = "Breakfast";
  static const String lunch = "Lunch";
  static const String dinner = "Dinner";
  static const String editHeadcounts = "Edit headcounts";
  static const String groupRequirements = "GROUP REQUIREMENTS";
  static const String dietPreference = "DIET PREFERENCE";
  static const String vegOnly = "Veg Only";
  static const String nonVegAvailable = "Non-veg available";
  static const String both = "Both";
  static const String cateringStyle = "CATERING STYLE";
  static const String buffet = "Buffet";
  static const String packedLunch = "Packed Lunch / Tiffin";
  static const String preOrderedFixedMenu = "Pre-ordered Fixed Menu";
  static const String estimatedTotal = "ESTIMATED TOTAL";
  static const String perPerson = "PER PERSON";
  static const String searchRestaurants = "Search Restaurants";
}

class SelectMealLocationStrings {
  SelectMealLocationStrings._();

  static const String title = "Select Meal Location";
  static const String searchHint = "Search restaurant area or locality…";
  static const String mapPreviewPrefix = "MAP PREVIEW: ";
  static const String recentAndSuggested = "RECENT & SUGGESTED";
  static const String confirmMealLocation = "Confirm Meal Location";
}

class SelectMealDatesStrings {
  SelectMealDatesStrings._();

  static const String title = "Select Meal Dates";
  static const String selectedDates = "SELECTED DATES";
  static const String select7Days = "Select 7 Days";
  static const String weekdaysOnly = "Weekdays Only";
  static const String clearAll = "Clear All";
  static const String confirmDatesPrefix = "Confirm Dates (";
  static const String confirmDatesSuffix = " selected)";
}

class SelectMealTypesStrings {
  SelectMealTypesStrings._();

  static const String title = "Select Meal Types";
  static const String countsPrefilledNote = "Counts are pre-filled from your group size. Adjust per meal if some students skip.";
  static const String breakfast = "Breakfast";
  static const String lunch = "Lunch";
  static const String dinner = "Dinner";
  static const String notSelected = "Not selected";
  static const String selected = "Selected";
  static const String headcountPerMeal = "HEADCOUNT PER MEAL";
  static const String confirmMealTypesPrefix = "Confirm Meal Types (";
}

class RestaurantSearchResultsStrings {
  RestaurantSearchResultsStrings._();

  static const String title = "Restaurant Results";
  static const String filterAll = "All";
  static const String filterPureVeg = "Pure Veg";
  static const String filterBuffet = "Buffet";
  static const String filterCater = "Cater";
  static const String restaurantsFoundSuffix = "RESTAURANTS";
  static const String paxSuffix = "PAX";
  static const String viewMenu = "View Menu";
  static const String perHead = "/head";
}

class RestaurantMenuPlanningStrings {
  RestaurantMenuPlanningStrings._();

  static const String capacity = "CAPACITY";
  static const String rating = "RATING";
  static const String dietary = "DIETARY";
  static const String since = "SINCE";
  static const String about = "About";
  static const String vegMenu = "Veg Menu";
  static const String overview = "Overview";
  static const String groupDeals = "Group Deals";
  static const String selectedForPrefix = "Selected for ";
  static const String selectedForSuffix = " people";
  static const String reviewDietarySummary = "Review Dietary Summary";
  static const String proceed = "Proceed";
}

class DietarySummaryStrings {
  DietarySummaryStrings._();

  static const String title = "Dietary Summary";
  static const String readyToShare = "Ready to share with your restaurant";
  static const String day = "Day";
  static const String portions = "portions";
  static const String close = "Close";
}

class MealBookingSummaryStrings {
  MealBookingSummaryStrings._();

  static const String title = "Meal Booking Summary";
  static const String stepPrefix = "STEP 4 OF 5 — REVIEW BOOKING";
  static const String mealDetails = "Meal Details";
  static const String location = "Location";
  static const String schedule = "Schedule";
  static const String mealType = "Meal Type";
  static const String dietaryPreferences = "Dietary Preferences";
  static const String totalGuests = "Total Guests";
  static const String participants = "Participants";
  static const String costBreakdown = "Cost Breakdown";
  static const String serviceCharge = "Service Charge (5%)";
  static const String totalPayable = "Total Payable";
  static const String bookingTerms = "Booking Terms";
  static const String bookingTermsBody = "Prices are inclusive of all local taxes and institutional discounts. Cancellations made up to 48 hours before the first meal date receive a full refund.";
  static const String onSiteContact = "On-site Contact";
  static const String confirmAndProceed = "Confirm & Proceed";
}

class ConfirmMealBookingStrings {
  ConfirmMealBookingStrings._();

  static const String title = "Confirm Your Meals";
  static const String noPaymentNote = "This sends a booking request to the operator. No payment is required at this step.";
  static const String confirm = "Confirm";
}

class SendingMealRequestStrings {
  SendingMealRequestStrings._();

  static const String title = "Sending Meal Request…";
  static const String notifyingPrefix = "Notifying ";
  static const String notifyingSuffix = " about your group meals.";
  static const String step1 = "Verifying menu & dates";
  static const String step2 = "Confirming group capacity…";
  static const String step3 = "Awaiting restaurant confirmation";
  static const String secureTransaction = "SECURE TRANSACTION";
}

class MealBookingSentStrings {
  MealBookingSentStrings._();

  static const String title = "Meal Booking Sent!";
  static const String awaitingConfirmation = "AWAITING RESTAURANT CONFIRMATION";
  static const String dates = "DATES";
  static const String group = "GROUP";
  static const String totalAmount = "TOTAL AMOUNT";
  static const String whatsNext = "What's Next?";
  static const String step1Title = "Operator Confirms";
  static const String step1Body = "Operator will confirm capacity within 2 hours.";
  static const String step2Title = "Payment Link";
  static const String step2Body = "A payment link will be sent to your dashboard.";
  static const String step3Title = "Advance Payment";
  static const String step3Body = "Complete 30% advance payment to lock booking.";
  static const String viewAllBookings = "View All Bookings";
  static const String goToDashboard = "Go to Dashboard →";
}

class LockedItineraryStrings {
  LockedItineraryStrings._();

  static const String title = "Itinerary";
  static const String itineraryLocked = "ITINERARY LOCKED";
  static const String scheduleOverview = "Schedule Overview";
  static const String eventsSuffix = "events";
  static const String startSuffix = "Start";
  static const String lockedNotice = "This itinerary is currently locked for booking. Modifications are disabled until the reservation window re-opens. Contact your concierge for manual overrides.";
  static const String viewMap = "View Map";
  static const String shareTrip = "Share Trip";
  static const String dayPrefix = "Day ";
  static const String totalDailyExpense = "TOTAL DAILY EXPENSE";
}

class PaymentReceiptStrings {
  PaymentReceiptStrings._();

  static const String title = "Payment Receipt";
  static const String receiptFor = "RECEIPT FOR";
  static const String tripReference = "TRIP REFERENCE";
  static const String issuedOn = "ISSUED ON";
  static const String advancePayment = "Advance Payment";
  static const String balancePayment = "Balance Payment";
  static const String totalPaid = "Total Paid";
  static const String billedTo = "BILLED TO";
  static const String emailedNote = "This receipt has also been emailed to your registered address.";
  static const String downloadAsPdf = "Download as PDF";
  static const String shareReceipt = "Share Receipt";
}

class StartingLocationStrings {
  StartingLocationStrings._();

  static const String title = "Choose Starting Location";
  static const String searchHint = "Search for a place";
  static const String searchingInKerala = "SEARCHING IN KERALA";
  static const String recentLocations = "RECENT LOCATIONS";
  static const String quickImport = "QUICK IMPORT";
  static const String pasteUrlHint = "Paste a Google Maps link";
  static const String confirmLocation = "Confirm Starting Location";
}

class AddDestinationStrings {
  AddDestinationStrings._();

  static const String title = "Add Destination";
  static const String searchHint = "Search for a destination";
  static const String recent = "RECENT";
  static const String pickOnMap = "Pick on map";
  static const String stayDuration = "How long will you stay?";
  static const String stayDurationSublabel = "Nights at this stop";
  static const String overnightStay = "Add overnight stay?";
  static const String estimatedTravelTime = "Estimated travel time";
  static const String notes = "NOTES";
  static const String notesHint = "Any special instructions for this stop";
  static const String addToRoute = "Add to Route";
  static const String cancel = "Cancel";
}

class AddNewListingStrings {
  AddNewListingStrings._();

  static const String title = "How would you like to start?";
  static const String scratchTitle = "Start from scratch";
  static const String scratchBody = "Build a fully custom itinerary step by step.";
  static const String templateTitle = "Use a reference template";
  static const String templateBody = "Start from a ready-made route and customize it.";
  static const String pilgrimageTitle = "Plan a Pilgrimage Trip";
  static const String pilgrimageBody = "Sabarimala and other pilgrimage programs with coordinator management.";
  static const String singleServiceTitle = "Book a Single Service";
  static const String singleServiceBody = "Just need a hotel, vehicle or restaurant? Book it independently.";
}

class TripSetupStrings {
  TripSetupStrings._();

  static const String title = "Setting up your trip…";
  static const String step1 = "Creating trip ID";
  static const String step2 = "Prefilling destinations from template";
  static const String step3 = "Loading suggested activities";
  static const String step4 = "Opening trip builder";
}

class TemplatesStrings {
  TemplatesStrings._();

  static const String title = "Templates";
  static const String searchHint = "Search templates";
  static const String filters = "Filters";
  static const String templatesFoundSuffix = "TEMPLATES FOUND";
}

class FilterTemplatesStrings {
  FilterTemplatesStrings._();

  static const String title = "Filter Templates";
  static const String tripType = "TRIP TYPE";
  static const String duration = "DURATION";
  static const String category = "CATEGORY";
  static const String budgetRange = "BUDGET RANGE";
  static const String showResultsPrefix = "Show Results";
  static const String reset = "Reset";
}

class PackageDetailStrings {
  PackageDetailStrings._();

  static const String about = "About";
  static const String tripRoute = "Trip Route";
  static const String includedServices = "Included Services";
  static const String sampleItinerary = "Sample Itinerary";
  static const String whatsIncluded = "What's Included";
  static const String pricingBreakdown = "Pricing Breakdown";
  static const String total = "Total";
  static const String useThisTemplate = "Use This Template";
  static const String addToTrip = "Add to Trip";
}

class MyTripsStrings {
  MyTripsStrings._();

  static const String title = "My Trips";
  static const String filterAll = "All";
  static const String tripsFoundSuffix = "TRIPS FOUND";
  static const String emptyTitle = "No trips yet";
  static const String emptyBody =
      "Once you create a trip, it'll show up here with live status, costs and approvals.";
  static const String emptyFeature1 = "Auto-generated itinerary";
  static const String emptyFeature2 = "Transparent cost console";
  static const String emptyFeature3 = "Institutional-grade approval documents";
  static const String createFirstTrip = "CREATE YOUR FIRST TRIP";
  static const String browseTemplates = "Browse reference templates";
}

class ProfileStrings {
  ProfileStrings._();

  static const String title = "Profile";
  static const String accountDetails = "Account Details";
  static const String fullName = "Full Name";
  static const String email = "Email";
  static const String mobile = "Mobile";
  static const String city = "City";
  static const String institution = "Institution";
  static const String security = "Security";
  static const String changePassword = "Change Password";
  static const String twoFactorAuth = "Two-Factor Authentication";
  static const String preferences = "Preferences";
  static const String pushNotifications = "Push Notifications";
  static const String emailAlerts = "Email Alerts";
  static const String smsAlerts = "SMS Alerts";
  static const String supportLegal = "Support & Legal";
  static const String helpCenter = "Help Center";
  static const String terms = "Terms of Service";
  static const String privacy = "Privacy Policy";
  static const String appVersion = "App Version";
  static const String dangerZone = "Danger Zone";
  static const String logout = "Log Out";
  static const String deleteAccount = "Delete Account";
  static const String logoutConfirmTitle = "Log out?";
  static const String logoutConfirmBody = "You'll need to sign in again to access your trips.";
  static const String deleteConfirmTitle = "Delete account?";
  static const String deleteConfirmBody =
      "This permanently deletes your account and all trip data. This cannot be undone.";
  static const String cancel = "Cancel";
}
