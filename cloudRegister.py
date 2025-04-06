import grpc
import medimesh_pb2
import medimesh_pb2_grpc
from pymongo import MongoClient
import os

# MongoDB connection setup
atlas_connection_string = os.getenv('MONGO_ATLAS_URI')

if not atlas_connection_string:
    raise ValueError("Atlas connection string not found in .env file")

# Create a MongoDB client using the Atlas connection string
client = MongoClient(atlas_connection_string)
db = client["ehr_database"]
app_permissions_collection = db["app_permissions"]  # App Permissions collection

def register_app():
    """Registers an app and stores its details in MongoDB."""
    with grpc.insecure_channel('localhost:50051') as channel:
        stub = medimesh_pb2_grpc.MediMeshServiceStub(channel)

        # Get app name from user input (no need to store in MongoDB on client side)
        app_name = input("Enter the App Name: ")

        # Create a request with app_name
        request = medimesh_pb2.AppRegistrationRequest(
            app_name=app_name
        )
        response = stub.RegisterApp(request)

        # Extract app_id and api_key from the response
        app_id = response.app_id
        api_key = response.api_key

        print(f"App registered successfully!")
        print(f"App ID: {app_id}")
        print(f"API Key: {api_key}")
        print(f"App Name: {app_name}")

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

        # You can store the app name locally or elsewhere, but MongoDB insertion should only happen on the server.
        # The server handles database insertion, so you do not need to insert the app registration again here.
        print("✅ App registered successfully on the server!")

def main():
    """Main function to start the app registration."""
    print("\n--- Register a New App ---")
    register_app()

if __name__ == "__main__":
    main()
