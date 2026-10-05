# GlamQ System Architecture

Welcome to the **GlamQ Architecture Document**. 

This document explains how the GlamQ application is structured, how data flows through the application, and the architectural principles guiding future development.

---

## 1. High-Level Overview

GlamQ is a multi-category service marketplace connecting **Customers**, **Shop Owners**, and **Platform Admins**.

### Supported User Roles
1. **Customer**: Discovers nearby shops, views service menus, books appointments, joins physical/digital queues, tracks wait times, and views booking history.
2. **Shop Owner**: Creates and manages shop profiles, catalogues services, configures staff and schedules, receives bookings, runs live queue operations, and views business earnings.
3. **Admin**: Approves new shops, monitors platform activity, oversees bookings, manages dispute resolution, and tracks platform fee revenue.

---

## 2. Business Categories & Interaction Models

Different service businesses operate under different workflows. Rather than forcing every category into a single mold, GlamQ abstracts business categories and their **Interaction Models**.

### Current Categories in Scope
| Category | Interaction Model | MVP Scope? | Description |
| :--- | :--- | :--- | :--- |
| **Salon** | **Appointment + Queue** | **YES (MVP)** | Fixed booking with live queue tracking upon arrival |
| **Barber** | **Appointment + Queue** | **YES (MVP)** | Walk-in / appointment combo with queue management |
| **Beauty Parlour** | **Appointment + Queue** | **YES (MVP)** | Pre-booked beauty services with real-time wait status |
| **Boutique** | Appointment | Post-MVP | Dedicated fitting/consultation appointments |
| **Dry Cleaner** | Order + Tracking | Post-MVP | Itemized laundry orders, pickup & delivery tracking |
| **Grocery** | Order / Listing | Post-MVP | Product listing, cart, and local order fulfillment |

> **Explicit Out-of-Scope Notice**:  
> **Mobile Repair** and **Showroom** are **NOT** in scope. No database tables, screens, UI elements, routes, or business logic will be designed or implemented for them.

---

## 3. Current MVP Boundary

The first GlamQ MVP focuses **strictly** on:
- **Categories**: Salon, Barber, Beauty Parlour
- **Interaction Model**: Appointment + Queue
- **Core Functionality**:
  - **Customer**: Shop discovery, service selection, slot booking, arrival check-in, live queue status, booking history.
  - **Shop Owner**: Profile setup, staff/service configuration, availability management, incoming booking management, live queue progression (call next, start, complete service).
  - **Admin**: Shop approval, basic user management, booking oversight, platform fee records.

### Configurable Platform Fee
- The initial baseline platform fee is **₹8 per completed booking**.
- **Architectural Rule**: This fee is **strictly configurable** from the backend/admin configuration. It is **never hard-coded** into calculation logic or client-side transactions.

---

## 4. Frontend Architecture: Feature-First & Clean Layers

GlamQ follows a **Feature-First Clean Architecture**. Code is organized by domain features rather than technical layers. Inside each feature, we maintain strict separation of concerns into three distinct layers:

```text
lib/
├── app/                  # Application bootstrap, routing, and theme
│   ├── app.dart          # Root GlamQApp ConsumerWidget
│   ├── router.dart       # Centralized GoRouter routing configuration
│   └── theme/            # Centralized Material 3 colors, typography, theme
├── core/                 # Shared technical infrastructure across all features
│   ├── constants/        # App-wide constants (AppConstants)
│   ├── errors/           # AppExceptions and domain Failures
│   ├── extensions/       # BuildContext extensions
│   ├── services/         # Cross-cutting platform services
│   └── utils/            # Developer utilities (AppLogger)
├── features/             # Business modules (Feature-First)
│   ├── auth/             # Login, OTP, registration, session management
│   ├── customer/         # Discovery, nearby shops, shop details
│   ├── shop_owner/       # Shop profile, staff, hours, services, earnings
│   ├── admin/            # Approvals, platform metrics, disputes
│   ├── booking/          # Slot selection, booking creation, lifecycle
│   ├── queue/            # Arrival check-in, real-time wait queue tracking
│   └── profile/          # User profile, preferences, settings
├── shared/               # Reusable UI widgets and common models
│   ├── models/           # Common data types (e.g., UserRole)
│   └── widgets/          # Common components (AppShell, LoadingIndicator)
└── main.dart             # Program entry point with Riverpod ProviderScope
```

### The Three Layers Within Each Feature:

