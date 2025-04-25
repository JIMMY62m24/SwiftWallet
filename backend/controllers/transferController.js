const { User, Transaction } = require('../models');
const { Op } = require('sequelize');

exports.sendMoney = async (req, res) => {
  const { recipientPhoneNumber, amount, description } = req.body;
  const senderId = req.user.id; // From auth middleware

  try {
    // Find recipient by phone number
    const recipient = await User.findOne({
      where: { phoneNumber: recipientPhoneNumber }
    });

    if (!recipient) {
      return res.status(404).json({
        success: false,
        message: 'Recipient not found'
      });
    }

    // Check if sender has sufficient balance
    const sender = await User.findByPk(senderId);
    if (sender.balance < amount) {
      return res.status(400).json({
        success: false,
        message: 'Insufficient balance'
      });
    }

    // Start transaction
    const transaction = await sequelize.transaction();

    try {
      // Create transaction record
      const newTransaction = await Transaction.create({
        senderId,
        recipientId: recipient.id,
        amount,
        type: 'TRANSFER',
        status: 'PENDING',
        description
      }, { transaction });

      // Update sender's balance
      await sender.update({
        balance: sender.balance - amount
      }, { transaction });

      // Update recipient's balance
      await recipient.update({
        balance: recipient.balance + amount
      }, { transaction });

      // Update transaction status to success
      await newTransaction.update({
        status: 'SUCCESS'
      }, { transaction });

      await transaction.commit();

      res.status(200).json({
        success: true,
        message: 'Money sent successfully',
        transaction: newTransaction
      });

    } catch (error) {
      await transaction.rollback();
      throw error;
    }

  } catch (error) {
    console.error('Transfer error:', error);
    res.status(500).json({
      success: false,
      message: 'Error processing transfer',
      error: error.message
    });
  }
};

exports.getTransactionHistory = async (req, res) => {
  const userId = req.user.id;

  try {
    const transactions = await Transaction.findAll({
      where: {
        [Op.or]: [
          { senderId: userId },
          { recipientId: userId }
        ]
      },
      include: [
        {
          model: User,
          as: 'sender',
          attributes: ['id', 'name', 'phoneNumber']
        },
        {
          model: User,
          as: 'recipient',
          attributes: ['id', 'name', 'phoneNumber']
        }
      ],
      order: [['createdAt', 'DESC']]
    });

    res.status(200).json({
      success: true,
      transactions
    });

  } catch (error) {
    console.error('Error fetching transactions:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching transaction history',
      error: error.message
    });
  }
}; 