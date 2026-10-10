
void main() {
  String mood = "Happy";
  int energy = 8;

  print("Today's mood: $mood");

  if (energy >= 7) {
    print("You have good energy today!");
  } else {
    print("Take some time to relax.");
  }

  showMessage(mood);
}

void showMessage(String mood) {
  print("You selected $mood.");
}
