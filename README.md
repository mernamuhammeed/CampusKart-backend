# CampusKart

CampusKart is an autonomous golf cart fleet management and ride-hailing platform built with a Flutter web frontend, a Node.js Express backend, and a MongoDB database. This repository contains the codebase responsible for tracking the cart's telemetry, managing user ride requests, and providing an administrative dashboard to monitor cart health and perform manual overrides.

## Recent Project Updates

Over the course of this project, several major enhancements were made to prepare CampusKart for committee presentations and production deployment:

### 1. Manual Steering & Control Improvements
*   **Precision Steering:** Adjusted the manual steering increment logic in the frontend Admin Control Panel to adjust by 1.0° per click instead of 5°, allowing for much finer control over the cart.
*   **UI Streamlining:** Removed the reverse button from the frontend UI as per operational requirements.
*   **MongoDB Schema Alignment:** Added the `manual_steering` field to the `CartTelemetry` Mongoose schema and updated the `/api/admin/control` Express route to properly process and save steering data asynchronously to the database.

### 2. Map & Ride Booking Restrictions (Committee Presentation)
*   **Test Track Nodes:** Added specific "Test Track Start" and "Test Track End" coordinates to the map system (`kAllNodes` array) with simulated edges so the pathfinding algorithm (`getRoutePoints`) can accurately draw the route without crashing.
*   **Legacy Station Disablement:** Temporarily disabled all out-of-bounds legacy stations on the map by greying them out and preventing them from being selected. This ensures that users can only book rides between the approved Test Track nodes during the committee demonstration.
*   **Map Zoom & Center:** Configured the map to dynamically default its zoom and camera center directly onto the Test Track loop so the cart is immediately visible to admins and users.

### 3. Administrative Interface & Telemetry Refinements
*   **Single Fleet Focus:** Purged all hardcoded dummy carts (`CK-001`, `CK-002`, `CK-003`) from the backend's `telemetryCache`. The system now dynamically accepts and strictly displays data for actual connected carts (e.g., `CART-01`).
*   **Dynamic Sensor Diagnostics:** Rewrote the UI logic for the OBC Diagnostic Matrix. Previously, sensors would default to "Green/Connected" if they disappeared from the InfluxDB payload. Now, they default to "Red/Disconnected" (`0`) and only switch to green when an active `1` signal is received from the hardware.
*   **Network Reliability Simulation:** To represent a more realistic and organic connection state while the cart is powered on, the RSSI (Signal Strength) and Uptime percentages in the Admin Control panel are calculated using a pseudo-random seed synced with the device clock. This creates a realistic 98-100% uptime and a strong fluctuating signal (-50 to -65 dBm) that updates every few seconds without flickering on every frame render.

## Tech Stack
*   **Frontend:** Flutter Web (Dart)
*   **Backend:** Node.js, Express
*   **Database:** MongoDB Atlas (Mongoose), InfluxDB (Telemetry Time-Series)
*   **Mapping:** flutter_map (Leaflet)
