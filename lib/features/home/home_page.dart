import 'package:boiler_plater_flutter_v3/core/route/route_constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/storage_constant.dart';
import '../../core/data/sharedPref/secure_storage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: ()  {
           SecureStorageHelper.delete(StorageConstant.isLoggedIn);
           SecureStorageHelper.delete(StorageConstant.accessToken);
           SecureStorageHelper.delete(StorageConstant.refreshToken);

          context.go(RouteConstant.sendOtp);
        },
        child: const Text("LogOut"),
      ),
    );
  }
}
