// di komen karena ada fungsi main
// void main() {
//   List<int> list = [300, 100, 200];
  
//   List<int> sortedList = sortWithLowestInMiddle(list);
  
//   print(sortedList); // Output: [200, 100, 300]
// }

List<int> sortWithLowestInMiddle(List<int> list) {
  List<int> sortedList = List.from(list); // Create a copy of the original list
  
  sortedList.sort(); // Sort the list in ascending order
  
  int lowestValue = sortedList.first; // Get the lowest value
  
  sortedList.remove(lowestValue); // Remove the lowest value from the list
  
  // Insert the lowest value in the middle
  sortedList.insert(sortedList.length ~/ 2, lowestValue);
  
  return sortedList;
}
