const express = require('express');
const { getWords, postWord } = require('../controllers/words.controller');

const router = express.Router();

// GET /words  – retrieve all words
router.get('/', getWords);

// POST /words – save a new word (used internally by Flutter via Firestore SDK,
//               but exposed here so the GET endpoint has data to return)
router.post('/', postWord);

module.exports = router;
