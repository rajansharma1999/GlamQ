# Auth Feature

## Scope
Manages user authentication, session persistence, role determination, and onboarding.

## Planned Layer Structure (to be implemented incrementally):
- `presentation/`: Login, OTP, registration screens and state controllers.
- `domain/`: Auth models (`UserAccount`, `AuthSession`), repository interfaces.
- `data/`: Supabase Auth repository implementation and token storage.
