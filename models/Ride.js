const mongoose = require('mongoose');

const RideSchema = new mongoose.Schema({
    studentEmail: String,
    cartNumber: { type: String, default: "#4217" },
    status: { type: String, default: "on_route" }, // e.g., "requested", "on_route", "completed", "cancelled"
    
    // Spatial Data for Station Analytics
    origin: {
        name: String, // Pickup station
        coordinates: [Number] // Optional: [lng, lat] for Heatmap
    },
    destination: {
        name: String, // Drop-off station
        distance: String,
        eta: String,
        coordinates: [Number]
    },

    // Time Tracking for MTBR & Rush Hours
    requestTime: { type: Date, default: Date.now }, // When the user requested
    pickupTime: { type: Date }, // When the ride actually started
    completionTime: { type: Date }, // When the ride ended

    // NEW: Feedback Feature
    rating: { type: Number, min: 1, max: 5 },
    feedback: { type: String, trim: true, maxLength: 500 },

    createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Ride', RideSchema);