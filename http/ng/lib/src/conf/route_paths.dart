import 'package:angular_router/angular_router.dart';

const id = "id";
const type = "type";

class RoutePaths {
  static final dash = RoutePath(path: 'dash');
  static final list = RoutePath(path: 'list/:$type');
  static final detail = RoutePath(path: 'detail/:$type/:$id');
  static final admin = RoutePath(path: 'admin');
}

int getIdFrom(Map<String, String> parameters) {
  return parameters[id] == null ? null : int.tryParse(parameters[id]);
}
String getTypeFrom(Map<String, String> parameters) {
  return parameters[type] == null ? null : parameters[type].toString().trim();
}
