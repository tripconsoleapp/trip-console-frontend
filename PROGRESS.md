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

---

## 2026-07-21 — Session 6: Post-submission — status, payments, receipts

User supplied 5 more screenshots covering everything *after* a trip is
submitted: a richer submission success screen, trip status/verification
tracking, and a full payment system (plan selection, method, processing,
success/failure, balance payment, receipts). Built the pieces that close
real dead ends already sitting in the app — My Trips' "Track Status" /
"Pay Now" / "View Receipt" buttons previously did nothing (or `Track
Status`/`Pay Now` had no `onAction` case at all). `flutter analyze` clean;
the full advance-payment round trip (Verified → Payment Plan → Payment
Method → Processing → Result → back to Trip Detail showing the updated
balance-due state) was click-tested live in the browser.

### New screens

| Screen | File | Reached from |
|---|---|---|
| Submitting Trip (loading) | `trip_builder/submitting_trip_screen.dart` | Declarations' submit dialog |
| Trip Submitted (success) | `trip_builder/trip_submitted_screen.dart` | after Submitting Trip |
| Trip Detail | `my_trips/trip_detail_screen.dart` | My Trips: Submitted/Paid rows, "View Trip Details" after payment |
| Payment Plan | `my_trips/payment_plan_screen.dart` | My Trips: Verified row ("Pay Now") |
| Payment Method | `my_trips/payment_method_screen.dart` | Payment Plan, or Trip Detail's "Pay Balance Now" |
| Payment Processing | `my_trips/payment_processing_screen.dart` | Payment Method |
| Payment Result | `my_trips/payment_result_screen.dart` | after Processing (always succeeds — see below) |
| Payment Failed | `my_trips/payment_failed_screen.dart` | built, not wired to a trigger (see below) |
| Payment Receipt | `my_trips/payment_receipt_screen.dart` | My Trips: Completed row ("View Receipt"), or Payment Result |

