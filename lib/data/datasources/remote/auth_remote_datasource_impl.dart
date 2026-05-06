import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/common/result.dart';
import '../../models/user_model.dart';
import '../interfaces/auth_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  @override
  Future<Result<UserModel>> signInWithGoogle() async {
    try {
      // 1. PENGGUNAAN VERSI 7.2.0: Menggunakan .authenticate() (bukan .signIn() lagi)
      final googleSignInAccount = await googleSignIn.authenticate();

      // 2. Wajib cek null karena user bisa saja membatalkan pop-up Google
      if (googleSignInAccount == null) {
        return Result.failure(
          error: Exception('Login Google dibatalkan oleh pengguna'),
          stackTrace: StackTrace.current,
        );
      }

      // 3. Ambil proses autentikasi (mendapatkan token)
      final googleAuth = await googleSignInAccount.authentication;

      // 4. Buat credential Firebase
      // PENTING: Di versi 7+, parameter accessToken otomatis dihapus.
      // Kita hanya perlu memberikan idToken karena ini saja sudah cukup untuk Firebase.
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // 5. Login ke Firebase menggunakan credential Google
      final userCredential = await firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        return Result.failure(
          error: Exception('Gagal masuk ke Firebase'),
          stackTrace: StackTrace.current,
        );
      }

      return Result.success(
        data: UserModel(
          id: user.uid,
          name: user.displayName,
          email: user.email,
          imageUrl: user.photoURL,
          authProvider: 'google',
        ),
      );
    } catch (e, s) {
      return Result.failure(error: e, stackTrace: s);
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await Future.wait([
        firebaseAuth.signOut(),
        googleSignIn.signOut(),
      ]);
      return Result.success(data: null);
    } catch (e, s) {
      return Result.failure(error: e, stackTrace: s);
    }
  }

  @override
  Future<Result<UserModel?>> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;

      if (user == null) {
        return Result.success(data: null);
      }

      return Result.success(
        data: UserModel(
          id: user.uid,
          name: user.displayName,
          email: user.email,
          imageUrl: user.photoURL,
          authProvider: 'google',
        ),
      );
    } catch (e, s) {
      return Result.failure(error: e, stackTrace: s);
    }
  }
}