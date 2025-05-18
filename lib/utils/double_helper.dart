String formatSmartClean(double value) {
  return (value % 1 == 0)
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(2).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
}