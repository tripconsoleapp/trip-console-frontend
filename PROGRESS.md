# Trip.Console — Figma → Flutter Conversion Progress

Figma file: `tripconsole01` (fileKey `qk1ohvNMhw0gDyNLLWDjZx`). Figma MCP is on a
rate-limited Starter plan — it cuts out after ~1 call and resets slowly. When
blocked, the user sends screenshots directly instead (works fine, same result).

---

## 2026-07-19 — Session 1

### Screens/widgets converted so far

| Screen | File | Figma source |
|---|---|---|
| Splash | `lib/screens/splash/splash_screen.dart` | node `1:78` |
| Onboarding slide 1 "Plan Your Escape" | `lib/screens/onboarding/onboarding_screen.dart` | node `1:48` |
| Onboarding slide 2 "Book Your Journey" | same file | node `1:3` |
| Get Started (Create/Sign-in landing) | `lib/screens/onboarding/get_started_screen.dart` | node `1:102` |
| Sign Up (email/password) | `lib/screens/auth/sign_up_screen.dart` | node `1:279` (via user screenshot) |
| Role Selection (3 roles) | `lib/screens/auth/role_selection_screen.dart` | node `1:118` (via user screenshot) |
| Verify Email (6-digit code) | `lib/screens/auth/verify_email_screen.dart` | node `1:171` (via user screenshot) |
| Login (Email/Password + Phone/OTP tabs) | `lib/screens/auth/login_screen.dart` | nodes `1:221` + `3:2` (via user screenshot) |
| Verify OTP (phone) | `lib/screens/auth/verify_otp_screen.dart` | node `3:140` |
| Home Dashboard (Organizer) | `lib/screens/home/home_dashboard_screen.dart` | node `3:416` |
| Trip Builder Step 1: Basics (+ per-type fields) | `lib/screens/trip_builder/trip_basics_screen.dart` | node `13:1397` + `13:998`/`13:1131`/`13:1264` |
| Trip Builder Step 2: Destinations & Route | `lib/screens/trip_builder/trip_destinations_screen.dart` | node `13:1618` |
| Coming Soon placeholder (Operator/Coordinator) | `lib/screens/placeholder/coming_soon_screen.dart` | no Figma source — built to unblock role fork |

Removed: `enter_phone_screen.dart` — folded into Login's Phone/OTP tab, since
Figma actually shows phone entry as a tab on Login, not its own screen.

---

## 2026-07-21 — Session 2: Auth path completed

Finished the rest of the auth flow, all verified pixel-against-Figma-screenshot:

| Screen | File | Figma source |
|---|---|---|
| Forgot Password (Email/Phone tabs, success state) | `lib/screens/auth/forgot_password_screen.dart` | node `3:184` |
| Reset Password (form / success / **Link Expired** states) | `lib/screens/auth/reset_password_screen.dart` | node `3:297` |
| Session Expired | `lib/screens/auth/session_expired_screen.dart` | node `3:381` |

**Widget upgrade**: `LabeledTextField` now supports `prefixIcon` and `obscurable` (password eye-toggle) — applied retroactively to Sign Up and Login's email/password fields to match Figma.

**Login Phone/OTP tab**: added the Field Coordinator specialized-access banner + "New coordinator? Contact Admin" link that was missing from the first pass.

**Real bug found and fixed**: `EmailAuthProvider` is shared between Sign Up and Login (single instance via `MultiProvider`). A failed Login attempt's error message was leaking into the Sign Up screen on next visit, since both screens render `auth.errorMessage` unconditionally. Fixed with a `clearError()` method called from both screens' `initState`.

**Auth phase is now fully built**: Splash → Onboarding → Get Started → Sign Up ⇄ Login (Email/Phone tabs) → Role Selection → Verify Email → Home, plus the full recovery path (Forgot → Reset → success/expired) and Session Expired as a dead-end back to Login.

Not built (not in scope / no Figma source found yet): "Contact Admin" and "Contact support" links are visual-only (empty `onTap`) — no destination screen exists for either.

