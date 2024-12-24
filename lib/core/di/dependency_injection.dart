import 'package:get_it/get_it.dart';

import '../../features/auth/di/auth_di.dart';
import '../../features/profile/di/profile_injection_container.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  /// Auth
  await authSetup();

  /// Profile feature
  await initProfile();
}
