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

---

## 2026-07-21 — Session 3: My Trips, Profile, Templates, and Destinations gap-fill

User supplied 4 more screenshots covering screens not yet scoped. Built all
13: My Trips (list + empty state), Profile, Choose Starting Location, Add
Destination Modal, Setting Up Your Trip loader, Add New Listing chooser,
Templates browse + Filter modal + shared Package/Template Detail screen, and
a Recent Activity feed added to Home Dashboard. `flutter analyze` clean
(info-level lints only) after every batch; each screen visually verified via
the preview pane.

### New screens/widgets

| Screen | File |
|---|---|
| My Trips (list + empty state, one screen) | `lib/screens/my_trips/my_trips_screen.dart` |
| Profile | `lib/screens/profile/profile_screen.dart` |
| Choose Starting Location | `lib/screens/trip_builder/choose_starting_location_screen.dart` |
| Add Destination (bottom sheet) | `lib/widgets/add_destination_sheet.dart` |
| Setting Up Your Trip (loader) | `lib/screens/trip_builder/trip_setup_loading_screen.dart` |
| Add New Listing (entry chooser) | `lib/screens/home/add_new_listing_screen.dart` |
| Templates (browse grid) | `lib/screens/templates/templates_screen.dart` |
| Filter Templates (bottom sheet) | `lib/widgets/filter_templates_sheet.dart` |
| Package/Template Detail (shared, `isTemplate` flag swaps CTA) | `lib/screens/templates/package_detail_screen.dart` |

New models: `trip_status.dart`, `trip_summary.dart`, `trip_package.dart`,
`itinerary_day.dart`, `pricing_line.dart`, `activity_item.dart`. New reusable
widgets: `trip_status_badge.dart`, `trip_summary_card.dart`,
`template_card.dart`, `activity_item_tile.dart`.

### Decisions made without asking (flag if wrong)

- **My Trips is one screen, not two** — Figma showed separate "List" and
  "Empty State" frames, but they're really the same screen branching on
  `trips.isEmpty`. Built that way so the empty state isn't a dead code path.
- **Package Detail and Template Detail are one screen** — same layout
  (photo, route, itinerary, pricing), only the bottom CTA differs ("Add to
  Trip" vs. "Use This Template"). Passed via `state.extra` as a Dart record
  `({TripPackage package, bool isTemplate})`. Both routes lead to the same
  Setting-Up-Your-Trip loader, which always lands on Trip Basics.
- **My Trips' FAB and "Create Your First Trip" now open Add New Listing**
  (the chooser) instead of jumping straight to Trip Basics, since Add New
  Listing didn't exist yet in Session 2. Home's own "Plan a Full Trip" card
  still goes straight to Trip Basics — left as-is since that's a distinct,
  already-verified entry point.
- **Templates catalog is a hardcoded mock list of 6** (`TemplatesScreen.mockTemplates`)
  reused by Home's "Recommended for You" cards (via a new `templateId` field
  on `TripRecommendation`) and the Templates grid, so the two don't drift.
  The "24 templates found" text from Figma was not treated as a real count —
  used the actual mock list length instead.
- **Choose Starting Location** writes into a new `NewTripProvider.startingLocationName`
  (default `'Kochi'`), and the Destinations screen's map card is now tappable
  to open it — previously hardcoded to the literal string `'KOCHI'`.
- **"Add Another Destination"** now opens `AddDestinationSheet`, which calls
  a new `NewTripProvider.addStop()` — previously a dead `onTap: () {}`.
- Only 2 image assets exist (`onboarding_mountain.png`, `onboarding_adventure.png`)
  so all 6 mock templates cycle between them — expect visual repetition in
  the Templates grid until real package photography is supplied.

### Environment notes (reconfirmed from Session 2)

- **First tab opened by `preview_start` reliably renders solid black** even
  after the JS bundle finishes loading (`document.body.innerHTML` stays on
  the bootstrap-comment stub indefinitely). Workaround: open a **second**
  browser tab (`tabs_create` + `navigate`) — that one renders correctly every
  time. Always do this before concluding a screen is broken.
- **Dev server does not recompile on file save** — `flutter run -d web-server`
  needs a `preview_stop` + `preview_start` cycle (full process restart) to
  pick up source edits; hot reload was not observed to trigger automatically
  in this harness. Budget ~20-30s after restart for the DDC bundle to
  rebuild and serve.
- **Canvas click automation is inconsistent, not uniformly broken** —
  contrary to Session 2's note that it "did not reliably reach" the canvas:
  this session, most clicks on a freshly-loaded second tab landed correctly
  (opened Package Detail, tapped "Use This Template", opened the Filter
  sheet). Clicks on a tab that had already been navigated via URL a few
  times became unreliable. When a click doesn't visibly register, prefer
  navigating directly to the target route/URL over retrying the click.

