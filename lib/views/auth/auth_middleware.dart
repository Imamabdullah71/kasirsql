import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:kasirsql/views/auth/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return null;
  }

  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig route) async {
    bool isLoggedIn = await AuthService.getLoginStatus();
    if (!isLoggedIn) {
      return GetNavConfig.fromRoute('/login');
    }
    return super.redirectDelegate(route);
  }
}
