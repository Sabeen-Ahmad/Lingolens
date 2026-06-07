const admin = require('firebase-admin');

// If FIREBASE_SERVICE_ACCOUNT_JSON env var is set, use it (production).
// Otherwise fall back to the local serviceAccountKey.json file.
let firebaseApp;

function initFirebase() {
  if (firebaseApp) return firebaseApp;

  let credential;

  if (process.env.FIREBASE_SERVICE_ACCOUNT_JSON) {
    const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT_JSON);
    credential = admin.credential.cert(serviceAccount);
  } else {
    // Local development: place your serviceAccountKey.json in backend/
    try {
      const serviceAccount = require('../../serviceAccountKey.json');
      credential = admin.credential.cert(serviceAccount);
    } catch (e) {
      throw new Error(
        'Firebase credentials not found. Set FIREBASE_SERVICE_ACCOUNT_JSON env var ' +
        'or place serviceAccountKey.json in the backend/ folder.'
      );
    }
  }

  firebaseApp = admin.initializeApp({ credential });
  return firebaseApp;
}

function getFirestore() {
  initFirebase();
  return admin.firestore();
}

module.exports = { getFirestore };