```
┌─────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                      │
│   • Flutter Widgets & Screens                               │
│   • Riverpod Notifiers / State Controllers                  │
│   • Does NOT know about Supabase or SQL                     │
└──────────────────────────────▲──────────────────────────────┘
                               │ (Calls usecases/repos)
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                        DOMAIN LAYER                         │
│   • Pure Dart entities & models                             │
│   • Abstract repository interfaces                          │
│   • Business rules & validation                             │
│   • Independent of Flutter & external frameworks            │
└──────────────────────────────▲──────────────────────────────┘
                               │ (Implements interfaces)
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                         DATA LAYER                          │
│   • Concrete repository implementations                     │
│   • Data transfer objects (DTOs) & JSON mappers             │
│   • Remote data sources (Supabase client queries)           │
│   • Catches exceptions and returns domain Failures          │
└─────────────────────────────────────────────────────────────┘
```

1. **Presentation Layer**:
   - Contains UI widgets and screens.
   - Listens to Riverpod providers for UI state.
   - Sends user actions to Riverpod controllers.
   - **Rule**: Never run database queries, network calls, or payment logic directly inside a widget.

2. **Domain Layer**:
   - The heart of the business logic.
   - Contains pure Dart models and abstract repository contracts (e.g., `abstract class BookingRepository`).
   - Completely independent of third-party libraries (no Supabase, Flutter UI, or database imports).

3. **Data Layer**:
   - Implements the repository contracts defined by the domain layer.
   - Interacts with remote databases (Supabase), local storage, and external APIs.
   - Converts raw network JSON / database records into clean domain entities.
   - Catches technical exceptions (`ServerException`, `NetworkException`) and maps them to user-friendly `Failure` objects.

---

## 5. Data Flow Lifecycle

When a user interacts with the app, the data flows predictably in a one-way loop:

```
[ User Interaction ] 
        │
        ▼
[ Presentation Widget ] ── calls method on ──► [ Riverpod Controller ]
                                                        │
                                                        ▼
[ UI updates via ref.watch() ] ◄── updates state ── [ Repository Interface ]
                                                        │
                                                        ▼
                                            [ Supabase Data Source ]
                                                        │
                                                        ▼
                                            [ PostgreSQL / Supabase Backend ]
```

1. User taps **"Book Appointment"** on the screen.
2. The UI widget calls `ref.read(bookingControllerProvider.notifier).bookSlot(...)`.
3. The controller calls `BookingRepository.createBooking(...)`.
4. The repository executes the query via the Supabase client and verifies the result.
5. If successful, the controller updates its immutable state with the newly created booking.
6. The widget observes the updated state via `ref.watch(...)` and automatically renders the confirmation view.

---

## 6. Future Backend & Cloud Architecture (Planned)

The backend ecosystem planned for GlamQ consists of:

- **Database**: PostgreSQL hosted on **Supabase**.
- **Security**: **Row Level Security (RLS)** policies on all tables so that:
  - Customers can only read and modify their own bookings and profiles.
  - Shop owners can only access their assigned shops, staff, and customer bookings for their shop.
  - Admins can access administrative collections via elevated permissions.
- **Authentication**: **Supabase Auth** (Phone OTP / Email / OAuth) issuing JWT tokens containing user role claims.
- **Realtime**: **Supabase Realtime** powering live queue updates (e.g., current serving token, queue position change) without constant HTTP polling.
- **File Storage**: **Supabase Storage** for shop banners, service photos, and profile avatars.
- **Server-Side Functions**: **Supabase Edge Functions** (TypeScript / Deno) for critical server-side operations (booking verification, platform fee ledger calculations, webhook processing).
- **Push Notifications**: **Firebase Cloud Messaging (FCM)** for status notifications (booking confirmed, queue turn approaching, service completed).
- **Payment Processing**: **Razorpay** and **Razorpay Route** for marketplace payment splitting and automated platform fee collection (deferred to payment implementation phase).
- **Location & Discovery**: **Google Maps Platform** (Places API & Maps SDK) for geolocation-based nearby shop discovery.

---

## 7. Interaction Model Scalability

GlamQ is designed to support diverse business categories:
- A **Salon** requires an appointment slot plus arrival queue check-in.
- A **Dry Cleaner** requires order pickup, weighing/tagging, and status tracking.
- A **Grocery** requires catalog browsing, shopping cart, and fulfillment.

By decoupling the **Interaction Model** from the core shop entity, the shop table can specify its interaction type (e.g. `interaction_model: 'appointment_queue'`). The Flutter app dynamically presents the corresponding workflow router without forcing every business into an appointment flow.
