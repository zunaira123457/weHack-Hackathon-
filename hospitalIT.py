import grpc
import medimesh_pb2
import medimesh_pb2_grpc

# Function to create the gRPC stub
def create_stub():
    # Set up a connection to the server on localhost:50051
    channel = grpc.insecure_channel('localhost:50051')
    stub = medimesh_pb2_grpc.MediMeshServiceStub(channel)
    return stub

def register_app():
    """Registers an app and returns its app_id and api_key."""
    with grpc.insecure_channel('localhost:50051') as channel:
        stub = medimesh_pb2_grpc.MediMeshServiceStub(channel)

        request = medimesh_pb2.AppRegistrationRequest()
        response = stub.RegisterApp(request)

        print(f"App ID: {response.app_id}")
        print(f"API Key: {response.api_key}")
        print(f"Message: {response.message}")
        return response.app_id

def get_emr_data(app_id, patient_id):
    """Fetches EMR data based on app_id and patient_id."""
    with grpc.insecure_channel('localhost:50051') as channel:
        stub = medimesh_pb2_grpc.MediMeshServiceStub(channel)

        request = medimesh_pb2.EMRDataRequest(app_id=app_id, patient_id=patient_id)
        response = stub.GetEMRData(request)

        if response.status == "success":
            print(f"Vitals: {response.vitals}")
            print(f"Medications: {response.medications}")
            print(f"Bill: {response.bill}")
            print(f"Lab Results: {response.lab_results}")
        else:
            print("Failed to retrieve EMR data")

# Now you can use the stub to call your gRPC methods
def update_app_permissions(app_id, permissions):
    # Initialize the stub to connect to the server
    stub = create_stub()

    # Prepare the permissions in the correct format (list of FieldPermission objects)
    formatted_permissions = []
    for permission in permissions:
        # Construct the FieldPermission message
        formatted_permissions.append(
            medimesh_pb2.FieldPermission(
                field_name=permission['field_name'],
                can_access=permission['can_access']
            )
        )

    # Create the request object for updating permissions
    request = medimesh_pb2.PermissionUpdateRequest(
        app_id=app_id,
        permissions=formatted_permissions  # This should be a list of FieldPermission objects
    )

    # Call the gRPC service to update the permissions
    try:
        response = stub.UpdateAppPermissions(request)
        print(f"Permissions update status: {response.status}")
        print(f"Message: {response.message}")
    except grpc.RpcError as e:
        print(f"Error: {e.details()}")

def get_permissions(app_id):
    """Fetches and prints app permissions."""
    with grpc.insecure_channel('localhost:50051') as channel:
        stub = medimesh_pb2_grpc.MediMeshServiceStub(channel)

        request = medimesh_pb2.PermissionUpdateRequest(app_id=app_id)
        response = stub.GetEMRData(request)  # Placeholder for fetching permissions, adjust if needed.
        print(f"Permissions: {response.permissions}")

def menu():
    """Displays a menu and processes the user's choice."""
    print("\nWelcome to MediMesh IT")
    print("1. Check app permissions")
    print("2. Change app permissions")
    print("3. Exit")

    choice = input("Please choose an option: ")

    if choice == '1':
        app_id = input("Enter the App ID to check permissions: ")
        get_permissions(app_id)

    elif choice == '2':
        app_id = input("Enter the App ID to change permissions: ")
        permissions = []
        
        # Collect the new permissions from the user
        while True:
            field_name = input("Enter the field name to update (vitals, medications, bill, lab_results): ").lower()
            can_access = input(f"Can access {field_name}? (y/n): ").lower() == 'y'
            permissions.append({"field_name": field_name, "can_access": can_access})

            another = input("Do you want to add another permission? (y/n): ").lower()
            if another != 'y':
                break
        
        update_app_permissions(app_id, permissions)

    elif choice == '3':
        print("Exiting...")
        exit()

    else:
        print("Invalid option. Please try again.")

if __name__ == "__main__":
    # Menu loop
    while True:
        menu()
