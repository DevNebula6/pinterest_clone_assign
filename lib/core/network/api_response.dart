import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

// return type for all repository methods - either a Failure or the actual data
typedef ApiResult<T> = Future<Either<Failure, T>>;
