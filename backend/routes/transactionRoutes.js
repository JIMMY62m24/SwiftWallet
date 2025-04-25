const express = require('express');
const router = express.Router();
const transactionController = require('../controllers/transactionController');
const authMiddleware = require('../middleware/authMiddleware');

// Protect all routes
router.use(authMiddleware);

// Send money
router.post('/send', transactionController.sendMoney);

// Get transaction history
router.get('/history', transactionController.getTransactionHistory);

// Get transaction details
router.get('/:id', transactionController.getTransactionById);

module.exports = router; 