import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> entrarUsuario(
      {required String email, required String senha}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      return erroAuth(e);
    }
    return null;
  }

  Future<UserCredential> singinWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<String?> cadastrarUsuario(
      {required String email,
      required String senha,
      required String nome}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: senha);
      User? newUser = userCredential.user;
      await newUser?.updateDisplayName(nome);
      await newUser?.reload();
    } on FirebaseAuthException catch (e) {
      return erroAuth(e);
    }
    return null;
  }

  Future<String?> redefinicaoSenha({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      return erroAuth(e);
    }
    return null;
  }

  Future<String?> deslogar() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return null;
  }

  Future<String?> erroAuth(FirebaseAuthException e) async {
    switch (e.code) {
      case 'user-not-found':
        return 'Usuário não encontrado';
      case 'wrong-password':
        return 'Senha incorreta';
      case 'invalid-email':
        return 'Email Inválido.';
      case 'email-already-in-use':
        return 'O email já está em uso.';
      case 'invalid-credential':
        return 'Credenciais inválidas.';
      case 'weak-password':
        return 'Senha fraca';
      default:
        return 'Erro, tente novamente.';
    }
  }

  Future<String?> excluirConta({required String? senha}) async {
    try {
      if (senha != null) {
        await _firebaseAuth.signInWithEmailAndPassword(
            email: _firebaseAuth.currentUser!.email!, password: senha);
      } else {
        await singinWithGoogle();
      }
      await _firebaseAuth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      return erroAuth(e);
    }

    return null;
  }

  Future<String?> alterarSenha(
      {required String senhaAtual, required String novaSenha}) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: _firebaseAuth.currentUser!.email!,
        password: senhaAtual,
      );
      await _firebaseAuth.currentUser!.reauthenticateWithCredential(credential);
      await _firebaseAuth.currentUser!.updatePassword(novaSenha);
    } on FirebaseAuthException catch (e) {
      return erroAuth(e);
    }
    return null;
  }
}
