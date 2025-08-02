import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventAlertStatusProvider = StateProvider.family<bool,int>((ref, id) => false,);