---

## 2026-07-21 — Session 4: Wizard completion (Participants, Services, full vendor flows)

User supplied 9 more Figma screenshots revealing the trip-creation wizard's
real depth: a **Participants** step that didn't exist in the code at all,
a fully-realized **Services** step (the screen explicitly flagged blocked
since Session 1), and rich vendor sub-flows for Vehicle/Hotel/Restaurant
that go far beyond a single listing screen. Built all of it. `flutter
analyze` clean (info-level lints only) throughout; every major flow
click-tested live in the browser, including full round-trips back into
`NewTripProvider`.

### Critical fix: wizard step order was wrong

`WizardStrings.stepLabels` was `['Basics', 'Destinations', 'Services',
'Itinerary', 'Review']` — a Session 1 guess. The screenshots show the real
order is **Basics → Destinations → Participants → Services → Review**
("Itinerary" doesn't exist as a separate step). Fixed the label list and
every screen's `stepNumber`/`nextLabel`/route target to match. If a future
screenshot contradicts this again, trust the screenshot over this doc.

### New wizard screens

| Screen | File | Notes |
|---|---|---|
| Participants (step 3) | `trip_participants_screen.dart` | Reuses Basics' existing headcount fields (students/staff, members/companions) rather than re-collecting them — see decision below |
| Services (step 4) | `trip_services_screen.dart` | The screen blocked since Session 1. Toggle cards + live cost breakdown |
| Transport Selection | `transport_selection_screen.dart` | Private Operators vs. KSRTC |
| Select Vehicle Type | `select_vehicle_type_screen.dart` | 5 classes; realistic seat capacities per operator |
| Vendor Listing (generic) | `vendor_listing_screen.dart` | Used for single-select vehicle classes + Activities |
| Multi-Vehicle Listing | `multi_vehicle_listing_screen.dart` | Tempo Traveller / Mini Bus — "+Add" combine-multiple-vehicles mode with running seats-covered counter |
| Vehicle Detail & Confirmation | `vehicle_detail_screen.dart` | Operator info, trip summary, reviews, "View Pricing Details" bottom sheet |
| Vehicle Capacity Mismatch | `vehicle_capacity_mismatch_screen.dart` | 3 resolutions: bigger vehicle / add a second / reduce participants |
| Select Hotel | `select_hotel_screen.dart` | Destination + star-rating filters, insufficient-capacity state |
| Hotel Detail | `hotel_detail_screen.dart` | Amenities, room-type picker (live rooms-needed calc), meal-plan checkboxes |
| Choose a Restaurant | `choose_restaurant_screen.dart` | Veg/Non-Veg/budget filter chips |
| Restaurant Menu (day-by-day) | `restaurant_menu_screen.dart` | Day tabs, Veg/Non-Veg toggle, Breakfast/Lunch/Dinner/Packed sections, "ADDED TO DAY N" cross-day flag |
| Restaurant Review & Confirm | `restaurant_review_screen.dart` | Aggregates every day's picks into one total |
| Route Preview | `route_preview_screen.dart` | Leg-by-leg breakdown, reached from Destinations' "Map Preview" link |
| Pick on Map | `pick_on_map_screen.dart` | Reached from Add Destination sheet's "Pick on map" link |
| Trip Review (step 5) | `trip_review_screen.dart` | **Honest placeholder** — no Figma source exists yet for this step; built a real summary from live draft data instead of fabricating a design. Swap out once a screenshot arrives |

New models: `vendor_option.dart` (now with `seatCapacity`), `hotel_option.dart`,
`room_type.dart`, `restaurant_option.dart`, `menu_item.dart`. New provider
state on `NewTripProvider`: `vehicleEnabled/vehicle`, `hotelEnabled/hotel`,
`restaurantEnabled/restaurant`, `activitiesEnabled/activities`,
`sourceTemplateName`, plus `totalParticipants`/`costBearingCount` and a full
services cost-breakdown getter chain (`servicesSubtotal` → `managementBuffer`
→ `servicesGrandTotal` → `perParticipantCost`).

### Decisions made without asking (flag if wrong)

- **Participants step reuses Basics' headcount fields** (`studentsCount`/
  `staffCount` for College/School, `membersCount`/`companionsCount` for
  Group) rather than introducing a second, divergent set of counters. The
  screenshot shows editable counters on both screens; treating Participants
  as a *confirmation* of the same shared state (not a duplicate entry point)
  avoids two numbers drifting out of sync. Individual trips get a read-only
  "Just you" / "You + 1 companion" summary since there's nothing to count.
