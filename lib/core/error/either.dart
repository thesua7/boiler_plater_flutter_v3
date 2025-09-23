/// Either class for functional error handling
abstract class Either<L, R> {
  const Either();

  /// Create a Left (failure) value
  factory Either.left(L value) = Left<L, R>;

  /// Create a Right (success) value
  factory Either.right(R value) = Right<L, R>;

  /// Check if this is a Left value
  bool get isLeft => this is Left<L, R>;

  /// Check if this is a Right value
  bool get isRight => this is Right<L, R>;

  /// Get the Left value (throws if not Left)
  L get left => (this as Left<L, R>).value;

  /// Get the Right value (throws if not Right)
  R get right => (this as Right<L, R>).value;

  /// Transform the Right value
  Either<L, T> map<T>(T Function(R) transform) {
    if (isRight) {
      return Either.right(transform(right));
    } else {
      return Either.left(left);
    }
  }

  /// Transform the Left value
  Either<T, R> mapLeft<T>(T Function(L) transform) {
    if (isLeft) {
      return Either.left(transform(left));
    } else {
      return Either.right(right);
    }
  }

  /// Fold both Left and Right values
  T fold<T>(T Function(L) onLeft, T Function(R) onRight) {
    if (isLeft) {
      return onLeft(left);
    } else {
      return onRight(right);
    }
  }

  /// Chain operations that return Either
  Either<L, T> flatMap<T>(Either<L, T> Function(R) transform) {
    if (isRight) {
      return transform(right);
    } else {
      return Either.left(left);
    }
  }

  /// Get value or default
  R getOrElse(R defaultValue) {
    return isRight ? right : defaultValue;
  }

  /// Get value or throw
  R getOrThrow() {
    if (isRight) {
      return right;
    } else {
      throw Exception('Expected Right but got Left: $left');
    }
  }
}

/// Left (failure) value
class Left<L, R> extends Either<L, R> {
  final L value;

  const Left(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Left<L, R> && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Left($value)';
}

/// Right (success) value
class Right<L, R> extends Either<L, R> {
  final R value;

  const Right(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Right<L, R> && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Right($value)';
}
