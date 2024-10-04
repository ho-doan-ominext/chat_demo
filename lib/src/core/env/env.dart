class AppEnv {
  AppEnv._();

  final String appName = const String.fromEnvironment('APP_NAME');
  final String appFlavor = const String.fromEnvironment('APP_FLAVOR');
  final String appWebLink = const String.fromEnvironment('APP_WEB_LINK');
  final String appSuffix = const String.fromEnvironment('APP_ID_SUFFIX');
  final String ipNotification = const String.fromEnvironment('IP_NOTIFICATION');
  final String portNotification =
      const String.fromEnvironment('PORT_NOTIFICATION');

  static final instance = AppEnv._();
}
