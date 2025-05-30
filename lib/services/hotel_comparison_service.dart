// import 'package:cloud_firestore/cloud_firestore.dart';

// class HotelComparisonService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<String> compareHotels() async {
//     try {
//       final snapshot = await _firestore.collection('hotels').limit(2).get();
//       if (snapshot.docs.length < 2) {
//         return "Not enough hotels available for comparison.";
//       }

//       final hotel1 = snapshot.docs[0].data();
//       final hotel2 = snapshot.docs[1].data();

//       return """
// Here's the comparison between ${hotel1['name']} and ${hotel2['name']}:

// ${hotel1['name']}:
// - Price: \$${hotel1['price']}/night
// - Rating: ${hotel1['rating']}/5
// - Location: ${hotel1['location']}
// - Amenities: ${(hotel1['amenities'] as List).join(', ')}

// ${hotel2['name']}:
// - Price: \$${hotel2['price']}/night
// - Rating: ${hotel2['rating']}/5
// - Location: ${hotel2['location']}
// - Amenities: ${(hotel2['amenities'] as List).join(', ')}
// """;
//     } catch (e) {
//       return "Sorry, I couldn't fetch hotel data. Please try again later.";
//     }
//   }
// }
// import 'package:cloud_firestore/cloud_firestore.dart';

// class HotelComparisonService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final List<String> _selectedHotelIds = [];

//   Future<List<Map<String, dynamic>>> getAllHotels() async {
//     try {
//       final snapshot = await _firestore.collection('hotels').get();
//       return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
//     } catch (e) {
//       print('Error fetching hotels: $e');
//       return [];
//     }
//   }

//   void selectHotel(String hotelId) {
//     if (_selectedHotelIds.contains(hotelId)) {
//       _selectedHotelIds.remove(hotelId);
//     } else if (_selectedHotelIds.length < 2) {
//       _selectedHotelIds.add(hotelId);
//     }
//   }

//   bool isHotelSelected(String hotelId) {
//     return _selectedHotelIds.contains(hotelId);
//   }

//   Future<String> compareSelectedHotels() async {
//     try {
//       if (_selectedHotelIds.length != 2) {
//         return "Please select exactly 2 hotels to compare.";
//       }

//       final hotel1Doc =
//           await _firestore.collection('hotels').doc(_selectedHotelIds[0]).get();
//       final hotel2Doc =
//           await _firestore.collection('hotels').doc(_selectedHotelIds[1]).get();

//       if (!hotel1Doc.exists || !hotel2Doc.exists) {
//         return "One or both selected hotels could not be found.";
//       }

//       final hotel1 = hotel1Doc.data()!;
//       final hotel2 = hotel2Doc.data()!;

//       return """
// Here's the comparison between ${hotel1['name']} and ${hotel2['name']}:

// ${hotel1['name']}:
// - Price: \$${hotel1['price']}/night
// - Rating: ${hotel1['rating']}/5
// - Location: ${hotel1['location']}
// - Amenities: ${(hotel1['amenities'] as List).join(', ')}

// ${hotel2['name']}:
// - Price: \$${hotel2['price']}/night
// - Rating: ${hotel2['rating']}/5
// - Location: ${hotel2['location']}
// - Amenities: ${(hotel2['amenities'] as List).join(', ')}
// """;
//     } catch (e) {
//       return "Sorry, I couldn't fetch hotel data. Please try again later.";
//     }
//   }

//   void clearSelection() {
//     _selectedHotelIds.clear();
//   }

//   int get selectedCount => _selectedHotelIds.length;
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class HotelComparisonService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> _selectedHotelIds = [];

  Future<List<Map<String, dynamic>>> getAllHotels() async {
    try {
      final snapshot = await _firestore.collection('hotels').get();
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching hotels: $e');
      return [];
    }
  }

  void selectHotel(String hotelId) {
    if (_selectedHotelIds.contains(hotelId)) {
      _selectedHotelIds.remove(hotelId);
    } else if (_selectedHotelIds.length < 2) {
      _selectedHotelIds.add(hotelId);
    }
  }

  bool isHotelSelected(String hotelId) {
    return _selectedHotelIds.contains(hotelId);
  }

  Future<String> compareSelectedHotels() async {
    try {
      if (_selectedHotelIds.length != 2) {
        return "Please select exactly 2 hotels to compare.";
      }

      final hotel1Doc =
          await _firestore.collection('hotels').doc(_selectedHotelIds[0]).get();
      final hotel2Doc =
          await _firestore.collection('hotels').doc(_selectedHotelIds[1]).get();

      if (!hotel1Doc.exists || !hotel2Doc.exists) {
        return "One or both selected hotels could not be found.";
      }

      final hotel1 = hotel1Doc.data()!;
      final hotel2 = hotel2Doc.data()!;

      return """
Here's the comparison between ${hotel1['name']} and ${hotel2['name']}:

${hotel1['name']}:
- Price: ₹${hotel1['price']}/night
- Rating: ${hotel1['rating']}/5
- Location: ${hotel1['location']}
- Amenities: ${(hotel1['amenities'] as List).join(', ')}

${hotel2['name']}:
- Price: ₹${hotel2['price']}/night
- Rating: ${hotel2['rating']}/5
- Location: ${hotel2['location']}
- Amenities: ${(hotel2['amenities'] as List).join(', ')}
""";
    } catch (e) {
      return "Sorry, I couldn't fetch hotel data. Please try again later.";
    }
  }

  void clearSelection() {
    _selectedHotelIds.clear();
  }

  int get selectedCount => _selectedHotelIds.length;
}
