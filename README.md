# CampusKart

A full-stack, comprehensive platform for autonomous golf cart fleet management, live telemetry tracking, and user ride-hailing on campus.

## Overview
CampusKart is an end-to-end solution designed to handle autonomous vehicle operations on a mapped campus. It bridges a user-facing mobile web app (where students/staff can book rides) with a powerful Admin Control Panel that monitors vehicle health, real-time metrics, and allows for manual override capabilities for the On-Board Computers (OBC).

## Architecture & Tech Stack
- **Frontend (UI / UX):** Flutter Web (Dart) providing a seamless, native-like experience across desktop and mobile.
- **Backend (API):** Node.js and Express.js REST API handling rides, user auth, and control signals.
- **Database (Primary State):** MongoDB Atlas (Mongoose) storing User profiles, Ride history, and manual override telemetry constraints.
- **Time-Series Database (Telemetry):** InfluxDB collecting and parsing high-frequency sensor telemetry (speed, voltage, ultrasonic, lidar).
- **Mapping & Pathfinding:** `flutter_map` with Leaflet integrations, using a custom-built Dijkstra/A* pathfinding algorithm over campus nodes.

## Core Features
### 1. User Ride-Hailing
- **Interactive Map:** Users can visually select pick-up and drop-off stations around the campus.
- **A* Pathfinding:** Calculates the shortest traversable route and visualizes it instantly with polyline overlays.
- **Ride Lifecycle:** End-to-end ride tracking (Pending, Confirmed, En Route, Completed).

### 2. Admin Control Panel (Fleet Operations)
- **Live Fleet Tracking:** Monitor the physical GPS locations of all autonomous carts moving on the campus map in real-time.
- **OBC Diagnostic Matrix:** Displays live, color-coded health statuses (Green/Red) for all onboard components:
  - PLCs and ESP32 chips
  - Ultrasonic Sensors (Left, Right, Rear)
  - LiDAR, IMU, GPS, and Optical Encoders
  - Power Rails (24V, 5V, ACS-712 Current Sensors)
- **Network Reliability:** Real-time metrics tracking the connection strength (RSSI) and uptime of the IoT telemetry links.
- **Power Draw Leaderboard:** Tracks live battery State of Charge (SoC) and power consumption wattage.

### 3. Manual Override System (Teleoperation)
- **Drive-by-Wire Commands:** Remote override capabilities over the autonomous system.
- **Precision Steering:** 1.0° increment manual steering adjustments for fine-tuned maneuvering.
- **Throttle & Braking:** Digital throttle sliding and emergency stop (E-STOP) functionality directly linked to MongoDB collections.

## Project Structure
- `frontend/` - Contains the Flutter application, encompassing all UI screens, API services, map implementations, and pathfinding algorithms.
- `server.js` - The main Express application acting as the middleware bridging MongoDB, InfluxDB, and the Flutter frontend.
- `models/` - Mongoose schemas (`User`, `Ride`, `CartTelemetry`, `Feedback`) defining data structures.
- `public/` - The compiled Flutter Web release bundle served statically by the Node server.

## Getting Started
### Prerequisites
- Node.js & npm
- Flutter SDK (Web configured)
- MongoDB Connection String
- InfluxDB URL & Token

### Installation
1. Install Node dependencies: `npm install`
2. Configure `.env` with your DB URIs:
   ```env
   MONGO_URI=your_mongodb_connection_string
   INFLUX_URL=your_influx_db_url
   INFLUX_TOKEN=your_influx_token
   INFLUX_ORG=your_org
   INFLUX_BUCKET=your_bucket
   PORT=3000
   ```
3. Build the Flutter web app:
   ```bash
   cd frontend
   flutter build web --release
   cd ..
   # Copy contents of frontend/build/web into public/
   ```
4. Start the backend: `node server.js`
5. Open `http://localhost:3000` to access the application.

## Recent Committee Presentation Updates
- Limited accessible ride stations strictly to the **Test Track Loop** via map configuration constraints.
- Integrated exact steering angles and `manual_steering` properties into the Mongoose models to allow for precise turning radius demonstrations.
- Purged dummy simulation data for a strict "Single Fleet" approach targeting real-time `CART-01` telemetry.
- Dynamic red/green sensor status indication based on active InfluxDB payloads.
