const mongoose = require('mongoose');

const cartTelemetrySchema = new mongoose.Schema({
    cart_id: { type: String, required: true, unique: true },
    current_node: { type: Number, default: 0 },
    path_cursor: { type: Number, default: 0 },
    active_path: { type: [Number], default: [] },
    active_ride_id: { type: String, default: null },
    on_board_count: { type: Number, default: 0 },
    is_moving: { type: Boolean, default: false },
    updated_at: { type: Date, default: Date.now },
    admin_control: {
        estop: { type: Boolean, default: false },
        mode: { type: String, enum: ['auto', 'manual'], default: 'auto' },
        manual_command: { type: String, enum: ['stop', 'forward', 'reverse', 'brake'], default: 'stop' },
        manual_throttle: { type: Number, min: 0, max: 100, default: 0 },
        manual_steering: { type: Number, min: -25.7, max: 25.7, default: 0 },
        updated_at: { type: Date, default: Date.now }
    }
});

module.exports = mongoose.model('CartTelemetry', cartTelemetrySchema);
