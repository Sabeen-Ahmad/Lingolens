const wordsService = require('../services/words.service');

/**
 * GET /words
 * Returns all saved vocabulary words.
 */
async function getWords(req, res, next) {
  try {
    const words = await wordsService.getAllWords();
    res.json({
      success: true,
      count: words.length,
      data: words,
    });
  } catch (err) {
    next(err);
  }
}

/**
 * POST /words
 * Saves a new vocabulary word.
 * Body: { word, meaning, translation }
 */
async function postWord(req, res, next) {
  try {
    const { word, meaning, translation } = req.body;

    // Validate required fields
    if (!word?.trim() || !meaning?.trim() || !translation?.trim()) {
      return res.status(400).json({
        success: false,
        message: 'word, meaning, and translation are all required.',
      });
    }

    const saved = await wordsService.createWord({ word, meaning, translation });
    res.status(201).json({ success: true, data: saved });
  } catch (err) {
    next(err);
  }
}

module.exports = { getWords, postWord };
