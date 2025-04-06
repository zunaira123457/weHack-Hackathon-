from pymongo import MongoClient

# Connect to MongoDB
client = MongoClient("mongodb://localhost:27017/")  # Use your Atlas link if on cloud
db = client["ehr_database"]
patients = db["patients"]
app_permissions = db["app_permissions"]

def add_patient():
    print("\n--- Add New Patient ---")
    patient_id = input("Patient ID: ")
    patient_name = input("Patient Name: ")
    dob = input("Date of Birth (YYYY-MM-DD): ")

    # Get Vitals
    heart_rate = input("Heart Rate: ")
    blood_pressure = input("Blood Pressure (e.g., 120/80): ")

    # Get Medications
    medications = input("Medications (comma-separated): ")

    # Get Diagnoses
    diagnoses = input("Diagnoses (comma-separated): ")

    # Get Bill Information
    bill_id = input("Bill ID: ")
    amount_due = float(input("Amount Due: "))
    status = input("Bill Status (e.g., Unpaid, Paid): ")
    payment_due = input("Payment Due Date (YYYY-MM-DD): ")

    # Get Insurance Info
    company_name = input("Insurance Company Name: ")
    member_name = input("Insurance Member Name: ")
    member_id = input("Insurance Member ID: ")
    group_number = input("Insurance Group Number: ")
    plan = input("Insurance Plan (e.g., PPO, HMO): ")

    # Get Copayments
    office_visit = float(input("Office Visit Copayment: "))
    prescription = float(input("Prescription Copayment: "))
    emergency_room = float(input("Emergency Room Copayment: "))
    out_of_pocket_max = float(input("Out-of-Pocket Max: "))

    # Get Lab Results
    lab_results = []
    more_results = "yes"
    while more_results.lower() == "yes":
        lab_test_name = input("Lab Test Name: ")
        result = input("Lab Test Result: ")
        date = input("Lab Test Date (YYYY-MM-DD): ")
        lab_results.append({
            "lab_test_name": lab_test_name,
            "result": result,
            "date": date
        })
        more_results = input("Add another lab result? (yes/no): ")

    # Construct the patient record with the new format
    record = {
        "patient_id": patient_id,
        "patient_name": patient_name,
        "dob": dob,
        "vitals": {
            "heart_rate": int(heart_rate),
            "blood_pressure": blood_pressure
        },
        "medications": [med.strip() for med in medications.split(',')],
        "diagnoses": [diag.strip() for diag in diagnoses.split(',')],
        "bill": {
            "bill_id": bill_id,
            "amount_due": amount_due,
            "status": status,
            "payment_due": payment_due,
            "insurance": {
                "company_name": company_name,
                "member_name": member_name,
                "member_id": member_id,
                "group_number": group_number,
                "plan": plan
            },
            "copayments": {
                "office_visit": office_visit,
                "prescription": prescription,
                "emergency_room": emergency_room,
                "out_of_pocket_max": out_of_pocket_max
            }
        },
        "lab_results": lab_results
    }

    patients.insert_one(record)
    print("✅ Patient record added!")

def view_all():
    print("\n--- All Patient Records ---")
    for p in patients.find():
        print(f"Patient ID: {p['patient_id']} | Name: {p['patient_name']} | DOB: {p['dob']}")
        print(f"Vitals: Heart Rate - {p['vitals']['heart_rate']}, Blood Pressure - {p['vitals']['blood_pressure']}")
        print(f"Medications: {', '.join(p['medications'])}")
        print(f"Diagnoses: {', '.join(p['diagnoses'])}")
        print(f"Bill: ID - {p['bill']['bill_id']}, Amount Due - ${p['bill']['amount_due']}, Status - {p['bill']['status']}")
        print(f"Payment Due: {p['bill']['payment_due']}")
        print("Insurance: ", p['bill']['insurance'])
        print("Copayments: ", p['bill']['copayments'])
        print(f"Lab Results: ")
        for lab in p['lab_results']:
            print(f"  {lab['lab_test_name']} | Result: {lab['result']} | Date: {lab['date']}")
        print("-" * 40)

def view_app_permissions():
    print("\n--- All App Permissions ---")
    for perm in app_permissions.find():
        print(f"App ID: {perm['app_id']}")
        for permission in perm['permissions']:
            print(f"  {permission['field_name']}: {'Yes' if permission['can_access'] else 'No'}")
        print("-" * 40)

def search_patient():
    patient_id = input("Enter Patient ID to search: ")
    result = patients.find_one({"patient_id": patient_id})
    if result:
        print(f"\n👤 Name: {result['patient_name']}")
        print(f"DOB: {result['dob']}")
        print(f"Vitals: Heart Rate - {result['vitals']['heart_rate']}, Blood Pressure - {result['vitals']['blood_pressure']}")
        print(f"Medications: {', '.join(result['medications'])}")
        print(f"Diagnoses: {', '.join(result['diagnoses'])}")
        print(f"Bill: ID - {result['bill']['bill_id']}, Amount Due - ${result['bill']['amount_due']}, Status - {result['bill']['status']}")
        print(f"Payment Due: {result['bill']['payment_due']}")
        print("Insurance: ", result['bill']['insurance'])
        print("Copayments: ", result['bill']['copayments'])
        print(f"Lab Results: ")
        for lab in result['lab_results']:
            print(f"  {lab['lab_test_name']} | Result: {lab['result']} | Date: {lab['date']}")
    else:
        print("Patient not found.")

def main():
    while True:
        print("\n--- EHR Menu ---")
        print("1. Add Patient")
        print("2. View All Patients")
        print("3. Search Patient by ID")
        print("4. View App Permissions")
        print("5. Quit")
        choice = input("Choose: ")
        if choice == "1":
            add_patient()
        elif choice == "2":
            view_all()
        elif choice == "3":
            search_patient()
        elif choice == "4":
            view_app_permissions()
        elif choice == "5":
            print("👋 Exiting EHR system.")
            break
        else:
            print("Invalid choice. Try again.")

if __name__ == "__main__":
    main()