- **Participants' cost preview and vehicle-capacity check are independent
  estimates**, not read from Services (which hasn't happened yet at that
  point in the wizard). Uses a local mock rate (`₹742.75/night/head`) —
  chosen because it reproduces the screenshot's exact numbers (42 students
  × 4 nights → ₹2,971/student → ₹1,24,782 total) when plugged into the
  default draft data. The *real* total is computed later on Services from
  actual vendor prices and can differ.
- **Vehicle/Template/Package Detail screens are shared, single
  implementations** parameterized by data, not one-off screens per vendor —
  `VendorListingScreen` and `VehicleDetailScreen` are reused across AC
  Sleeper Bus / Non-AC Sleeper Bus / Car / KSRTC.
- **Multi-vehicle combination only triggers for Tempo Traveller and Mini
  Bus** — their largest single unit (~17–33 seats) is smaller than a
  typical group. Car stays single-select (small personal-vehicle UX, no
  screenshot ever showed it needing combination logic).
- **Hotel/Restaurant/Activities mock catalogs are original data**, not
  transcribed from the screenshots (small/blurry text in several frames
  made exact names/prices unreadable) — built plausible, internally
  consistent catalogs matching the visible structure instead of guessing at
  illegible numbers.
- **Skipped, not fabricated**: a separate "Plan Quantities" step and
  "Review & Confirm - Final Restaurant..." screen were visible only as
  layer names in the Figma panel, never as rendered frames — no visual
  spec exists to build from. Restaurant's day-builder flow already ends in
  a review/confirm step (`restaurant_review_screen.dart`) that covers the
  same functional need. Also skipped: KSRTC-specific "Interstate"/"District"
  bus listings (layer names only, not rendered) — KSRTC currently resolves
  directly to one representative bus via `TransportSelectionScreen`.

### Environment notes (new this session)

- **Multiple concurrent `flutter run` / `flutter analyze` processes were
  found running against this repo** (4 different `flutter run -d
  web-server` instances on different ports, 2 stuck `analyze` invocations
  eating 100%+ CPU each) — almost certainly leftover from other Claude Code
  sessions or previous runs in this same environment. This caused `flutter
  analyze` to hang for 2+ minutes instead of its normal ~1.5s. Killed the
  stuck `analyze` processes (safe — they're one-shot, not long-running
  servers) but left the other sessions' `flutter run` processes alone per
  the standing rule against touching other sessions' dev servers. If
  `analyze` or the preview inexplicably hangs/times out, check `ps aux |
  grep dart` before assuming a code problem.
- **`Bash` tool's working directory can silently reset** — a `flutter
  analyze` run without an explicit `cd` printed "Analyzing muhammedhafis..."
  (the home dir) instead of "Analyzing Tripconsole...", meaning it silently
  analyzed the wrong (empty) directory and reported false-positive
  cleanliness. Always confirm the "Analyzing X..." header names the actual
  project, or prefix commands with `cd /Users/muhammedhafis/Tripconsole &&`.
- **Navigating to a new `#/hash` route in the *same* browser tab does not
  reset app/provider state** — go_router's hash routing is client-side SPA
  navigation, so `NewTripProvider` (and any other in-memory state) persists
  across `navigate` calls to the same origin. Only a **new tab** (or a hard
  reload) gives a truly fresh app instance. Don't mistake carried-over state
  from earlier manual testing for stale served code — check whether the
  values match what you set yourself earlier in the session before
  concluding the build didn't pick up a change.

---

## 2026-07-21 — Session 5: Completing the wizard's actual Step 5 + Itinerary system

User supplied 5 more screenshots revealing that Step 5 ("Review") is not
one screen but a whole sub-flow, and that "Generate Itinerary" (a button
already sitting on Services) had nowhere real to go. Built both, plus the
Plan Quantities step for Restaurant that Session 4 explicitly flagged as
skipped (no screenshot existed then; one does now). `flutter analyze`
clean throughout; the entire chain — Services → Generate Itinerary →
day-by-day itinerary → Review Trip → Declarations → Submit confirmation →
My Trips — was click-tested live in the browser end to end, including the
block editor and the Plan Quantities math.

### What replaced the Step 5 placeholder

`trip_review_screen.dart` was a Session 4 placeholder (explicitly labeled
"no Figma source yet"). It's now the real **Review Trip — Master Overview**:
Route Details, Participants, Services & Logistics, Cost Snapshot, and an
Itinerary Preview built from whatever `NewTripProvider.dailyItinerary`
contains (auto-generating it via a post-frame callback if the organizer
skipped straight here without visiting the itinerary screens). "Continue to
Declarations" leads to a new **Declarations** screen (3 checkboxes gating
Submit) → a **Submit confirmation** dialog (`showDialog`, not a route) →
`My Trips` on confirm.

