# Queue Feature

## Scope
Physical and digital queue management:
- Customer arrival check-in and queue token generation.
- Real-time queue status (current serving token, estimated wait time, live position).
- Shop owner queue controls (call next, start service, complete service, mark no-show).

## Planned Layer Structure:
- `presentation/`: Queue tracker widget/screen, shop owner live queue console.
- `domain/`: Queue ticket entity, queue status enum, queue repository interface.
- `data/`: Real-time queue subscription repository using Supabase Realtime.
