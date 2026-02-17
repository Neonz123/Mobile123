class UserProfile {
  final int id;         // Added this to match DB
  final String name;     // Changed from 'username' to 'name'
  final String email;    // Added this
  final String membership;

  UserProfile({
    required this.id, 
    required this.name, 
    required this.email, 
    required this.membership
  });

  // inside user_profile.dart
factory UserProfile.fromJson(Map<String, dynamic> json) {
  return UserProfile(
    id: json['id'] ?? 0,
    name: json['name'] ?? 'Guest', // Must be 'name'
    email: json['email'] ?? 'No Email',
    membership: json['membership_type'] ?? 'Standard',
  );
}
}