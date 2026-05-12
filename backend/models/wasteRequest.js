module.exports = (sequelize, DataTypes) => {
  const WasteRequest = sequelize.define('WasteRequest', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    status: {
      type: DataTypes.ENUM('pending','assigned','on_the_way','arrived','completed'),
      defaultValue: 'pending'
    },
    collectorId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },
    latitude: {
      type: DataTypes.DECIMAL(10,7),
      allowNull: false,
    },
    longitude: {
      type: DataTypes.DECIMAL(10,7),
      allowNull: false,
    },
    userId: {
      type: DataTypes.INTEGER,
      allowNull: false,
    }
  }, {
    tableName: 'waste_requests'
  });

  return WasteRequest;
};
