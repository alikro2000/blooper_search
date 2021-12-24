abstract class Utils {
  static List andOf(List postingList1, List postingList2) {
    var ids1 = postingList1.toSet();
    var ids2 = postingList2.toSet();
    var intersection = ids1.intersection(ids2);
    return intersection.toList();
  }

  static List orOf(List postingList1, List postingList2) {
    var ids1 = postingList1.toSet();
    var ids2 = postingList2.toSet();
    return ids1.union(ids2).toList();
  }

  static List notOf(List postingList1, List postingList2) {
    var ids1 = postingList1.toSet();
    var ids2 = postingList2.toSet();
    return ids1.difference(ids2).toList();
  }
}
