from pymongo import MongoClient
from datetime import datetime
import pytz  # for timezone-aware timestamps

# MongoDB setup (change this if using remote host)
client = MongoClient("mongodb://localhost:27017/")
audit_logs = client["audit_log"]["logs"]

# ----------------------
# Add a new audit log
# ----------------------
def add_audit_log():
    app_id = input("Enter App ID: ").strip()
    data_type = input("Data type accessed (vitals, medications, etc): ").strip()
    status = input("Access status (success/fail): ").strip().lower()

    log = {
        "timestamp": datetime.now(pytz.UTC).isoformat(),
        "app_id": app_id,
        "data_type": data_type,
        "status": status
    }

    audit_logs.insert_one(log)
    print("✅ Audit log added!")

# ----------------------
# View all logs
# ----------------------
def view_all_logs():
    print("\n📋 All Audit Logs:")
    for log in audit_logs.find().sort("timestamp", -1):
        print(f"🕒 {log['timestamp']} | App ID: {log['app_id']} | Data: {log['data_type']} | Status: {log['status']}")

# ----------------------
# Filter logs by App ID
# ----------------------
def filter_by_app_id():
    app_id = input("Enter App ID to filter by: ").strip()
    logs = audit_logs.find({"app_id": app_id}).sort("timestamp", -1)

    print(f"\n🔍 Logs for App ID: {app_id}")
    for log in logs:
        print(f"{log['timestamp']} | {log['data_type']} | {log['status']}")

# ----------------------
# Filter logs by Data Type
# ----------------------
def filter_by_data_type():
    data_type = input("Enter data type to filter (e.g., vitals): ").strip()
    logs = audit_logs.find({"data_type": data_type}).sort("timestamp", -1)

    print(f"\n🔍 Logs for Data Type: {data_type}")
    for log in logs:
        print(f"{log['timestamp']} | App ID: {log['app_id']} | Status: {log['status']}")

# ----------------------
# Console menu
# ----------------------
def menu():
    while True:
        print("\n EHR Audit Log Menu")
        print("1. Add Audit Log")
        print("2. View All Logs")
        print("3. Filter by App ID")
        print("4. Filter by Data Type")
        print("5. Quit")

        choice = input("Choose an option: ")

        if choice == "1":
            add_audit_log()
        elif choice == "2":
            view_all_logs()
        elif choice == "3":
            filter_by_app_id()
        elif choice == "4":
            filter_by_data_type()
        elif choice == "5":
            print("👋 Exiting.")
            break
        else:
            print("❌ Invalid option. Try again.")

if __name__ == "__main__":
    menu()