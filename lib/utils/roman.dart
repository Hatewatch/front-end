int romanToInt(String s) {
  final Map<String, int> romanMap = {
    'I': 1,
    'V': 5,
    'X': 10,
    'L': 50,
    'C': 100,
    'D': 500,
    'M': 1000
  };

  int total = 0;
  int prevValue = 0;

  for (int i = s.length - 1; i >= 0; i--) {
    int value = romanMap[s[i]]!;
    if (value < prevValue) {
      total -= value;
    } else {
      total += value;
      prevValue = value;
    }
  }

  return total;
}