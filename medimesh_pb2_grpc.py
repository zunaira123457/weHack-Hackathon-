# Generated by the gRPC Python protocol compiler plugin. DO NOT EDIT!
"""Client and server classes corresponding to protobuf-defined services."""
import grpc
import warnings

import medimesh_pb2 as medimesh__pb2

GRPC_GENERATED_VERSION = '1.71.0'
GRPC_VERSION = grpc.__version__
_version_not_supported = False

try:
    from grpc._utilities import first_version_is_lower
    _version_not_supported = first_version_is_lower(GRPC_VERSION, GRPC_GENERATED_VERSION)
except ImportError:
    _version_not_supported = True

if _version_not_supported:
    raise RuntimeError(
        f'The grpc package installed is at version {GRPC_VERSION},'
        + f' but the generated code in medimesh_pb2_grpc.py depends on'
        + f' grpcio>={GRPC_GENERATED_VERSION}.'
        + f' Please upgrade your grpc module to grpcio>={GRPC_GENERATED_VERSION}'
        + f' or downgrade your generated code using grpcio-tools<={GRPC_VERSION}.'
    )


class MediMeshServiceStub(object):
    """Missing associated documentation comment in .proto file."""

    def __init__(self, channel):
        """Constructor.

        Args:
            channel: A grpc.Channel.
        """
        self.RegisterApp = channel.unary_unary(
                '/medimesh.MediMeshService/RegisterApp',
                request_serializer=medimesh__pb2.AppRegistrationRequest.SerializeToString,
                response_deserializer=medimesh__pb2.AppRegistrationResponse.FromString,
                _registered_method=True)
        self.GetEMRData = channel.unary_unary(
                '/medimesh.MediMeshService/GetEMRData',
                request_serializer=medimesh__pb2.EMRDataRequest.SerializeToString,
                response_deserializer=medimesh__pb2.EMRDataResponse.FromString,
                _registered_method=True)
        self.UpdateAppPermissions = channel.unary_unary(
                '/medimesh.MediMeshService/UpdateAppPermissions',
                request_serializer=medimesh__pb2.PermissionUpdateRequest.SerializeToString,
                response_deserializer=medimesh__pb2.PermissionUpdateResponse.FromString,
                _registered_method=True)
        self.GetAuditLogs = channel.unary_unary(
                '/medimesh.MediMeshService/GetAuditLogs',
                request_serializer=medimesh__pb2.AuditLogRequest.SerializeToString,
                response_deserializer=medimesh__pb2.AuditLogResponse.FromString,
                _registered_method=True)
        self.UpdatePatientPermissions = channel.unary_unary(
                '/medimesh.MediMeshService/UpdatePatientPermissions',
                request_serializer=medimesh__pb2.PatientPermissionUpdateRequest.SerializeToString,
                response_deserializer=medimesh__pb2.PatientPermissionUpdateResponse.FromString,
                _registered_method=True)


class MediMeshServiceServicer(object):
    """Missing associated documentation comment in .proto file."""

    def RegisterApp(self, request, context):
        """Register a third-party app
        """
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')

    def GetEMRData(self, request, context):
        """Request EMR data like vitals or medications
        """
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')

    def UpdateAppPermissions(self, request, context):
        """Hospital toggles app permissions
        """
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')

    def GetAuditLogs(self, request, context):
        """Get audit log entries
        """
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')

    def UpdatePatientPermissions(self, request, context):
        """Patient toggles app permissions
        """
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')


def add_MediMeshServiceServicer_to_server(servicer, server):
    rpc_method_handlers = {
            'RegisterApp': grpc.unary_unary_rpc_method_handler(
                    servicer.RegisterApp,
                    request_deserializer=medimesh__pb2.AppRegistrationRequest.FromString,
                    response_serializer=medimesh__pb2.AppRegistrationResponse.SerializeToString,
            ),
            'GetEMRData': grpc.unary_unary_rpc_method_handler(
                    servicer.GetEMRData,
                    request_deserializer=medimesh__pb2.EMRDataRequest.FromString,
                    response_serializer=medimesh__pb2.EMRDataResponse.SerializeToString,
            ),
            'UpdateAppPermissions': grpc.unary_unary_rpc_method_handler(
                    servicer.UpdateAppPermissions,
                    request_deserializer=medimesh__pb2.PermissionUpdateRequest.FromString,
                    response_serializer=medimesh__pb2.PermissionUpdateResponse.SerializeToString,
            ),
            'GetAuditLogs': grpc.unary_unary_rpc_method_handler(
                    servicer.GetAuditLogs,
                    request_deserializer=medimesh__pb2.AuditLogRequest.FromString,
                    response_serializer=medimesh__pb2.AuditLogResponse.SerializeToString,
            ),
            'UpdatePatientPermissions': grpc.unary_unary_rpc_method_handler(
                    servicer.UpdatePatientPermissions,
                    request_deserializer=medimesh__pb2.PatientPermissionUpdateRequest.FromString,
                    response_serializer=medimesh__pb2.PatientPermissionUpdateResponse.SerializeToString,
            ),
    }
    generic_handler = grpc.method_handlers_generic_handler(
            'medimesh.MediMeshService', rpc_method_handlers)
    server.add_generic_rpc_handlers((generic_handler,))
    server.add_registered_method_handlers('medimesh.MediMeshService', rpc_method_handlers)


 # This class is part of an EXPERIMENTAL API.
class MediMeshService(object):
    """Missing associated documentation comment in .proto file."""

    @staticmethod
    def RegisterApp(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(
            request,
            target,
            '/medimesh.MediMeshService/RegisterApp',
            medimesh__pb2.AppRegistrationRequest.SerializeToString,
            medimesh__pb2.AppRegistrationResponse.FromString,
            options,
            channel_credentials,
            insecure,
            call_credentials,
            compression,
            wait_for_ready,
            timeout,
            metadata,
            _registered_method=True)

    @staticmethod
    def GetEMRData(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(
            request,
            target,
            '/medimesh.MediMeshService/GetEMRData',
            medimesh__pb2.EMRDataRequest.SerializeToString,
            medimesh__pb2.EMRDataResponse.FromString,
            options,
            channel_credentials,
            insecure,
            call_credentials,
            compression,
            wait_for_ready,
            timeout,
            metadata,
            _registered_method=True)

    @staticmethod
    def UpdateAppPermissions(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(
            request,
            target,
            '/medimesh.MediMeshService/UpdateAppPermissions',
            medimesh__pb2.PermissionUpdateRequest.SerializeToString,
            medimesh__pb2.PermissionUpdateResponse.FromString,
            options,
            channel_credentials,
            insecure,
            call_credentials,
            compression,
            wait_for_ready,
            timeout,
            metadata,
            _registered_method=True)

    @staticmethod
    def GetAuditLogs(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(
            request,
            target,
            '/medimesh.MediMeshService/GetAuditLogs',
            medimesh__pb2.AuditLogRequest.SerializeToString,
            medimesh__pb2.AuditLogResponse.FromString,
            options,
            channel_credentials,
            insecure,
            call_credentials,
            compression,
            wait_for_ready,
            timeout,
            metadata,
            _registered_method=True)

    @staticmethod
    def UpdatePatientPermissions(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(
            request,
            target,
            '/medimesh.MediMeshService/UpdatePatientPermissions',
            medimesh__pb2.PatientPermissionUpdateRequest.SerializeToString,
            medimesh__pb2.PatientPermissionUpdateResponse.FromString,
            options,
            channel_credentials,
            insecure,
            call_credentials,
            compression,
            wait_for_ready,
            timeout,
            metadata,
            _registered_method=True)
