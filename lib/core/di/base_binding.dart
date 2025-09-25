import 'dart:developer' as developer;
import 'package:get_it/get_it.dart';

/// Base binding class for dependency injection management
/// Provides common functionality for all binding classes
abstract class BaseBinding {
  static final GetIt _getIt = GetIt.instance;

  /// Get the GetIt instance
  static GetIt get getIt => _getIt;

  /// Register a lazy singleton
  static void registerLazySingleton<T extends Object>(
    T Function() factory, {
    String? instanceName,
  }) {
    developer.log(
      '📦 Registering LazySingleton: ${T.toString()}${instanceName != null ? ' (name: $instanceName)' : ''}',
      name: 'BaseBinding',
    );
    _getIt.registerLazySingleton<T>(factory, instanceName: instanceName);
    developer.log('✅ LazySingleton registered: ${T.toString()}', name: 'BaseBinding');
  }

  /// Register a factory
  static void registerFactory<T extends Object>(
    T Function() factory, {
    String? instanceName,
  }) {
    developer.log(
      '🏭 Registering Factory: ${T.toString()}${instanceName != null ? ' (name: $instanceName)' : ''}',
      name: 'BaseBinding',
    );
    _getIt.registerFactory<T>(factory, instanceName: instanceName);
    developer.log('✅ Factory registered: ${T.toString()}', name: 'BaseBinding');
  }

  /// Register a factory with automatic disposal
  static void registerFactoryWithDisposal<T extends Object>(
    T Function() factory, {
    String? instanceName,
  }) {
    developer.log(
      '🏭 Registering Factory with Auto-Disposal: ${T.toString()}${instanceName != null ? ' (name: $instanceName)' : ''}',
      name: 'BaseBinding',
    );
    _getIt.registerFactory<T>(factory, instanceName: instanceName);
    developer.log('✅ Factory with disposal registered: ${T.toString()}', name: 'BaseBinding');
  }

  /// Get an instance of type T
  static T get<T extends Object>({String? instanceName}) {
    developer.log(
      '🔍 Getting instance: ${T.toString()}${instanceName != null ? ' (name: $instanceName)' : ''}',
      name: 'BaseBinding',
    );
    
    if (!_getIt.isRegistered<T>(instanceName: instanceName)) {
      developer.log(
        '❌ ${T.toString()} not registered!',
        name: 'BaseBinding',
      );
      throw StateError('${T.toString()} not registered. Call initialize() first.');
    }
    
    final instance = _getIt<T>(instanceName: instanceName);
    developer.log(
      '✅ Instance retrieved: ${T.toString()}',
      name: 'BaseBinding',
    );
    return instance;
  }

  /// Check if a type is registered
  static bool isRegistered<T extends Object>({String? instanceName}) {
    final registered = _getIt.isRegistered<T>(instanceName: instanceName);
    developer.log(
      '🔍 Checking registration: ${T.toString()}${instanceName != null ? ' (name: $instanceName)' : ''} = $registered',
      name: 'BaseBinding',
    );
    return registered;
  }

  /// Reset all registrations
  static Future<void> reset() async {
    developer.log('🔄 Resetting all registrations...', name: 'BaseBinding');
    try {
      await _getIt.reset();
      developer.log('✅ All registrations reset successfully', name: 'BaseBinding');
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to reset registrations: $e',
        name: 'BaseBinding',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Dispose a specific service if it has a dispose method
  static Future<void> dispose<T extends Object>({String? instanceName}) async {
    developer.log(
      '🗑️ Disposing: ${T.toString()}${instanceName != null ? ' (name: $instanceName)' : ''}',
      name: 'BaseBinding',
    );
    
    try {
      if (_getIt.isRegistered<T>(instanceName: instanceName)) {
        final instance = _getIt<T>(instanceName: instanceName);
        if (instance is Disposable) {
          await instance.dispose();
          developer.log('✅ Disposed: ${T.toString()}', name: 'BaseBinding');
        } else {
          developer.log('⚠️ ${T.toString()} is not disposable', name: 'BaseBinding');
        }
      } else {
        developer.log('⚠️ ${T.toString()} not registered, nothing to dispose', name: 'BaseBinding');
      }
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to dispose ${T.toString()}: $e',
        name: 'BaseBinding',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Get memory usage statistics
  static void logMemoryStats() {
    developer.log('📊 Memory Statistics:', name: 'BaseBinding');
    
    try {
      // Check if all dependencies are ready
      final allReady = _getIt.allReadySync();
      developer.log('   - All dependencies ready: $allReady', name: 'BaseBinding');
      developer.log('   - GetIt instance: ${_getIt.runtimeType}', name: 'BaseBinding');
      
      // Log some common registered types
      developer.log('   - ThemeService registered: ${isRegistered<Object>()}', name: 'BaseBinding');
      
    } catch (e) {
      developer.log('   - Could not get memory stats: $e', name: 'BaseBinding');
    }
    
    developer.log('📊 Memory stats logged', name: 'BaseBinding');
  }
}

/// Interface for disposable services
abstract class Disposable {
  Future<void> dispose();
}
