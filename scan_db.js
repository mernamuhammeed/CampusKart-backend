const mongoose = require('mongoose');

async function scan() {
    try {
        await mongoose.connect('mongodb+srv://GolfCarAdmin:pass1234@golfcar.i9jx33e.mongodb.net/');
        console.log('Connected.');
        const db = mongoose.connection.db;
        const collections = await db.listCollections().toArray();
        console.log('Collections:', collections.map(c => c.name));

        for (const c of collections) {
            console.log(`\n--- Collection: ${c.name} ---`);
            const docs = await db.collection(c.name).find().limit(2).toArray();
            console.log(JSON.stringify(docs, null, 2));
        }
        process.exit(0);
    } catch (err) {
        console.error(err);
        process.exit(1);
    }
}
scan();