**Reusable widgets built** (`lib/widgets/`): `glow_blob`, `pulsing_loading_bar`,
`page_indicator_dots`, `full_bleed_photo_background`, `icon_badge_circle`,
`otp_input_row` (configurable `boxSize`/`gap`), `app_bottom_nav_bar`,
`quick_action_chip`, `trip_recommendation_card`, `wizard_header`,
`wizard_step_indicator`, `wizard_bottom_bar`, `labeled_text_field`,
`selectable_chip`, `stat_tile`, `itinerary_stop_card`, `role_card`,
`password_strength_meter`, `social_login_buttons`, `counter_field` (-/value/+ stepper), `info_note` (tinted pricing/policy note box).

**Models**: `trip_type.dart`, `itinerary_stop.dart`, `trip_recommendation.dart`, `user_role.dart`.

**Providers**: `phone_auth_provider.dart`, `email_auth_provider.dart`, `new_trip_provider.dart` (holds trip-creation wizard draft state across all 5 steps).

### Current screen in progress

None mid-build right now — auth flow rebuild just finished and verified.
**Next up is blocked**: Trip Builder Step 3 (Services) — waiting on user
screenshot of Figma node `134:2` ("Trip Creation - Step 5: Services (Full
Content Restored)" — misleadingly named "Step 5" in Figma layers but it's
actually the 3rd tab).

### Patterns/conventions to stay consistent with

- **Folders**: `lib/screens/{feature}/`, `lib/widgets/`, `lib/models/`, `lib/providers/`, `lib/services/`, `lib/utils/`. Feature-grouped screens (`auth/`, `onboarding/`, `home/`, `trip_builder/`, `splash/`, `placeholder/`).
- **Strings**: every screen gets a `XxxStrings` static class in `lib/utils/app_constants.dart` — never hardcode UI text in a screen file.
- **State mgmt**: Provider (`ChangeNotifier`), one provider per domain (not per screen) — e.g. `EmailAuthProvider` spans Sign Up + Login, `NewTripProvider` spans all 5 wizard steps.
- **Routing**: `go_router`, flat top-level routes only (nested `GoRoute.routes` caused a real bug — see below). `AppRouter` class holds path constants + the `router(context)` builder. Pass complex data via `state.extra` (used for `UserRole` on `verifyEmail`/`comingSoon` routes).
- **Widget extraction rule**: anything appearing in 2+ places (or likely to recur across the Figma file) gets pulled into `lib/widgets/` immediately, not left inline.
- **Services never touch Firebase directly from screens** — always through `lib/services/auth_service.dart`, read via a Provider.
- Ran into two real Flutter bugs this session worth remembering:
  - **`WizardBottomBar` broke the whole screen** when used as `Scaffold.bottomNavigationBar` with a bare `DecoratedBox → SafeArea → Row` (unbounded height caused a layout collapse). Fixed by wrapping in `Material` + explicit `SizedBox(height: 84)`. **Any custom bottom bar needs an explicit bounded height.**
  - **`OtpInputRow` needs `gap` sized to digit count** — 4-digit (phone) vs 6-digit (email) codes need different `boxSize`/`gap` or it overflows. Widget now takes both as params.

### Colors / theme (`lib/utils/app_colors.dart`) — confirmed in use

```dart
primaryGreen    = #0D4A3A   // used: stat labels, trip ID banner text
accentOrange    = #FF6B35   // used: primary CTAs, active states, links, badges
mintGreen       = #A8D5C5   // used: subtle backgrounds (trip ID banner, map placeholder)
backgroundWhite = #FFFFFF
textDark        = #1A1A1A
textGrey        = #666666
accentOrangeDark  = #A83900  // derived, splash gradient + badges
accentOrangeDarker= #812900  // derived, splash gradient
error           = #BA1A1A
```
Fonts: **Outfit** (headings) + **Work Sans** (body/labels), via `google_fonts`, defined in `app_text_styles.dart` (`h1/h2/h3`, `bodyLg/bodySm`, `button`, `labelCaps`).

### TODOs / known bugs / flagged-not-fixed

