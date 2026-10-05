# GlamQ Development Rules & Guidelines

Welcome to the **GlamQ Development Guidelines**.

This document establishes the coding conventions, architecture constraints, security rules, and development practices for GlamQ. Every developer working on GlamQ must adhere to these standards.

---

## 1. Beginner-Friendly Principles

If you are new to Flutter or software engineering, keep these core principles in mind:

1. **One Step at a Time**: Never attempt to write the entire feature at once. Build the data model first, then the repository, then the controller, and finally the screen UI.
2. **Read the Error Messages**: Flutter compiler errors usually state the file, line number, and exact reason for the failure.
3. **Keep Widgets Simple**: A widget should only describe how the screen looks. It should not make network requests or run complex business calculations.
4. **Never Ignore Compiler Warnings**: Treat warnings as future bugs. Keep `flutter analyze` clean with 0 issues.

---

## 2. Naming Conventions

Consistency makes code readable and easy to navigate:

| Target | Convention | Example |
| :--- | :--- | :--- |
| **Folders & Files** | `snake_case.dart` | `booking_card.dart`, `app_constants.dart` |
| **Classes & Enums** | `PascalCase` | `BookingRepository`, `UserRole` |
| **Variables & Functions** | `camelCase` | `fetchNearbyShops()`, `selectedDate` |
| **Constants** | `camelCase` or `kCamelCase` | `appName`, `kDefaultPlatformFee` |
| **Riverpod Providers** | `camelCase` ending in `Provider` | `bookingListProvider`, `authControllerProvider` |

---

## 3. Coding Rules

1. **No `print()` in Production Code**:
   - Never use raw `print()` statements.
   - Use `AppLogger.info()`, `AppLogger.warning()`, or `AppLogger.error()` from `lib/core/utils/logger.dart`.
2. **Strong Typing Everywhere**:
   - Always declare explicit return types on functions and methods:
     ```dart
     // GOOD:
     Future<List<Shop>> getNearbyShops() async { ... }

     // BAD:
     getNearbyShops() async { ... }
     ```
   - Avoid `dynamic` unless interacting with untyped JSON during initial deserialization.
3. **Immutability by Default**:
   - Mark model properties as `final`.
   - Use `const` constructors wherever possible to optimize Flutter rendering performance.

---

## 4. State Management Rules (Riverpod)

1. **Wrap at Root**: The root app is wrapped in `ProviderScope` in `main.dart`.
2. **Presentation Uses Consumer Widgets**:
   - Use `ConsumerWidget` or `ConsumerStatefulWidget` for screens that listen to state.
   - Use `ref.watch()` inside `build()` to rebuild when state updates.
   - Use `ref.read()` inside button callbacks or event handlers to trigger actions without creating rebuild subscriptions.
3. **No Business Logic in Widgets**:
   - Widgets must only handle layout, styling, and user gesture dispatching.
   - Complex state transformations, validation, and network coordination must reside inside StateNotifiers/AsyncNotifiers.
4. **Immutable State Transitions**:
   - Never mutate state objects directly (e.g. `state.items.add(newItem)` is prohibited).
   - Produce a new state object (e.g. `state = state.copyWith(items: [...state.items, newItem])`).

---

## 5. Repository & Data Layer Rules

1. **Abstract Interfaces in Domain**:
   - The domain layer defines the abstract contract:
     ```dart
     // lib/features/booking/domain/repositories/booking_repository.dart
     abstract class BookingRepository {
       Future<Booking> createBooking(CreateBookingParams params);
     }
     ```
2. **Concrete Implementations in Data**:
   - The data layer implements the contract and communicates with the backend:
     ```dart
     // lib/features/booking/data/repositories/supabase_booking_repository.dart
     class SupabaseBookingRepository implements BookingRepository {
       final SupabaseClient _supabase;
       SupabaseBookingRepository(this._supabase);
       ...
     }
     ```
3. **Catch Exceptions, Return Failures**:
   - The repository catches technical exceptions (`PostgrestException`, `SocketException`) and converts them into domain `Failure` objects (e.g. `ServerFailure`, `NetworkFailure`).
   - Never let raw database exception stacks crash the UI.

---

## 6. Security Rules

1. **No Secret Keys in Client Code**:
   - **NEVER** place secret keys, webhook secrets, or admin credentials in client Flutter code.
   - **NEVER** expose the Supabase `service_role` key in Flutter. The client app must **only** receive the public `anon` key.
2. **Row Level Security (RLS)**:
   - Assume all PostgreSQL tables have Row Level Security enabled.
   - Never rely on client-side code alone to protect data. The database RLS policies enforce access control based on the authenticated user's JWT ID.
3. **Environment Configuration**:
   - Use compile-time environment variables (`--dart-define` or `.env` via configuration service) for API endpoints and public keys.
4. **No Financial Movement in Client Code**:
   - Never initiate money transfers, merchant payouts, or platform fee withdrawals directly from the client device. All financial operations must execute securely through Supabase Edge Functions or backend webhooks.

---

## 7. Dependency Rules

1. **Audit Before Adding**:
   - Do not add packages casually. Each package increases app bundle size, maintenance complexity, and security surface.
2. **Prefer Flutter Standards**:
   - Prefer standard Flutter/Dart capabilities where practical before importing external libraries.
3. **Phase-Gated Dependencies**:
   - Do not install Supabase, Firebase, Razorpay, or Google Maps packages ahead of time.
   - Add them only during the dedicated step where their integration is actively developed and tested.
4. **Stable Versions Only**:
   - Use stable packages compatible with the current Flutter and Dart SDK versions.

---

## 8. Testing Rules

1. **Unit Tests (`test/unit/`)**:
   - Test domain models, serialization, and business logic methods without rendering widgets.
2. **Repository Tests (`test/repositories/`)**:
   - Test repository implementations using mocked data sources.
3. **Widget Tests (`test/widgets/` or `test/widget_test.dart`)**:
   - Test critical UI flows, form validation, and state display using `tester.pumpWidget()` within a mock `ProviderScope`.
4. **Continuous Quality Check**:
   - Before finishing any step, always run:
     1. `flutter analyze` (must report `No issues found!`)
     2. `flutter test` (must report `All tests passed!`)

---

## 9. How to Add a New Feature (Step-by-Step)

When implementing a new feature in GlamQ, follow this sequence:

1. **Step 1: Domain Definition**
   - Create `lib/features/<name>/domain/models/` (pure entities).
   - Create `lib/features/<name>/domain/repositories/` (abstract interfaces).
2. **Step 2: Data Implementation**
   - Create `lib/features/<name>/data/datasources/` (API / Supabase calls).
   - Create `lib/features/<name>/data/repositories/` (implements domain interface).
3. **Step 3: State Management**
   - Create `lib/features/<name>/presentation/controllers/` (Riverpod notifier).
4. **Step 4: Presentation UI**
   - Create `lib/features/<name>/presentation/screens/` and `widgets/`.
   - Connect the screen to the controller using `ref.watch()`.
5. **Step 5: Route Integration**
   - Add the new route to `lib/app/router.dart`.
6. **Step 6: Verification**
   - Run `flutter analyze` and `flutter test`.
