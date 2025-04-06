import grpc
import medimesh_pb2
import medimesh_pb2_grpc
from pymongo import MongoClient

# MongoDB connection setup
client = MongoClient("mongodb://localhost:27017/")  # Connect to local MongoDB instance
db = client["ehr_database"]
app_permissions_collection = db["app_permissions"]  # App Permissions collection

def register_app():
    """Registers an app and stores its details in MongoDB."""
    with grpc.insecure_channel('localhost:50051') as channel:
        stub = medimesh_pb2_grpc.MediMeshServiceStub(channel)

        # Call the RegisterApp RPC to register the app
        request = medimesh_pb2.AppRegistrationRequest()
        response = stub.RegisterApp(request)

        # Extract app_id and api_key from the response
        app_id = response.app_id
        api_key = response.api_key

        print(f"App registered successfully!")
        print(f"App ID: {app_id}")
        print(f"API Key: {api_key}")

        # Get app name from user input
        app_name = input("Enter the App Name: ")

        # Save the new app registration in MongoDB with app_name and permissions
        app_permissions_collection.insert_one({
            "app_id": app_id,
            "app_name": app_name,  # Store the app name
            "api_key": api_key,
            "permissions": [
                {"field_name": "vitals", "can_access": False},
                {"field_name": "medications", "can_access": False},
                {"field_name": "bill", "can_access": False}
            ]  # Initialize with no permissions
        })
        print("✅ App registration saved in the database!")

def main():
    """Main function to start the app registration."""
    print("\n--- Register a New App ---")
    register_app()

if __name__ == "__main__":
    main()