- ~~Trip Basics is incomplete~~ **Fixed 2026-07-20** — all 4 trip-type variants now built and independently visually verified (Individual/Group/College/School), see Session 2 notes below. New reusable widgets: `counter_field.dart`, `info_note.dart`.
- **Email verification isn't actually checked** — Figma specs a 6-digit code, but Firebase Auth's built-in email verification is link-based. Needs a custom backend (e.g. Cloud Function) to generate/send/check a numeric code. `TODO(backend)` comment left in `auth_service.dart`; `VerifyEmailScreen._handleVerify` just proceeds without checking today.
- **"Add Another Destination" button** on Trip Destinations does nothing (no modal/screen built yet — Figma has `14:1754` "Add Destination Modal").
- **Home Dashboard "Plan Pilgrimage Program"** card has an empty `onTap` — whole pilgrimage flow (node cluster around `114:10756`–`114:11015`) not built.
- **Bottom nav "My Trips" and "Profile" tabs** don't navigate anywhere yet (screens not built).
- **Unscoped screens spotted on the Figma canvas, not yet in the build plan**: "Add New Listing", "Templates" (package browsing), "Package Detail" (e.g. "Munnar Hill Station", "Sabarimala 2 Day..."). Not referenced anywhere in this doc before 2026-07-20 — likely belong to an Operator/Coordinator-side listing/package-management flow (those roles are currently stubbed behind the Coming Soon placeholder), but that's a guess. Need the user to say where these fit in priority before scoping node IDs or starting them.
- **Onboarding carousel is honestly 2 slides, not 3** — Figma's own dot indicator implies a 3rd slide that was never designed in the source file. Built as a real 2-page carousel rather than fabricating a slide.
- A full screen-inventory flow map (what's built vs. missing, ~80 screens total) was published as an Artifact mid-session — ask the user for that link if you need the big picture; it may be stale if not re-checked against newer screenshots.

### Next screens to convert, in order

1. **Trip Builder Step 3: Services** — blocked, waiting on screenshot of node `134:2`.
2. **Trip Builder Step 4: Participants** — node `14:2100`.
3. **Trip Builder Step 5: Review** — node `28:9267` + variants (`28:9507`, `28:9574`, `28:9645`).
4. After the wizard: Verification & Payment phase, Post-Booking phase, My Trips list, Profile, Notifications Hub, Pilgrimage flow — see the flow-map artifact for full ordering.

---

## 2026-07-20 — Session 2

### What happened

Picked up mid-session to fix Trip Basics. Found the fix already sitting
**uncommitted** in the working tree (`counter_field.dart`, `info_note.dart`,
updated `trip_basics_screen.dart`/`new_trip_provider.dart`/`app_constants.dart`)
from a separate concurrent Claude Code session running against this same repo
— not built in this session, but independently verified in this one.
`flutter analyze` was clean; visually confirmed all 4 trip-type variants
render correctly (Individual: companion toggle; Group: Group Name + Members
+ Companions counters + pricing note; College/School: Institution Name +
Students + Staff counters + pricing note, hint text differs college vs.
school). No rendering errors in a clean run.

### Environment gotchas worth remembering

- **Never run two `flutter run` dev servers against the same repo
  simultaneously.** Both watch the same source tree; one session's file
  saves trigger hot-reload/restart in *both* processes, silently resetting
  the other's in-memory provider state mid-interaction (saw `NewTripProvider`
  snap back to defaults, and saw counter values from the other session's
  clicks bleed into this session's screenshots). If another session's
  `flutter run` is already up for this repo, ask the user to pause it before
  trusting any UI verification.
- **Browser-pane click/tap automation did not reliably reach this app's
  Flutter CanvasKit `<canvas>`** — `left_click`/`double_click`/keyboard
  `type` produced zero effect (not even Flutter's own `Switch` widget would
  toggle), and `document.visibilityState` reported `"hidden"` even on the
  frontmost tab. Root cause unconfirmed. **Workaround used**: temporarily
  hardcode the value under test (e.g. `NewTripProvider.tripType`'s default),
  restart `flutter run`, screenshot, then revert — reliable when click
  automation isn't. `read_page` also returns almost nothing for this app
  (Flutter web semantics aren't enabled), so don't rely on `find`/refs either.
- Figma MCP was still rate-limited at the start of this session (same
  Starter-plan ~1-call limit) — didn't retry it; relied on PROGRESS.md's
  existing field-spec notes instead of a fresh screenshot for the Trip Basics
  fix, since the shape was already documented from Session 1.
- `.claude/launch.json` added (`tripconsole-web`, `flutter run -d web-server`)
  for future preview-pane use, though it went unused this session due to the
  port conflict above.
