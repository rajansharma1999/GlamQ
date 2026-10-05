# Booking Feature

## Scope
Appointment booking workflows:
- Date, time slot, service, and staff selection.
- Booking creation, status tracking (pending, confirmed, cancelled, completed).
- Booking history for customers and incoming booking management for shop owners.

## Planned Layer Structure:
- `presentation/`: Booking stepper, slot picker, booking details screen, booking controllers.
- `domain/`: Booking entity, booking status enum, booking repository interface.
- `data/`: Booking data source, Supabase booking repository.
