class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Simple in-memory storage for demo purposes
  final Map<String, String> _users = {};

  // Simulate signup
  Future<bool> signUp(String name, String email, String password, String confirmPassword) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Basic validation
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      throw Exception('Semua field harus diisi');
    }

    if (password != confirmPassword) {
      throw Exception('Password dan konfirmasi password tidak cocok');
    }

    if (password.length < 6) {
      throw Exception('Password minimal 6 karakter');
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      throw Exception('Format email tidak valid');
    }

    if (_users.containsKey(email)) {
      throw Exception('Email sudah terdaftar');
    }

    // Store user (in real app, this would be API call)
    _users[email] = password;
    return true;
  }

  // Simulate login
  Future<bool> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Basic validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email dan password harus diisi');
    }

    if (_users[email] == password) {
      return true;
    } else {
      throw Exception('Email atau password salah');
    }
  }

  // Check if user is logged in (for demo, always false initially)
  bool isLoggedIn() {
    return false; // In real app, check token/storage
  }
}
