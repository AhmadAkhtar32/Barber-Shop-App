// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      // Create user account
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update display name
      await userCredential.user!.updateDisplayName(name);

      // Save additional user info to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': DateTime.now(),
        'lastLogin': DateTime.now(),
      });

      return null; // Success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'email-already-in-use':
          return 'The account already exists for that email.';
        case 'invalid-email':
          return 'The email address is not valid.';
        default:
          return e.message ?? 'An error occurred during sign up.';
      }
    } catch (e) {
      return 'An unexpected error occurred.';
    }
  }

  // Sign in with email and password
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update last login time
      await _firestore.collection('users').doc(userCredential.user!.uid).update(
        {'lastLogin': DateTime.now()},
      );

      return null; // Success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found for that email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        default:
          return e.message ?? 'An error occurred during sign in.';
      }
    } catch (e) {
      return 'An unexpected error occurred.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset password
  Future<String?> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found for that email.';
        case 'invalid-email':
          return 'The email address is not valid.';
        default:
          return e.message ?? 'An error occurred.';
      }
    } catch (e) {
      return 'An unexpected error occurred.';
    }
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      if (_auth.currentUser != null) {
        DocumentSnapshot doc =
            await _firestore
                .collection('users')
                .doc(_auth.currentUser!.uid)
                .get();
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Save booking to Firestore
  Future<String?> saveBooking({
    required String styleId,
    required String styleName,
    required double price,
    required String duration,
    required String description,
  }) async {
    try {
      if (_auth.currentUser == null) {
        return 'User not authenticated.';
      }

      // Generate booking ID
      String bookingId = _firestore.collection('bookings').doc().id;

      // Create booking data
      Map<String, dynamic> bookingData = {
        'bookingId': bookingId,
        'userId': _auth.currentUser!.uid,
        'styleId': styleId,
        'styleName': styleName,
        'price': price,
        'duration': duration,
        'description': description,
        'status': 'pending', // pending, confirmed, cancelled, completed
        'createdAt': DateTime.now(),
        'bookingDate': null, // This can be set later when user selects a specific date/time
        'barberName': null, // This can be assigned later
      };

      // Save to bookings collection
      await _firestore.collection('bookings').doc(bookingId).set(bookingData);

      // Also save to user's bookings subcollection for easy querying
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('bookings')
          .doc(bookingId)
          .set(bookingData);

      return null; // Success
    } on FirebaseException catch (e) {
      return e.message ?? 'Failed to save booking.';
    } catch (e) {
      return 'An unexpected error occurred while saving booking.';
    }
  }

  // Get user's bookings
  Future<List<Map<String, dynamic>>> getUserBookings() async {
    try {
      if (_auth.currentUser == null) {
        return [];
      }

      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('bookings')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Update booking status
  Future<String?> updateBookingStatus({
    required String bookingId,
    required String status,
  }) async {
    try {
      if (_auth.currentUser == null) {
        return 'User not authenticated.';
      }

      // Update in main bookings collection
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': status,
        'updatedAt': DateTime.now(),
      });

      // Update in user's bookings subcollection
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('bookings')
          .doc(bookingId)
          .update({
        'status': status,
        'updatedAt': DateTime.now(),
      });

      return null; // Success
    } on FirebaseException catch (e) {
      return e.message ?? 'Failed to update booking status.';
    } catch (e) {
      return 'An unexpected error occurred while updating booking.';
    }
  }

  // Cancel booking
  Future<String?> cancelBooking({required String bookingId}) async {
    return await updateBookingStatus(bookingId: bookingId, status: 'cancelled');
  }

  // Get booking by ID
  Future<Map<String, dynamic>?> getBookingById(String bookingId) async {
    try {
      if (_auth.currentUser == null) {
        return null;
      }

      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('bookings')
          .doc(bookingId)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Stream user's bookings (for real-time updates)
  Stream<List<Map<String, dynamic>>> getUserBookingsStream() {
    if (_auth.currentUser == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }
}