### New itinerary system

`Generate Itinerary` (and Services' "Next: Review" in the `WizardBottomBar`,
now consistent) both route through:

| Screen | File |
|---|---|
| Itinerary Generating (loading) | `itinerary_generating_screen.dart` |
| Itinerary Day (timeline, day tabs) | `itinerary_day_screen.dart` |
| Edit Itinerary Block (sheet) | `edit_itinerary_block_sheet.dart` |

`NewTripProvider.generateItinerary()` synthesizes `dailyItinerary` (one
`List<ItineraryBlock>` per day) from whatever's already chosen on
Destinations/Services — a travel leg every day, one activity per day
(round-robin through `activities` if any are selected), a meal block
(hotel/restaurant costs split evenly across days as an *illustrative* daily
figure — the authoritative total is still `servicesGrandTotal`, this is
just a breakdown view). Idempotent, so re-entering the screen after manual
edits doesn't wipe them. New model: `itinerary_block.dart` (`BlockType`
enum: travel/activity/meal/rest).

### Plan Quantities (closes a Session-4-flagged gap)

`restaurant_menu_screen.dart`'s final-day button now routes to
`plan_quantities_screen.dart` instead of straight to Review. It splits
`totalParticipants` into veg/non-veg headcounts (defaulted 76/24, editable,
with an "N portions unassigned" warning if they don't sum correctly),
distributes portions evenly across that day's selected dishes per
veg/non-veg group, and computes subtotal + 5% service tax per day. The
final day pushes an extended `RestaurantReviewArgs` (now carrying
`quantitiesByDay`) to `restaurant_review_screen.dart`, whose totals were
reworked to multiply `quantity × price` per dish instead of the old
`(sum of dish prices) × totalParticipants` — quantities now directly *are*
the portion allocation, not a flat per-head multiplier.

### Decisions made without asking (flag if wrong)

- **Submit confirmation is a dialog (`showDialog`), not a route.** The
  screenshot shows it as a centered modal card over a dimmed background,
  which is dialog semantics, not a full-screen push — kept it that way
  rather than forcing it into the route-per-screen pattern used everywhere
  else in the wizard.
- **The "Budget Authenticated / Timeline Confirmed / Permits & Risks
  Verified" checklist in the submit dialog uses amber info icons, not green
  checkmarks** — read the screenshot as a final-review checklist to glance
  over, not items already programmatically verified (nothing in this app
  actually checks budget/permits), so styling them as passed checks would
  overclaim.
- **Itinerary block costs are illustrative, not authoritative** — hotel and
  restaurant totals are already locked in on Services
  (`NewTripProvider.servicesGrandTotal`); the day-by-day view just splits
  those same totals evenly across days for a readable breakdown. Don't
  sum itinerary block costs expecting them to reconcile to a different,
  more-precise number — they're deliberately a rough per-day slice of the
  same total.
- **No real dates anywhere in the itinerary** — Basics never collects a
  trip start date, so Day screens say "Day 1 of 3" rather than fabricating
  calendar dates like the screenshots show ("March 15, Saturday"). Inventing
  a plausible-looking date felt worse than omitting it.

### Explicitly deferred (not built, not silently skipped)

Two features were visible across the screenshots but not built this
session — flagging rather than fabricating or quietly dropping them:

- **Cost Console** — a whole separate post-submission dashboard (buffer
  explainer popover, version history panel, locked cost snapshot with a
  payment plan, PDF export/"Request Change"). This reads as a distinct
  nav-level feature for managing an *already-submitted* trip, not part of
  the linear creation wizard. Out of scope for "finish the wizard."
- **Rich Select Activities flow** — destination/category-filtered activity
  browsing, a detailed Activity Detail screen (reviews, cost breakdown,
  inclusions checklist), and a "Selected Activities" review step. Currently
  Activities still uses the generic `VendorListingScreen` shared with
  single-select vehicles. Functional, just not as deep as the screenshots
  show.
- Also not built (layer-names-only in the Figma panel, never seen as a
  rendered frame, same standard as Session 4's deferrals): KSRTC
  Interstate/District-specific bus listings, and any distinct "Review &
  Submit — Confirmation Sheet" beyond the dialog already built.

### Environment note (reconfirmed)

Hit the same-tab SPA state-carryover issue again mid-session (clicked
"Generate Itinerary" and landed on the *old* placeholder Review screen
despite a `preview_stop`/`preview_start` cycle) — turned out the existing
tab was still running the previously-loaded JS bundle. A **brand new tab**
(`tabs_create` + `navigate`) resolved it immediately. When a restart
doesn't seem to have taken effect, open a fresh tab before concluding
there's a build problem.
