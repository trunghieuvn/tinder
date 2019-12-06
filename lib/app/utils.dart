
import 'package:package_info/package_info.dart';
import 'package:tinder/app/configs.dart';

void printLog(data) {
  if (CHEAT == true || buildFlavor != BuildFlavor.production) {
    String text = "$LOG_TAG${data.toString()}";

    if(FULL_LOG == true) {
      final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
      pattern.allMatches(text).forEach((match) => print(match.group(0)));
    }
    else {
      print("[MYAPP]$text");
    }
  }
}


class Dimension {
  static double height = 0.0;
  static double width = 0.0;

  static double getWidth(double size) {
    return width * size;
  }

  static double getHeight(double size) {
    return height * size;
  }
}

Future<PackageInfo> getPackageInfo() {
  return PackageInfo.fromPlatform();
}

String getEnvBuild() {
  return bool.fromEnvironment("dart.vm.product") == true
      ? "R"
      : "D" + buildFlavor.toString().split('.').last;
}

appSetup() async {
  var packageInfo = await getPackageInfo();
  appVersion = "${packageInfo.version}+${packageInfo.buildNumber} ${getEnvBuild()}";
}