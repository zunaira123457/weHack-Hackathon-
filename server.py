import grpc
from concurrent import futures
import medimesh_pb2
import medimesh_pb2_grpc
from pymongo import MongoClient
import datetime
import requests
import uuid
import time
import os
from dotenv import load_dotenv

def serve():
    # Set up the gRPC server
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    medimesh_pb2_grpc.add_MediMeshServiceServicer_to_server(MediMeshService(), server)
    server.add_insecure_port('[::]:50051')  # Binds to localhost:50051

    print("Server is running on port 50051...")
    server.start()  # Start the server to begin accepting connections

    try:
        while True:
            time.sleep(60 * 60 * 24)  # Keep server running for 24 hours
    except KeyboardInterrupt:
        server.stop(0)

# Load environment variables from the .env file
load_dotenv()

# MongoDB connection setup (local connection)
def get_mongo_client():
    try:
        # Get the connection string from environment variables
        atlas_connection_string = os.getenv('MONGO_ATLAS_URI')

        if not atlas_connection_string:
            raise ValueError("Atlas connection string not found in .env file")
        
        # Create a MongoDB client using the Atlas connection string
        client = MongoClient(atlas_connection_string)
        client.admin.command('ping')  # Test the connection
        print("Successfully connected to MongoDB Atlas")
        return client
    except Exception as e:
        print("Error connecting to MongoDB:", e)
        exit(1)

client = get_mongo_client()

# Access the specific databases and collections
db = client["ehr_database"]  # The EHR database
app_permissions_collection = db["app_permissions"]  # Collection for app permissions
patients_collection = db["patients"]  # Collection for patient data
audit_logs_collection = client["audit_log"]["logs"]  # Collection for audit logs

class MediMeshService(medimesh_pb2_grpc.MediMeshServiceServicer):
    def RegisterApp(self, request, context):
        # Generate a unique app_id and API key
        app_id = str(uuid.uuid4())  # Generate a unique app_id using UUID
        api_key = self.generate_api_key()  # Generate a unique API key
        app_name = request.app_name  # Get the app_name from the request

        try:
            # Generate response with app_id and api_key, but don't insert into DB here
            return medimesh_pb2.AppRegistrationResponse(
                app_id=app_id,
                api_key=api_key,
                message="App registered successfully!"
            )

        except Exception as e:
            # Handle errors and return failure response
            context.set_details(f"Error generating app registration: {str(e)}")
            context.set_code(grpc.StatusCode.INTERNAL)
            return medimesh_pb2.AppRegistrationResponse(
                app_id="",
                api_key="",
                message="Error registering app."
            )

    def generate_api_key(self, length=32):
        # Securely generate an API key
        import secrets
        import string
        alphabet = string.ascii_letters + string.digits
        return ''.join(secrets.choice(alphabet) for i in range(length))

    def GetEMRData(self, request, context):
        app_id = request.app_id
        permissions = self.get_permissions(app_id)

        if not permissions:
            context.set_details('App has no permissions')
            context.set_code(grpc.StatusCode.PERMISSION_DENIED)
            return medimesh_pb2.EMRDataResponse(status="failed")

        try:
            # Fetch EMR data
            vitals = self.get_patient_vitals(request.patient_id)
            medications = self.get_patient_medications(request.patient_id)
            bill = self.get_patient_bill(request.patient_id)
            lab_results = self.get_patient_lab_results(request.patient_id)

            # Check field permissions
            if not any(p.field_name == "vitals" and p.can_access for p in permissions):
                vitals = None  # No access to vitals

            if not any(p.field_name == "medications" and p.can_access for p in permissions):
                medications = []  # No access to medications

            if not any(p.field_name == "bill" and p.can_access for p in permissions):
                bill = None  # No access to bill

            if not any(p.field_name == "lab_results" and p.can_access for p in permissions):
                lab_results = None  # No access to lab results
        except Exception as e:
            context.set_details(f"Error retrieving EMR data: {str(e)}")
            context.set_code(grpc.StatusCode.INTERNAL)
            return medimesh_pb2.EMRDataResponse(status="failed")

        return medimesh_pb2.EMRDataResponse(
            status="success",
            patient_id=request.patient_id,
            vitals=vitals,
            medications=medications,
            bill=bill,
            lab_results=lab_results
        )
    
    def GetAppPermissions(self, request, context):
        app_id = request.app_id
        permissions = self.get_permissions(app_id)

        if not permissions:
            context.set_details('No permissions found for the app.')
            context.set_code(grpc.StatusCode.NOT_FOUND)
            return medimesh_pb2.AppPermissionResponse(permissions=[])

        permissions_response = []
        for perm in permissions:
            permissions_response.append(
                medimesh_pb2.FieldPermission(
                    field_name=perm['field_name'],
                    can_access=perm['can_access']
                )
            )

        return medimesh_pb2.AppPermissionResponse(permissions=permissions_response)

    def get_permissions(self, app_id):
        # Retrieve permissions from the database for the given app_id
        permissions_doc = app_permissions_collection.find_one({"app_id": app_id})
        return permissions_doc["permissions"] if permissions_doc else None

    def UpdateAppPermissions(self, request, context):
        # Update permissions for the app
        app_id = request.app_id
        permissions = request.permissions

        # Convert FieldPermission messages to dictionaries
        permissions_dict = [
            {"field_name": permission.field_name, "can_access": permission.can_access}
            for permission in permissions
        ]
        
        # Log the permissions being sent to MongoDB
        print(f"Updating permissions for app_id: {app_id}")
        print(f"New permissions: {permissions_dict}")

        # Store the updated permissions in the database
        result = app_permissions_collection.update_one(
            {"app_id": app_id},
            {"$set": {"permissions": permissions_dict}},
            upsert=True
        )
        
        # Log the result of the update operation
        if result.matched_count > 0:
            print(f"Successfully updated permissions for app_id: {app_id}")
        else:
            print(f"No matching app_id found, a new document was created with app_id: {app_id}")

        if result.modified_count > 0:
            print("Permissions were updated successfully.")
        else:
            print("No permissions were modified. Check the data passed.")

        return medimesh_pb2.PermissionUpdateResponse(
            status="success",
            message="App permissions updated."
        )

    def log_audit(self, app_id, data_type, status):
        log_entry = {
            "timestamp": datetime.datetime.utcnow().isoformat(),
            "app_id": app_id,
            "data_type": data_type,
            "status": status
        }
        audit_logs_collection.insert_one(log_entry)

if __name__ == '__main__':
    serve()