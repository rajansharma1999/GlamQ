/// Supported user roles in GlamQ.
///
/// 1. [customer]: End users searching for salons, barbers, parlours, booking appointments, and tracking queues.
/// 2. [shopOwner]: Merchants operating shops, managing staff, schedules, bookings, and live queues.
/// 3. [admin]: Platform administrators managing shop approvals, platform health, disputes, and commission ledgers.
enum UserRole {
  customer('customer'),
  shopOwner('shop_owner'),
  admin('admin');

  final String value;
  const UserRole(this.value);

  /// Helper to convert a string (from Supabase/DB) into a [UserRole].
  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (element) => element.value.toLowerCase() == role.toLowerCase(),
      orElse: () => UserRole.customer,
    );
  }

  bool get isCustomer => this == UserRole.customer;
  bool get isShopOwner => this == UserRole.shopOwner;
  bool get isAdmin => this == UserRole.admin;
}