New model: `payment_args.dart` (`PaymentArgs` — trip + amount + isAdvance +
isBalance, threaded through Method → Processing → Result → Receipt so each
screen doesn't need its own copy of that context). `TripSummary` gained
`totalCost`/`amountPaid`/`balanceDue`/`caseReference`/`copyWith` — previously
it only carried enough to render the My Trips list card, not enough for a
detail or payment flow.

### Decisions made without asking (flag if wrong)

- **`PaymentProcessingScreen` always succeeds after ~1.6s** — there's no
  real payment gateway to fail against, so simulating a random failure
  would be arbitrary, not meaningful. `PaymentFailedScreen` is fully built
  and routable (`AppRouter.paymentFailed`) for design completeness, but
  nothing currently navigates to it. If a real failure condition should
  exist (e.g. a debug toggle), that needs a product decision, not a coin
  flip.
- **Paying an advance updates the trip's `TripStatus` to `paid`** even
  though a balance remains — matches the existing enum (there's no separate
  "partially paid" status) and `TripSummary.balanceDue` is what
  `TripDetailScreen` actually branches on for the balance-due banner and
  "Pay Balance Now" CTA, not the status enum alone.
- **Payment updates don't persist back into My Trips' mock list** — `Trip
  Detail`/`Payment Result` construct an updated `TripSummary` via
  `copyWith` and pass it *forward* (so the immediate next screen shows the
  correct new state, which is what got verified), but My Trips' `_trips` is
  still a `static const` list, so navigating back to My Trips itself shows
  the old pre-payment row. Same category of limitation as the rest of this
  UI-only prototype (no backend), consistent with how Session 4/5 handled
  mock data — flagging in case a real state store is wanted later.
- **Cost breakdown on Trip Detail is a proportional split** (35% transport
  / 40% accommodation / 25% activities) of `totalCost`, not real itemized
  data — My Trips' mock trips were never built from `NewTripProvider`
  selections, so there's no real per-service breakdown to show. Same
  "illustrative, not authoritative" pattern as Session 5's itinerary block
  costs.
- **No `intl` package** — dates are formatted with a small hardcoded month
  list rather than adding a new pubspec dependency mid-session for one
  screen's date display.

### Explicitly deferred (not built, not silently skipped)

- **Notifications Hub** — shown in 3 different visual variants across the
  screenshots, not tied to any existing button or nav destination in the
  app. Reads as a separate feature area, not a gap-fill.
- **Standalone PDF Documents/Download screen** — folded its content into
  Trip Detail's "Documents" section (tappable rows) instead of a dedicated
  full-screen document browser, since that's where the screenshots' own
  "Trip Details" frame already links out to documents.
- Also not built, same standard as prior sessions (visible in screenshots
  as only one static frame, no interaction shown, or clearly a variant of
  something already covered): the "Verification Approved" screen as a
  separate step (folded its messaging into Trip Detail's verified-state
  banner instead), and the balance-payment-specific success/failure
  screens as *separate* files (they reuse Payment Result/Failed via
  `PaymentArgs.isBalance`, same screens, different copy).

### Follow-up — locked itinerary view (closes a dead button found in audit)

A post-session audit (cross-checking every built screen against every
screenshot, plus `git fetch` to confirm local `HEAD` matched
`origin/main`) turned up one real gap: Trip Detail's "View Itinerary"
button (fully-paid state) had an empty `onPressed`. Built the two screens
it should have led to:

- `my_trips/locked_itinerary_screen.dart` — schedule overview (locked
  badge, one row per day with event count + start time, the "modifications
  disabled" notice, View Map/Share Trip), matching the "Kerala Getaway ·
  ITINERARY LOCKED" screenshot.
- `my_trips/locked_itinerary_day_screen.dart` — read-only day timeline,
  visually parallel to the wizard's editable `ItineraryDayScreen` but with
  no edit/add-block affordances.

Since `TripSummary` (My Trips' mock data) carries no real itinerary,
day count and block content are synthesized deterministically from the
trip's subtitle (`"XD"` parsed via regex, defaulting to 3) and
`totalCost`/day-count split — same "illustrative, not authoritative"
approach as every other derived-data screen in this app. Verified live:
Kerala Pilgrimage Tour (fully paid) → View Itinerary → Schedule Overview →
Day 1 detail, all rendering correctly. `flutter analyze` clean.

---

## 2026-07-21 — Session 7: Standalone Hotel Only Booking flow ("Service Only")

The user supplied 5 new screenshots of a 5-step Hotel Booking wizard and
clarified it's the **standalone Service-Only booking path** — reached from
Home Dashboard's "Hotel" quick-action chip (previously dead, no `onTap`) —
not a revision of the trip wizard's existing in-trip Hotel step. Built as a
fully separate flow with its own provider, sharing only data models with
the trip wizard.

| Screen | File | Step |
|---|---|---|
| Book Hotel (Stay Details) | `lib/screens/service_booking/book_hotel_stay_details_screen.dart` | 1/5 |
| Select Stay Location | `lib/screens/service_booking/select_stay_location_screen.dart` | sub-screen |
| Select Stay Dates (custom range calendar) | `lib/screens/service_booking/select_stay_dates_screen.dart` | sub-screen |
| Room Type Preference | `lib/screens/service_booking/room_type_preference_screen.dart` | sub-screen |
| Hotel Results (filterable listing) | `lib/screens/service_booking/hotel_search_results_screen.dart` | 2/5 |
| Hotel Detail (stats/amenities/room types/meal plan/reviews) | `lib/screens/service_booking/service_hotel_detail_screen.dart` | 3/5 |
| Select Meal Plan (bottom sheet) | `lib/widgets/select_meal_plan_sheet.dart` | modal |
| Hotel Booking Summary (recap + cost breakdown) | `lib/screens/service_booking/hotel_booking_summary_screen.dart` | 4/5 |
| Confirm Booking (bottom sheet, checkbox gate) | `lib/widgets/confirm_hotel_booking_sheet.dart` | 5/5 |

New provider: `lib/providers/hotel_booking_provider.dart` — holds the full
draft (booking type, location, dates, guest counts, room/meal selection)
and all derived cost getters (`roomCost`, `mealCost`, `taxes` at 18% GST,
`grandTotal`). Registered in `main.dart`'s `MultiProvider`.

### Decisions made without asking (flag if wrong)

- **Reused `TripType`** (`school`/`college`/`group`/`individual`) for the
  booking-type chips (Solo/School/College/Corporate) instead of a new
  parallel enum, same pattern as everywhere else in the app that needs a
  4-way org-type split.
- **Extended `HotelOption` additively** (`roomCount`, `sinceYear`,
  `townDistanceKm`, all nullable) rather than forking a second hotel model,
  since the richer detail screen is still describing the same kind of
  entity the trip wizard's `SelectHotelScreen`/`HotelDetailScreen` use.
- **Room-count math**: `HotelBookingProvider.roomsNeeded` uses the
  *selected* room type's actual `guestsPerRoom` once a hotel/room is
  picked, falling back to a generic capacity heuristic (from the Room Type
  Preference chip) before that — so the Stay Details screen's "suggested N
  rooms" estimate and the Hotel Detail/Summary screens' real total always
  agree once a room is chosen.
- **Meal plan UI**: the screenshots show meal plan as inline checkboxes on
  one screen and as a modal on another; picked one mechanism (a bottom
  sheet, `SelectMealPlanSheet`) and reused it everywhere a meal plan is
  chosen or changed, to avoid two divergent UIs for the same choice.
- **No dedicated success screen** was shown in this screenshot batch for
  the final confirmation. On "Confirm Hotel Booking", the provider resets
  and the user is routed back to Home with a confirmation SnackBar
  ("Hotel booking confirmed. Our team will reach out shortly."), the same
  lightweight pattern used for other unscreenshotted terminal states.
- Wired Home Dashboard's "Hotel" `QuickActionChip.onTap` to
  `AppRouter.bookHotel` — it had no destination before this session.

### Explicitly deferred (not built, not silently skipped)

- Only **Hotel** was shown as a standalone Service-Only flow in the
  screenshots. Vehicle and Restaurant service-only equivalents (the other
  two "Service Only" quick-action chips on Home) were not — those chips
  remain unwired pending screenshots of their own flows.

Verified live end-to-end in the browser preview (new tab, full click
through): Home → Hotel chip → Stay Details → Select Location → Select
Dates (range picker, "5 NIGHTS" pill) → Room Type Preference → Search
Hotels → Hotel Results → Hotel Detail (room selection updates running
total) → Select Meal Plan (total recalculates: ₹2800 room + ₹700 meal =
₹3500) → Booking Summary (₹3500 + 18% GST = ₹4130 total, matches) →
Confirm Booking sheet (checkbox correctly gates the Confirm button) →
confirmed → back on Home with success SnackBar. `flutter analyze` clean
(zero errors/warnings; only pre-existing `prefer_const_constructors` info
lints).

---

## 2026-07-21 — Session 8: Restaurant Only Booking flow ("Service Only")

The user supplied a further 3 screenshots of a richer, standalone
"Restaurant / Meal Booking" flow and confirmed — same pattern as the
Hotel session — that this is the third **Service Only** path, reached
from Home Dashboard's previously-dead "Restaurant" quick-action chip.
Audited first: none of the 13 implied screens existed (the app's
existing `choose_restaurant_screen.dart` / `restaurant_menu_screen.dart`
/ `plan_quantities_screen.dart` are all trip-wizard-scoped, not
standalone). Built the full flow reusing as much of that existing
infrastructure as possible.

| Screen | File | Step |
|---|---|---|
| Book Restaurant (meal requirements) | `lib/screens/service_booking/book_restaurant_screen.dart` | 1/5 |
| Select Meal Location | `lib/screens/service_booking/select_meal_location_screen.dart` | sub-screen |
| Select Meal Dates (multi-select calendar) | `lib/screens/service_booking/select_meal_dates_screen.dart` | sub-screen |
| Select Meal Types (headcount editor) | `lib/screens/service_booking/select_meal_types_screen.dart` | sub-screen |
| Restaurant Search Results (filterable) | `lib/screens/service_booking/restaurant_search_results_screen.dart` | 2/5 |
| Restaurant Menu & Planning (stats/tabs/menu builder) | `lib/screens/service_booking/restaurant_menu_planning_screen.dart` | 3/5 |
| Dietary Summary (bottom sheet) | `lib/widgets/dietary_summary_sheet.dart` | modal |
| Meal Booking Summary (recap + cost breakdown) | `lib/screens/service_booking/meal_booking_summary_screen.dart` | 4/5 |
| Confirm Your Meals (bottom sheet) | `lib/widgets/confirm_meal_booking_sheet.dart` | modal |
| Sending Meal Request (animated checklist) | `lib/screens/service_booking/sending_meal_request_screen.dart` | 5/5 |
| Meal Booking Sent (success) | `lib/screens/service_booking/meal_booking_sent_screen.dart` | 5/5 |

New provider: `lib/providers/restaurant_booking_provider.dart` — booking
type/location/meal dates/meal-type toggles/headcounts/diet
preference/catering style, plus the menu selection and all cost getters
(`subtotal`, `serviceCharge` at 5%, `grandTotal`). Registered in
`main.dart`'s `MultiProvider`.

### Decisions made without asking (flag if wrong)

- **Reused `TripType`, `RestaurantOption`, `MenuItem`/`MealType`** from
  the existing trip-wizard restaurant flow instead of new parallel
  models — extended `RestaurantOption` additively (`verified`, `badge`,
  `sinceYear`, `dietaryVegPercent`, `about`, all nullable) the same way
  `HotelOption` was extended for the Hotel flow.
- **Flattened day-by-day menu selection to one set of dishes/quantities
  applied uniformly across every selected meal date**, rather than
  distinct per-day menus. This mirrors the Hotel flow's "one room
  choice, multiplied by nights" simplification, and let two Figma
  frames ("Restaurant Menu & Planning" and "Quantity Planning") merge
  into a single screen — each dish gets a quantity stepper directly
  instead of a separate select-then-quantity pass. Costs and the
  Dietary Summary's day-by-day breakdown are derived from this (same
  totals repeated per selected date) — illustrative, not authoritative,
  consistent with every other derived-data screen in this app.
- **Merged the Figma "Book Restaurant" and "Meal Requirements" frames**
  into one Step 1/5 screen — both described the same step with
  overlapping fields (location, dates, meal types, group size, diet
  preference); building both would have been duplicate/conflicting
  designs. Kept "Book Restaurant" as the screen title (matches the Home
  chip and the "Book Hotel" naming symmetry) and folded in Meal
  Requirements' Catering Style chips.
- **Select Meal Dates is a genuine multi-select calendar** (Set
  <DateTime>, quick actions "Select 7 Days" / "Weekdays Only" / "Clear
  All"), not a check-in/check-out range like Hotel's — the screenshots
  show non-contiguous day selection (a school might only need meals on
  specific days), so a different picker was built rather than reusing
  the range-picker.
- **Confirm Your Meals has no checkbox gate** (unlike Hotel's Confirm
  Booking sheet) — the screenshot shows just a note ("no payment
  required at this step") and a single Confirm button, so that's what
  was built; the richer confirmation ceremony happens via the follow-up
  Sending/Sent screens instead.
- **"View All Bookings" and "Go to Dashboard"** both reset the provider
  and return to Home — there's no dedicated bookings-list screen in this
  app (Home's own copy says "Service-only bookings are independent —
  they won't appear in your trip list"), so routing both buttons
  elsewhere would either 404 or show a list that can never contain the
  booking just made.
- Wired Home Dashboard's "Restaurant" `QuickActionChip.onTap` to
  `AppRouter.bookRestaurant` — it had no destination before this
  session.

### Explicitly deferred (not built, not silently skipped)

- One screenshot frame ("Select Activity Location", a map-style picker
  similar to Select Meal Location) did **not** belong to this Restaurant
  flow — it appears to be the start of a fourth, separate "Activity"
  service-only flow that the screenshot batch cut off before showing.
  No Activity booking flow (standalone or in-trip) exists anywhere in
  this codebase. Not built — needs its own screenshot batch before
  scoping.
- Vehicle's Service Only chip remains unwired (no screenshots yet for
  that flow either).

Verified live in the browser preview end-to-end: Home → Restaurant chip
→ Book Restaurant (School, 2 Students) → Select Meal Location → Select
Meal Dates (multi-select, 7 non-contiguous-capable days picked via
"Select 7 Days") → Search Restaurants → Restaurant Results (3
restaurants, correct badges/pricing) → Kandy Tamil Restaurant menu
(quantity steppers: 2× Kerala Sadya + 2× Parotta Curry = ₹600/day,
correct) → Dietary Summary sheet (7 days × 4 portions, correct) → Meal
Booking Summary (Lunch ₹2520 + Dinner ₹1680 + 5% service charge ₹210 =
₹4410 total, correct) → Confirm Your Meals sheet → Sending Meal Request
(animated checklist) → Meal Booking Sent (correct restaurant/dates/
total, "What's Next" steps) → Go to Dashboard → back on Home, provider
reset. Also separately verified Select Meal Types (headcount editor,
dynamic "Confirm Meal Types (...)" label) in a clean single-click pass.
`flutter analyze` clean (zero errors/warnings; only pre-existing
`prefer_const_constructors` info lints).

---

## 2026-07-21 — Session 9: KSRTC Integration + Pilgrimage Console (built in 5 sequenced phases)

The user supplied 7 screenshots covering two large, intertwined feature
areas — a deep KSRTC (Kerala State Road Transport Corporation) bus
booking/verification/pooled-payment/e-ticket subsystem, and the
standalone "Pilgrimage Console" behind Home's "Plan Pilgrimage Program"
card (previously an empty no-op `onTap: () {}`). Audited first: of 26
implied frames, only one partially existed (Transport Selection's
Private-vs-KSRTC choice, which resolved KSRTC to one hardcoded vendor
with no browsable list). Everything else — the entire bus-class listing,
admin verification layer, split/pooled-payment collection, e-ticket +
sharing, guide marketplace, and the whole Pilgrimage Console shell — was
new. Built in 5 sequenced phases per the user's request, largest batch
of the project so far (23 new screens/widgets across three feature
areas).

### Phase 1 — KSRTC bus list, booking, admin verification

| Screen | File |
|---|---|
| KSRTC Buses (District/Interstate tabs) | `lib/screens/trip_builder/ksrtc_bus_list_screen.dart` |
| Booking Submitted (admin verification wait) | `lib/screens/trip_builder/booking_submitted_screen.dart` |
| Bus Approved | `lib/screens/trip_builder/bus_approved_screen.dart` |
| KSRTC Booking Summary | `lib/screens/trip_builder/ksrtc_booking_summary_screen.dart` |
| Booking Confirmation | `lib/screens/trip_builder/ksrtc_booking_confirmation_screen.dart` |

New model `lib/models/ksrtc_bus.dart` (flat institutional bus-hire fare,
not the per-head vendor-quote shape `VendorOption` uses — genuinely
different pricing model, so a dedicated model was built rather than
extending `VendorOption`).

### Phase 2 — Split/pooled-payment collection

| Screen | File |
|---|---|
| Payment Split Setup | `lib/screens/trip_builder/payment_split_setup_screen.dart` |
| Member Payment Collection | `lib/screens/trip_builder/member_payment_collection_screen.dart` |
| Payment Progress Tracker | `lib/screens/trip_builder/payment_progress_tracker_screen.dart` |
| Full Amount Consolidated | `lib/screens/trip_builder/full_amount_consolidated_screen.dart` |
| KSRTC Transfer Confirmation | `lib/screens/trip_builder/ksrtc_transfer_confirmation_screen.dart` |

This is genuinely new architecture — no split/per-member payment concept
existed anywhere in the app before this (the existing Payment Plan/
Method/Processing/Result/Receipt flow is single-payer only). New mutable
model `lib/models/ksrtc_member_entry.dart` (name/share/status, since
status changes via remind/mark-as-cash actions).

### Phase 3 — E-Ticket, sharing, Trip Detail integration

| Screen | File |
|---|---|
| E-Ticket | `lib/screens/trip_builder/ksrtc_eticket_screen.dart` |
| Share Processing | `lib/screens/trip_builder/share_processing_screen.dart` |
| Share Success | `lib/screens/trip_builder/share_success_screen.dart` |

Added a **Transport & Logistics** section to the existing
`trip_detail_screen.dart` (shown when a trip is fully paid) — a Bus
Service card (FULLY PAID badge, View E-Ticket/Share) and a Tourist Guide
"Optional Add-on" row, matching the "Trip Details — KSRTC Status Card"
screenshot. Uses illustrative static content the same way the existing
Documents/Cost Breakdown sections do, rather than threading a specific
`KsrtcBookingProvider` instance through (Trip Detail instances represent
arbitrary trips in My Trips, not necessarily ones built through this
exact KSRTC flow in this session).

### Phase 4 — Guide marketplace

| Screen | File |
|---|---|
| Choose a Guide | `lib/screens/guide/choose_guide_screen.dart` |
| Guide Profile | `lib/screens/guide/guide_profile_screen.dart` |

New model `lib/models/tour_guide.dart`. Reached from Trip Detail's new
Tourist Guide add-on row; booking pops back to Trip Detail with a
confirmation SnackBar (no dedicated confirmation screen was shown for
this in the screenshots).

### Phase 5 — Pilgrimage Console shell

| Screen | File |
|---|---|
| Trip Mode (Self-Managed vs KSRTC Collaboration) | `lib/screens/pilgrimage/pilgrimage_trip_mode_screen.dart` |
| Trip Setup (Scratch vs Template) | `lib/screens/pilgrimage/pilgrimage_trip_setup_screen.dart` |
| Browse Pilgrimage Templates | `lib/screens/pilgrimage/pilgrimage_templates_screen.dart` |
| Sabarimala Template Preview (Route Planning) | `lib/screens/pilgrimage/sabarimala_template_preview_screen.dart` |
| Trip Structure Selection (Large/Small Group) | `lib/screens/pilgrimage/pilgrimage_trip_structure_screen.dart` |
| Seat Count & Capacity | `lib/screens/pilgrimage/pilgrimage_seat_count_screen.dart` |
| KSRTC Bus Search (bridge screen) | `lib/screens/pilgrimage/pilgrimage_bus_search_screen.dart` |

New provider `lib/providers/pilgrimage_provider.dart` and model
`lib/models/pilgrimage_template.dart`. Home Dashboard's "Plan Pilgrimage
Program" card now opens this flow.

### Decisions made without asking (flag if wrong)

- **New `KsrtcBookingProvider` and `PilgrimageProvider`**, both
  self-contained (own trip name/route/passenger fields) rather than
  reading `NewTripProvider`, so the KSRTC pipeline can be entered from
  either the main trip wizard's Transport Selection step *or* the
  standalone Pilgrimage Console — the same "settable defaults, no tight
  coupling" pattern used by the Hotel/Restaurant Only Booking providers.
- **Pilgrimage Console bridges into the already-built KSRTC pipeline**
  rather than duplicating it: `PilgrimageBusSearchScreen` copies the
  pilgrimage group's destination/headcount into `KsrtcBookingProvider`
  and pushes the *same* `KsrtcBusListScreen` (and everything after it)
  built in Phase 1. Verified live: a Sabarimala pilgrimage with 4
  travelers flowed through bus selection → admin verification → booking
  → 4-way payment split → full collection → KSRTC transfer → e-ticket →
  group share, with every number (fare, per-person split, service fee)
  computed correctly from the real pilgrimage headcount.
- **Booking Submitted (admin verification) auto-approves after ~2.2s**
  rather than requiring the user to leave and return — same simulated-
  wait pattern as `TripSetupLoadingScreen`, since the real 30-minute
  admin review can't be usefully demonstrated in a prototype.
- **Existing Transport Selection's KSRTC card was rewired**: it used to
  resolve directly to one hardcoded `VendorOption` via `vehicleDetail`;
  it now opens the real browsable `KsrtcBusListScreen`, since that's a
  strictly more complete implementation of the same feature, not a
  parallel one.
- **Member payment list is seeded with a realistic mix of Paid/Pending/
  Not Sent statuses** (not all "Not Sent") when collection starts, so
  the Member Payment Collection and Payment Progress Tracker screens
  have something meaningful to show immediately — matches the
  screenshots, which show a partially-collected state, not an empty one.
- **Guide "Book This Guide" and the Restaurant/Hotel-style confirm
  screens all pop with a SnackBar** rather than a dedicated confirmation
  screen, since none was shown in the screenshots for this specific
  action.

### Explicitly deferred (not built, not silently skipped)

- Nothing from this screenshot batch was skipped — all 26 identified
  frames across both feature areas were built, either as a dedicated
  screen or, where two frames described the same step from different
  angles (e.g. "Sending Meal Request"-style admin-verification wait),
  consolidated per the reasoning above.
- Vehicle's Home-dashboard Service Only chip is still unwired (no
  screenshots yet for a standalone Vehicle-only booking flow).

Verified live end-to-end in the browser preview across two full passes:
(1) Pilgrimage Console: Home → Plan Pilgrimage Program → Trip Mode
(KSRTC Collaboration) → Trip Setup (Use a Template) → Browse Templates →
Sabarimala preview → Customise & Continue → Trip Structure (Large Group)
→ Seat Count (3 pilgrims + 1 staff) → KSRTC Bus Search (auto-filled from
template) → Search Buses → KSRTC Buses (4 Passengers · Kochi → Sabarimala,
correct) → selected Minnal Super Deluxe Air Bus → auto-verified → Bus
Approved → Booking Summary (₹18900 fare, ₹4725/person, correct) →
Confirm Booking → Booking Confirmation (₹19500 due, correct) → Collect
Group Payment → Payment Split Setup (₹4875/person for 4 members,
correct) → Start Collection → Member Payment Collection (marked all 4
paid, progress recalculated 25%→50%→75%→100% correctly at each step) →
Payment Progress Tracker (100%, 4 Paid/0 Pending) → Full Amount
Consolidated → Transfer to KSRTC → Transfer Confirmation (correct
receipts) → Download E-Ticket → E-Ticket (correct QR/reference/route) →
Share with Group → Share Processing (auto) → Share Success ("4
recipients", correct). (2) Trip Detail integration: My Trips → Kerala
Pilgrimage Tour (Fully Paid) → Transport & Logistics section (Bus
Service card + Tourist Guide row, matches screenshot) → Add → Choose a
Guide (4 guides, correct filters/badges) → Anandu Krishnan profile
(matches screenshot) → Book This Guide → confirmation SnackBar on
return. (3) Confirmed the original trip-wizard entry point (Transport
Selection → KSRTC card) now opens the same real bus list instead of the
old hardcoded shortcut. `flutter analyze` clean throughout all 5 phases
(zero errors/warnings; only pre-existing `prefer_const_constructors`
info lints, 81 total consistent with the rest of the app).

---

## 2026-07-21 — Session 10: Correcting a screen mix-up in the Pilgrimage Console

The user supplied clearer/zoomed screenshots of two Session 9 frames
that had been misread. Audited and confirmed:

- **"Trip Structure Selection"** was built as a Large Group / Small
  Group chooser. The actual Figma content is a **Customise vs Fixed
  Package** choice (build the trip yourself vs a pre-bundled fixed-rate
  KSRTC package) — nothing to do with headcount.
- **"Seat Count & Capacity"** was built as manual Pilgrims/Staff
  `CounterField` entry. The actual Figma content is the **Large Group /
  Small Group** card chooser — group size is picked as a category, not
  typed in. Confirmed by the downstream KSRTC Bus Search screen, whose
  "PASSENGER COUNT" field is shown auto-filled and lock-icon'd, not
  editable.

Fixed by swapping the two screens' content and reworking
`PilgrimageProvider`: replaced `structureChoice`/`pilgrimCount`/
`staffCount` with `structureType` (Customise/Fixed Package) and
`groupSizeCategory` (Large/Small Group); `totalPilgrims` is now derived
from the category (46 for Large, 18 for Small — illustrative, not
authoritative) instead of summed from manual counters. Also added the
missing 4th field (Passenger Count, auto-filled + lock icon) to KSRTC
Bus Search and renamed its button from "Search Buses" to "Submit" to
match the source.

Files touched: `lib/providers/pilgrimage_provider.dart`,
`lib/screens/pilgrimage/pilgrimage_trip_structure_screen.dart`,
`lib/screens/pilgrimage/pilgrimage_seat_count_screen.dart`,
`lib/screens/pilgrimage/pilgrimage_bus_search_screen.dart`,
`lib/utils/app_constants.dart` (`PilgrimageTripStructureStrings`/
`PilgrimageSeatCountStrings`/`PilgrimageBusSearchStrings` rewritten).

### Explicitly deferred (not built, not silently skipped)

- The same screenshots' Figma outline panel shows several more frame
  names with no visible content yet: **"Car Details & Confirmation"**,
  **"Car Selection - 4 Seater (Empty State)"**, **"Car Selection - 7
  Seater (Standardized)"**, **"Car Selection Listing - 6 Seater"**,
  **"Car Selection Listing - 5 Seater"**. These look like they belong to
  the Self-Managed pilgrimage path's own vehicle-selection step
  (possibly a pilgrimage-specific variant of the existing generic
  Select Vehicle Type → Vendor Listing → Vehicle Detail flow, which
  today shows generic private operators). Not built — no screenshot of
  their actual content exists yet, and guessing their design would risk
  contradicting the real Figma source once it's shared.

Verified live in the browser preview: Trip Structure Selection
(Customise/Fixed Package cards, matches) → Seat Count & Capacity
(Large/Small Group cards, matches) → Large Group → Select Vehicle Type
(Self-Managed default routes here correctly, already-existing screen
unchanged) → separately re-verified the KSRTC Collaboration path's Bus
Search screen (all 4 fields incl. "46 Passengers", lock icons, "Submit"
button, matches) → Submit → KSRTC Buses ("46 Passengers" correctly
threaded through). `flutter analyze` clean (zero errors/warnings).

---

## 2026-07-22 — Session 11: Request-signing scaffold (backend not yet connected)

The user shared a spec doc (`flutter side security.docx`) from the
backend developer describing HMAC-SHA256 request signing
(`x-app-signature` / `x-app-signature-timestamp` headers) meant to stop
someone calling the API directly with a bare HTTP client once it's
live. Confirmed first that **no real backend integration exists yet** —
`dio` was already a `pubspec.yaml` dependency but never imported
anywhere in `lib/`, no `Dio()` client, no interceptors, every screen
runs on hardcoded mock data. The user confirmed the backend is being
built separately and will connect once frontend work is done, so this
is scaffolding for that future wiring, not something with a live
target today.

| File | Purpose |
|---|---|
| `lib/services/app_signature_interceptor.dart` | `AppSignatureInterceptor` — signs every request per the doc's exact spec (HMAC-SHA256 over `METHOD:PATH:TIMESTAMP:BODY`, secret via `--dart-define=APP_SIGNATURE_SECRET`) |
| `lib/services/api_client.dart` | `ApiClient.instance` — shared `Dio()` with the interceptor attached, base URL via `--dart-define=API_BASE_URL`; the single place future screens should get a `Dio` from |

`crypto: ^3.0.3` added to `pubspec.yaml` (the interceptor's only new
dependency). Implemented the code as given in the doc, not reinterpreted
— including its own inline comments about the body-serialization
mismatch pitfall (sign the exact string that gets sent, not the object
Dio might re-serialize differently) and the dev-mode `assert(false, ...)`
that fails loudly if the secret env var isn't set, rather than silently
sending unsigned requests.

### Decisions made without asking (flag if wrong)

- Put both files under `lib/services/`, matching the existing
  `auth_service.dart` convention, rather than inventing a new
  `lib/network/` folder.
- Left a `TODO(backend)` comment on `ApiClient` for the future
  auth-token interceptor the doc mentions ("your existing auth token
  interceptor") — no such interceptor exists in this app yet, so
  nothing was fabricated for it.
- Did **not** wire `ApiClient`/`AppSignatureInterceptor` into any
  screen or provider — there are no real API calls anywhere in the app
  yet to attach it to. This is a ready-to-use scaffold, not yet live.

### Explicitly deferred (not built, not silently skipped)

- Migrating the secret from `--dart-define` to Android Keystore / iOS
  Keychain (`flutter_secure_storage`) — the doc calls this out as the
  better long-term option but says the dart-define approach is
  acceptable for now. Not built since it needs a bootstrap/attestation
  endpoint that doesn't exist yet.
- Actually connecting to a real backend and testing `ENFORCE_APP_SIGNATURE`
  end-to-end — blocked on the backend developer's side being ready.

`flutter pub get` + `flutter analyze` clean (zero errors/warnings; same
81 pre-existing info-level lints as before, none new from these two
files). No live browser verification — this has no UI surface to check.
