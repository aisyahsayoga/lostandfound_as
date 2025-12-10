import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as Models;

class AppUser {
  final String id;
  final String name;
  final String email;
  final String? avatarFileId;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatarFileId,
  });
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final Client _client = Client();
  late final Account _account;
  late final Databases _databases;
  late final Storage _storage;

  String _databaseId = '6938117c00204ffcbd56';
  String _usersCollectionId = 'users';
  String _itemsCollectionId = 'items';
  String? _bucketId = '69381263000d9cb370bc';
  String _projectId = '';
  String _endpoint = '';

  final StreamController<AppUser?> _userController =
      StreamController<AppUser?>.broadcast();
  AppUser? _currentUser;

  void init({
    required String endpoint,
    required String projectId,
    required String databaseId,
    required String usersCollectionId,
    required String itemsCollectionId,
    String? bucketId,
  }) {
    _client
      ..setEndpoint(endpoint)
      ..setProject(projectId);
    _account = Account(_client);
    _databases = Databases(_client);
    _storage = Storage(_client);
    _databaseId = databaseId;
    _usersCollectionId = usersCollectionId;
    _itemsCollectionId = itemsCollectionId;
    _bucketId = bucketId;
    _projectId = projectId;
    _endpoint = endpoint;
    _refreshUser();
  }

  AppUser? get currentUser => _currentUser;
  String? get currentUserId => _currentUser?.id;
  Stream<AppUser?> get authStateChanges => _userController.stream;
  Future<void> refreshUser() => _refreshUser();

  Future<void> _refreshUser() async {
    try {
      final user = await _account.get();
      String? avatarId;
      try {
        final list = await _databases.listDocuments(
          databaseId: _databaseId,
          collectionId: _usersCollectionId,
          queries: [Query.equal('accountId', user.$id)],
        );
        if (list.total > 0) {
          final doc = list.documents.first;
          final data = doc.data;
          final val = data['avatarFileId'];
          if (val is String && val.isNotEmpty) avatarId = val;
        }
      } catch (_) {}
      _currentUser = AppUser(
        id: user.$id,
        name: user.name,
        email: user.email,
        avatarFileId: avatarId,
      );
      _userController.add(_currentUser);
    } on AppwriteException catch (e) {
      if (e.code == 401 || e.code == 403) {
        _currentUser = null;
        _userController.add(null);
      } else {
        // keep last known user on transient errors
        _userController.add(_currentUser);
      }
    } catch (_) {
      // keep last known user on unexpected errors
      _userController.add(_currentUser);
    }
  }

  Future<bool> signUp(
    String name,
    String email,
    String password,
    String confirmPassword, {
    String? avatarPath,
  }) async {
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      throw Exception('Semua field harus diisi');
    }
    if (password != confirmPassword) {
      throw Exception('Password dan konfirmasi password tidak cocok');
    }
    if (password.length < 8) {
      throw Exception('Password minimal 8 karakter');
    }
    final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    final hasLower = RegExp(r'[a-z]').hasMatch(password);
    final hasDigit = RegExp(r'[0-9]').hasMatch(password);
    if (!(hasUpper && hasLower && hasDigit)) {
      throw Exception(
        'Password harus mengandung huruf besar, huruf kecil, dan angka',
      );
    }
    const common = {
      'password',
      '12345678',
      'qwerty',
      '123456789',
      'iloveyou',
      'admin',
      'letmein',
    };
    if (common.contains(password.toLowerCase())) {
      throw Exception(
        'Password terlalu umum, gunakan kombinasi yang lebih kuat',
      );
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      throw Exception('Format email tidak valid');
    }

    final created = await _account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: name,
    );

    // clear any existing session to avoid 'session already exists' errors
    try {
      await _account.deleteSessions();
    } catch (_) {}
    await _account.createEmailPasswordSession(email: email, password: password);
    String? avatarFileId;
    if (avatarPath != null && avatarPath.isNotEmpty && _bucketId != null) {
      try {
        avatarFileId = await uploadFileFromPath(avatarPath);
      } catch (_) {}
    }
    await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: _usersCollectionId,
      documentId: ID.unique(),
      data: {
        'accountId': created.$id,
        'fullname': name,
        'email': email,
        'createAt': DateTime.now().toIso8601String(),
        'avatarFileId': avatarFileId,
      },
      permissions: [
        Permission.read(Role.user(created.$id)),
        Permission.update(Role.user(created.$id)),
        Permission.delete(Role.user(created.$id)),
      ],
    );

    await _refreshUser();
    return true;
  }

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email dan password harus diisi');
    }
    // ensure logging into intended account even if another session is active
    try {
      final existing = await _account.get();
      if (existing.email.toLowerCase() == email.toLowerCase()) {
        await _refreshUser();
        return true;
      } else {
        await _account.deleteSessions();
      }
    } catch (_) {}
    await _account.createEmailPasswordSession(email: email, password: password);
    await _refreshUser();
    return true;
  }

  Future<void> logout() async {
    await _account.deleteSession(sessionId: 'current');
    await _refreshUser();
  }

  Future<void> updateName(String name) async {
    if (_currentUser == null) throw Exception('Anda belum login');
    await _account.updateName(name: name);
    // sinkronkan ke dokumen users
    final list = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _usersCollectionId,
      queries: [Query.equal('accountId', _currentUser!.id)],
    );
    if (list.total > 0) {
      final doc = list.documents.first;
      await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: _usersCollectionId,
        documentId: doc.$id,
        data: {'fullname': name},
      );
    } else {
      await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _usersCollectionId,
        documentId: ID.unique(),
        data: {
          'accountId': _currentUser!.id,
          'fullname': name,
          'email': _currentUser!.email,
          'createAt': DateTime.now().toIso8601String(),
        },
        permissions: [
          Permission.read(Role.user(_currentUser!.id)),
          Permission.update(Role.user(_currentUser!.id)),
          Permission.delete(Role.user(_currentUser!.id)),
        ],
      );
    }
    await _refreshUser();
  }

  Future<String?> updateAvatarFromPath(String path) async {
    if (_currentUser == null) throw Exception('Anda belum login');
    if (_bucketId == null) throw Exception('Bucket ID belum dikonfigurasi');
    final fid = await uploadFileFromPath(path);
    final list = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _usersCollectionId,
      queries: [Query.equal('accountId', _currentUser!.id)],
    );
    if (list.total > 0) {
      final doc = list.documents.first;
      await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: _usersCollectionId,
        documentId: doc.$id,
        data: {'avatarFileId': fid},
      );
    } else {
      await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _usersCollectionId,
        documentId: ID.unique(),
        data: {
          'accountId': _currentUser!.id,
          'fullname': _currentUser!.name,
          'email': _currentUser!.email,
          'createAt': DateTime.now().toIso8601String(),
          'avatarFileId': fid,
        },
        permissions: [
          Permission.read(Role.user(_currentUser!.id)),
          Permission.update(Role.user(_currentUser!.id)),
          Permission.delete(Role.user(_currentUser!.id)),
        ],
      );
    }
    await _refreshUser();
    return fid;
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _account.updatePassword(
      password: newPassword,
      oldPassword: oldPassword,
    );
  }

  Future<void> requestPasswordReset(
    String email, {
    String redirectUrl = 'https://appwrite.io/recovery',
  }) async {
    await _account.createRecovery(email: email, url: redirectUrl);
  }

  Future<List<Models.Document>> listRecentItems() async {
    final res = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _itemsCollectionId,
      queries: [
        Query.equal('isFound', false),
        Query.orderDesc('createdAt'),
        Query.limit(50),
      ],
    );
    return res.documents;
  }

  Future<List<Models.Document>> listRecentAllItems({int limit = 20}) async {
    final res = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _itemsCollectionId,
      queries: [Query.orderDesc('createdAt'), Query.limit(limit)],
    );
    return res.documents;
  }

  Future<List<Models.Document>> listItemsByCategory(
    String category, {
    int limit = 20,
  }) async {
    final res = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _itemsCollectionId,
      queries: [
        Query.equal('category', category),
        Query.orderDesc('createdAt'),
        Query.limit(limit),
      ],
    );
    return res.documents;
  }

  Future<Map<String, int>> getItemCounts() async {
    final lost = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _itemsCollectionId,
      queries: [Query.equal('isFound', false), Query.limit(1)],
    );
    final found = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _itemsCollectionId,
      queries: [Query.equal('isFound', true), Query.limit(1)],
    );
    return {'lost': lost.total, 'found': found.total, 'resolved': 0};
  }

  Future<List<Models.Document>> listMyReports() async {
    if (_currentUser == null) return [];
    final res = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _itemsCollectionId,
      queries: [
        Query.equal('reporterId', _currentUser!.id),
        Query.orderDesc('createdAt'),
      ],
    );
    return res.documents;
  }

  Future<Models.Document> createItem({
    required String title,
    required String description,
    required String category,
    required String location,
    required DateTime reportDate,
    required bool isFound,
    List<String>? imageIds,
  }) async {
    if (_currentUser == null) throw Exception('Anda harus login');
    final doc = await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: _itemsCollectionId,
      documentId: ID.unique(),
      data: {
        'title': title,
        'description': description,
        'category': category,
        'location': location,
        'reportDate': reportDate.toIso8601String(),
        'isFound': isFound,
        'imageIds': imageIds ?? [],
        'reporterId': _currentUser!.id,
        'createdAt': DateTime.now().toIso8601String(),
      },
      permissions: [
        Permission.read(Role.any()),
        Permission.update(Role.user(_currentUser!.id)),
        Permission.delete(Role.user(_currentUser!.id)),
      ],
    );
    return doc;
  }

  Future<String> uploadFileFromPath(String path) async {
    if (_bucketId == null) throw Exception('Bucket ID belum dikonfigurasi');
    final res = await _storage.createFile(
      bucketId: _bucketId!,
      fileId: ID.unique(),
      file: InputFile.fromPath(path: path),
    );
    return res.$id;
  }

  String? fileViewUrl(String? fileId) {
    if (fileId == null || _bucketId == null) return null;
    return '$_endpoint/storage/buckets/${_bucketId!}/files/$fileId/view?project=$_projectId';
  }

  Future<Models.Document> getItem(String documentId) async {
    return _databases.getDocument(
      databaseId: _databaseId,
      collectionId: _itemsCollectionId,
      documentId: documentId,
    );
  }

  Future<void> markItemFound(String documentId) async {
    await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: _itemsCollectionId,
      documentId: documentId,
      data: {'isFound': true},
    );
  }
}
