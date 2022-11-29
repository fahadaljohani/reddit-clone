import 'package:fpdart/fpdart.dart';

import 'package:reddit_tutorial/core/common/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
