const baseSVGPath = "assets/svg/";
const baseImagePath = "assets/images/";

final kMarkerIcon = _getImageBasePath('marker3.png');
final kLogoIcon = _getImageBasePath('logo.png');

//svg function here...
String _getSvgBasePath(String name) {
  return baseSVGPath + name;
}

//image function here...
String _getImageBasePath(String name) {
  return baseImagePath + name;
}
