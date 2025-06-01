

class Helper {
  // Convert hex string to Color
  static int getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;  // add opacity if not specified
    }
    return int.parse(hexColor, radix: 16);
  }
}