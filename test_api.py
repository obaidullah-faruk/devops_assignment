import requests
import time
import sys

BASE_URL = "http://localhost:8000"
HEROES_URL = f"{BASE_URL}/heroes/"

def run_tests():
    print("--- Starting API Tests ---\n")

    # 1. Create a hero
    print("1. Creating a new hero...")
    hero_data = {
        "name": "Deadpool",
        "age": 35,
        "secret_name": "Wade Wilson"
    }
    
    try:
        response = requests.post(HEROES_URL, json=hero_data)
    except requests.exceptions.ConnectionError:
        print(f"❌ Failed to connect to {BASE_URL}. Is the server running?")
        sys.exit(1)

    if response.status_code == 200:
        created_hero = response.json()
        print(f"✅ Success! Created hero: {created_hero}")
        hero_id = created_hero.get("id")
    else:
        print(f"❌ Failed to create hero. Status: {response.status_code}, Response: {response.text}")
        return

    print("\n--------------------------\n")
    time.sleep(0.5)

    # 2. Get the specific hero
    print(f"2. Getting hero with ID {hero_id}...")
    response = requests.get(f"{HEROES_URL}{hero_id}")
    if response.status_code == 200:
        print(f"✅ Success! Retrieved hero: {response.json()}")
    else:
        print(f"❌ Failed to get hero. Status: {response.status_code}, Response: {response.text}")

    print("\n--------------------------\n")
    time.sleep(0.5)

    # 3. List all heroes
    print("3. Listing all heroes...")
    response = requests.get(HEROES_URL)
    if response.status_code == 200:
        heroes = response.json()
        print(f"✅ Success! Retrieved {len(heroes)} heroes.")
        print(f"Heroes list: {heroes}")
    else:
        print(f"❌ Failed to list heroes. Status: {response.status_code}, Response: {response.text}")

    print("\n--------------------------\n")
    time.sleep(0.5)

    # 4. Delete the hero
    print(f"4. Deleting hero with ID {hero_id}...")
    response = requests.delete(f"{HEROES_URL}{hero_id}")
    if response.status_code == 200:
        print(f"✅ Success! Deleted hero. Response: {response.json()}")
    else:
        print(f"❌ Failed to delete hero. Status: {response.status_code}, Response: {response.text}")

    print("\n--- API Tests Completed ---")

if __name__ == "__main__":
    run_tests()
