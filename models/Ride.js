const mongoose = require('mongoose');

const RideSchema = new mongoose.Schema({
    studentEmail: String,
    destination: {
        name: String,
        distance: String,
        eta: String
    },
    cartNumber: { type: String, default: "#4217" },
    status: { type: String, default: "on_route" },
    createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Ride', RideSchema);