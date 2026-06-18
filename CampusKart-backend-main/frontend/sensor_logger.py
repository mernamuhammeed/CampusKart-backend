import time
import requests
import random
import math

URL = "http://localhost:3000/api/telemetry"
TARGET_URL = "http://localhost:3000/api/telemetry/target"

def simulate():
    speed = 15.0
    battery = 85.0
    lat = 29.431
    lng = 32.401
    soh = 96.4
    print(f"Starting telemetry simulator to {URL}...")
    
    iteration = 0
    current_distance_m = 0.0
    current_eta_min = 0.0
    
    while True:
        iteration += 1
        
        # Simulate gradual battery drain
        battery -= 0.05
        if battery < 20.0:
            battery = 100.0
            
        # 1. Fetch current target from server
        try:
            target_res = requests.get(TARGET_URL).json()
            target = target_res.get('target')
            ride_status = target_res.get('status')
            
            if target and ride_status not in ['idle', 'completed', 'arrived_at_pickup']:
                # Smoothed speed (constant 15 for stable ETA)
                speed = 15.0 
                
                target_lat = target['lat']
                target_lng = target['lon']
                
                lat_diff = target_lat - lat
                lng_diff = target_lng - lng
                dist_deg = math.sqrt(lat_diff**2 + lng_diff**2)
                
                # Speed in m/s (15 km/h = 4.16 m/s)
                speed_ms = speed * (1000.0 / 3600.0)
                # 2 seconds tick
                dist_meters_per_tick = speed_ms * 2.0
                dist_deg_per_tick = dist_meters_per_tick / 111000.0
                
                if dist_deg > dist_deg_per_tick:
                    lat += (lat_diff / dist_deg) * dist_deg_per_tick
                    lng += (lng_diff / dist_deg) * dist_deg_per_tick
                else:
                    lat = target_lat
                    lng = target_lng
                
                # Compute real distance in meters using Haversine
                p1 = lat * math.pi / 180
                p2 = target_lat * math.pi / 180
                dp = (target_lat - lat) * math.pi / 180
                dl = (target_lng - lng) * math.pi / 180
                a = math.sin(dp/2)**2 + math.cos(p1) * math.cos(p2) * math.sin(dl/2)**2
                c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a))
                current_distance_m = 6371e3 * c
                
                current_eta_min = current_distance_m / (speed * 1000.0 / 60.0)
            else:
                speed = 0.0
                current_distance_m = 0.0
                current_eta_min = 0.0
        except Exception as e:
            current_distance_m = 0.0
            current_eta_min = 0.0
            pass # Ignore connection errors
            
        voltage = 48.0 + random.uniform(-1.5, 1.5)
        current_a = (speed / 5.0) + random.uniform(2.0, 5.0)

        motor_status = 0 if (iteration % 40 == 0) else 1
        lights_status = 1
        aux_status = 1
        plc_status = 0 if (iteration % 50 == 0) else 1
        esp_status = 1
        rssi = random.randint(-85, -45)

        data = {
            "cart_id": "CK-001",
            "speed_kmh": round(speed, 2),
            "battery_pct": round(battery, 2),
            "lat": round(lat, 6),
            "lng": round(lng, 6),
            "heading": round(random.uniform(0, 360), 1),
            "lidar_dist": round(random.uniform(100, 500), 1),
            "voltage": round(voltage, 2),
            "current_a": round(current_a, 2),
            "motor_status": motor_status,
            "lights_status": lights_status,
            "aux_status": aux_status,
            "plc_status": plc_status,
            "esp_status": esp_status,
            "rssi": rssi,
            "uptime_pct": 99.8,
            "soh": soh,
            "distance_m": round(current_distance_m, 1),
            "eta_min": round(current_eta_min, 2)
        }
        
        try:
            res = requests.post(URL, json=data)
            print(f"[{res.status_code}] Sent telemetry. ETA: {current_eta_min:.2f} min, Dist: {current_distance_m:.1f} m")
        except Exception as e:
            print(f"Connection Error: {e}")
            
        time.sleep(2)

if __name__ == "__main__":
    simulate()
