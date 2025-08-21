import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(UserModel user, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> login(String email, String password) async {
    // Mock implementation - replace with actual API calls
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate login validation
    if (email.isNotEmpty && password.length >= 6) {
      return UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: email.split('@')[0],
        role: UserRole.guest,
        createdAt: DateTime.now(),
      );
    } else {
      throw Exception('Invalid credentials');
    }
  }

  @override
  Future<UserModel> register(UserModel user, String password) async {
    // Mock implementation - replace with actual API calls
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate registration
    if (password.length >= 6) {
      return user;
    } else {
      throw Exception('Registration failed');
    }
  }
}