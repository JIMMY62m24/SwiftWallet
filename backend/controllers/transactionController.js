const { Transaction, User, sequelize } = require('../models');
const { Op } = require('sequelize');

// Fee percentage (1%)
const FEE_PERCENTAGE = 0.01;

exports.sendMoney = async (req, res) => {
  const { recipientPhoneNumber, amount } = req.body;
  const senderId = req.user.id;

  const transaction = await sequelize.transaction();

  try {
    // Find recipient
    const recipient = await User.findOne({
      where: { phoneNumber: recipientPhoneNumber }
    });

    if (!recipient) {
      await transaction.rollback();
      return res.status(404).json({
        success: false,
        message: 'Recipient not found'
      });
    }

    // Check if sender has sufficient balance
    const sender = await User.findByPk(senderId);
    if (sender.balance < amount) {
      await transaction.rollback();
      return res.status(400).json({
        success: false,
        message: `Insufficient balance. Your balance is ${sender.balance} XOF`
      });
    }

    // Calculate fee and receive amount
    const fee = amount * FEE_PERCENTAGE;
    const receiveAmount = amount - fee;

    // Create transaction record
    const newTransaction = await Transaction.create({
      senderId,
      recipientId: recipient.id,
      amount,
      fee,
      receiveAmount,
      type: 'TRANSFER',
      status: 'PENDING'
    }, { transaction });

    // Update sender's balance
    await sender.update({
      balance: sequelize.literal(`balance - ${amount}`)
    }, { transaction });

    // Update recipient's balance
    await recipient.update({
      balance: sequelize.literal(`balance + ${receiveAmount}`)
    }, { transaction });

    // Update transaction status
    await newTransaction.update({
      status: 'SUCCESS'
    }, { transaction });

    await transaction.commit();

    res.status(200).json({
      success: true,
      message: 'Money sent successfully',
      transaction: {
        id: newTransaction.id,
        amount,
        fee,
        receiveAmount,
        recipient: {
          name: recipient.name,
          phoneNumber: recipient.phoneNumber
        }
      }
    });

  } catch (error) {
    await transaction.rollback();
    console.error('Transfer error:', error);
    res.status(500).json({
      success: false,
      message: 'Error processing transfer'
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
      order: [['createdAt', 'DESC']],
      limit: 50
    });

    res.status(200).json({
      success: true,
      transactions
    });

  } catch (error) {
    console.error('Error fetching transactions:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching transaction history'
    });
  }
};

exports.getTransactionById = async (req, res) => {
  const { id } = req.params;
  const userId = req.user.id;

  try {
    const transaction = await Transaction.findOne({
      where: {
        id,
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
      ]
    });

    if (!transaction) {
      return res.status(404).json({
        success: false,
        message: 'Transaction not found'
      });
    }

    res.status(200).json({
      success: true,
      transaction
    });

  } catch (error) {
    console.error('Error fetching transaction:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching transaction details'
    });
  }
}; 