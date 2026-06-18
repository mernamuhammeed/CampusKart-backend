const express = require('express');
const cors = require('cors');
const { MongoClient } = require('mongodb');

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json()); 

const url = 'mongodb://127.0.0.1:27017';
const client = new MongoClient(url);
const dbName = 'CampusKart';

async function startServer() {
    try {
        await client.connect();
        const db = client.db(dbName);
        const carts = db.collection('carts');
        const trips = db.collection('trips');

        console.log("--- Connected to MongoDB Compass ---");

        // ONLY ONE '/request-ride' block here
        app.post('/request-ride', async (req, res) => {
            console.log("📥 Incoming Request:", req.body);
            const { studentId, destination } = req.body;

            try {
                // 1. Find an available cart
                const availableCart = await carts.findOne({ status: "available" });

                if (!availableCart) {
                    console.log("❌ No carts available");
                    return res.status(404).json({ message: "No carts available right now" });
                }

                // 2. Create a Trip
                const newTrip = {
                    studentId,
                    destination,
                    cartId: availableCart.cartId,
                    status: "onWay",
                    timestamp: new Date()
                };

                await trips.insertOne(newTrip);

                // 3. Update Cart to 'busy'
                await carts.updateOne({ _id: availableCart._id }, { $set: { status: "busy" } });

                console.log("✅ Ride Booked Successfully!");
                res.status(200).json({ message: "Ride booked!", trip: newTrip });
            } catch (err) {
                console.error("Database Error:", err);
                res.status(500).json({ message: "Internal Server Error" });
            }
        });

        app.listen(port, '0.0.0.0', () => {
            console.log(`🚀 Server running at http://localhost:${port}`);
        });

    } catch (error) {
        console.error("Failed to start server:", error);
    }
}

startServer(); 