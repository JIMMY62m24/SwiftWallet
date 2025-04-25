const express = require('express');
const router = express.Router();
const transferController = require('../controllers/transferController');
const authMiddleware = require('../middleware/authMiddleware');

// All routes require authentication
router.use(authMiddleware);

// Send money to another user
router.post('/send', transferController.sendMoney);

// Get transaction history
router.get('/history', transferController.getTransactionHistory);

module.exports = router; 