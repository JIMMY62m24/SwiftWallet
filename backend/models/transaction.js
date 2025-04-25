const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class Transaction extends Model {
    static associate(models) {
      // Define associations here
      Transaction.belongsTo(models.User, {
        as: 'sender',
        foreignKey: 'senderId'
      });
      Transaction.belongsTo(models.User, {
        as: 'recipient',
        foreignKey: 'recipientId'
      });
    }
  }

  Transaction.init({
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true
    },
    senderId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'Users',
        key: 'id'
      }
    },
    recipientId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'Users',
        key: 'id'
      }
    },
    amount: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
      validate: {
        min: 0.01
      }
    },
    type: {
      type: DataTypes.ENUM('TRANSFER', 'QR_PAYMENT'),
      allowNull: false,
      defaultValue: 'TRANSFER'
    },
    status: {
      type: DataTypes.ENUM('PENDING', 'SUCCESS', 'FAILED'),
      allowNull: false,
      defaultValue: 'PENDING'
    },
    description: {
      type: DataTypes.STRING,
      allowNull: true
    }
  }, {
    sequelize,
    modelName: 'Transaction',
    timestamps: true // This will add createdAt and updatedAt fields
  });

  return Transaction;
}; 