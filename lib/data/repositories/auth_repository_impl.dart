import 'package:uuid/uuid.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<User> login(String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      await localDataSource.cacheUser(userModel);
      return userModel.toEntity();
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<User> register(String email, String password, String name, UserRole role) async {
    try {
      final userModel = UserModel(
        id: const Uuid().v4(),
        email: email,
        name: name,
        role: role,
        createdAt: DateTime.now(),
      );
      
      final registeredUser = await remoteDataSource.register(userModel, password);
      await localDataSource.cacheUser(registeredUser);
      return registeredUser.toEntity();
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearUser();
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userModel = await localDataSource.getCachedUser();
      return userModel?.toEntity();
    } catch (e) {
      return null;
    }
  }
}