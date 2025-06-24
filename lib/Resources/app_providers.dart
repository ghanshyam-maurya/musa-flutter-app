import 'package:musa_app/Cubit/Comment/comment_cubit.dart';
import 'package:musa_app/Cubit/auth/Otp/otp_cubit.dart';
import 'package:musa_app/Utility/packages.dart';

import '../Cubit/like_cubit.dart';

List<BlocProvider> providers = [
  BlocProvider(
    create: (context) => SetupCubit(),
  ),
  BlocProvider(
    create: (context) => OtpCubit(),
  ),
  BlocProvider(create: (context) => LikeCubit()), // Global LikeCubit
  BlocProvider(create: (context) => CommentCubit()), // Global LikeCubit
];
