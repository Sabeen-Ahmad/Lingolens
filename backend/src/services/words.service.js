const { getFirestore } = require('../config/firebase');

const COLLECTION = 'words';

/**
 * Fetch all vocabulary words, ordered by creation time (newest first).
 * @returns {Promise<Array>}
 */
async function getAllWords() {
  const db = getFirestore();
  const snapshot = await db
    .collection(COLLECTION)
    .orderBy('createdAt', 'desc')
    .get();

  return snapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
  }));
}

/**
 * Save a new vocabulary word to Firestore.
 * @param {{ word: string, meaning: string, translation: string }} payload
 * @returns {Promise<Object>} The saved word including its generated id
 */
async function createWord({ word, meaning, translation }) {
  const db = getFirestore();
  const docRef = await db.collection(COLLECTION).add({
    word: word.trim(),
    meaning: meaning.trim(),
    translation: translation.trim(),
    createdAt: new Date().toISOString(),
  });

  const doc = await docRef.get();
  return { id: doc.id, ...doc.data() };
}

module.exports = { getAllWords, createWord };
