# -*- coding: utf-8 -*-
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# NO CHECKED-IN PROTOBUF GENCODE
# source: medimesh.proto
# Protobuf Python Version: 5.29.0
"""Generated protocol buffer code."""
from google.protobuf import descriptor as _descriptor
from google.protobuf import descriptor_pool as _descriptor_pool
from google.protobuf import runtime_version as _runtime_version
from google.protobuf import symbol_database as _symbol_database
from google.protobuf.internal import builder as _builder
_runtime_version.ValidateProtobufRuntimeVersion(
    _runtime_version.Domain.PUBLIC,
    5,
    29,
    0,
    '',
    'medimesh.proto'
)
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()




DESCRIPTOR = _descriptor_pool.Default().AddSerializedFile(b'\n\x0emedimesh.proto\x12\x08medimesh\"A\n\x16\x41ppRegistrationRequest\x12\x10\n\x08\x61pp_name\x18\x01 \x01(\t\x12\x15\n\rcontact_email\x18\x02 \x01(\t\"K\n\x17\x41ppRegistrationResponse\x12\x0e\n\x06\x61pp_id\x18\x01 \x01(\t\x12\x0f\n\x07\x61pi_key\x18\x02 \x01(\t\x12\x0f\n\x07message\x18\x03 \x01(\t\"X\n\x0e\x45MRDataRequest\x12\x0e\n\x06\x61pp_id\x18\x01 \x01(\t\x12\x0f\n\x07\x61pi_key\x18\x02 \x01(\t\x12\x11\n\tdata_type\x18\x03 \x01(\t\x12\x12\n\npatient_id\x18\x04 \x01(\t\"\xeb\x01\n\x0f\x45MRDataResponse\x12\x0e\n\x06status\x18\x01 \x01(\t\x12\x12\n\npatient_id\x18\x02 \x01(\t\x12\x14\n\x0cpatient_name\x18\x03 \x01(\t\x12\x0b\n\x03\x64ob\x18\x04 \x01(\t\x12 \n\x06vitals\x18\x05 \x01(\x0b\x32\x10.medimesh.Vitals\x12\x13\n\x0bmedications\x18\x06 \x03(\t\x12\x11\n\tdiagnoses\x18\x07 \x03(\t\x12\x1c\n\x04\x62ill\x18\x08 \x01(\x0b\x32\x0e.medimesh.Bill\x12)\n\x0blab_results\x18\t \x01(\x0b\x32\x14.medimesh.LabResults\"4\n\x06Vitals\x12\x12\n\nheart_rate\x18\x01 \x01(\x05\x12\x16\n\x0e\x62lood_pressure\x18\x02 \x01(\t\"\xa2\x01\n\x04\x42ill\x12\x0f\n\x07\x62ill_id\x18\x01 \x01(\t\x12\x12\n\namount_due\x18\x02 \x01(\x02\x12\x0e\n\x06status\x18\x03 \x01(\t\x12\x13\n\x0bpayment_due\x18\x04 \x01(\t\x12&\n\tinsurance\x18\x05 \x01(\x0b\x32\x13.medimesh.Insurance\x12(\n\ncopayments\x18\x06 \x01(\x0b\x32\x14.medimesh.Copayments\"m\n\tInsurance\x12\x14\n\x0c\x63ompany_name\x18\x01 \x01(\t\x12\x13\n\x0bmember_name\x18\x02 \x01(\t\x12\x11\n\tmember_id\x18\x03 \x01(\t\x12\x14\n\x0cgroup_number\x18\x04 \x01(\t\x12\x0c\n\x04plan\x18\x05 \x01(\t\"k\n\nCopayments\x12\x14\n\x0coffice_visit\x18\x01 \x01(\x02\x12\x14\n\x0cprescription\x18\x02 \x01(\x02\x12\x16\n\x0e\x65mergency_room\x18\x03 \x01(\x02\x12\x19\n\x11out_of_pocket_max\x18\x04 \x01(\x02\"A\n\nLabResults\x12\x15\n\rlab_test_name\x18\x01 \x01(\t\x12\x0e\n\x06result\x18\x02 \x01(\t\x12\x0c\n\x04\x64\x61te\x18\x03 \x01(\t\"9\n\x0f\x46ieldPermission\x12\x12\n\nfield_name\x18\x01 \x01(\t\x12\x12\n\ncan_access\x18\x02 \x01(\x08\"n\n\x17PermissionUpdateRequest\x12\x13\n\x0b\x61\x64min_token\x18\x01 \x01(\t\x12\x0e\n\x06\x61pp_id\x18\x02 \x01(\t\x12.\n\x0bpermissions\x18\x03 \x03(\x0b\x32\x19.medimesh.FieldPermission\";\n\x18PermissionUpdateResponse\x12\x0e\n\x06status\x18\x01 \x01(\t\x12\x0f\n\x07message\x18\x02 \x01(\t\"5\n\x0f\x41uditLogRequest\x12\x13\n\x0b\x61\x64min_token\x18\x01 \x01(\t\x12\r\n\x05limit\x18\x02 \x01(\x05\"U\n\rAuditLogEntry\x12\x11\n\ttimestamp\x18\x01 \x01(\t\x12\x0e\n\x06\x61pp_id\x18\x02 \x01(\t\x12\x11\n\tdata_type\x18\x03 \x01(\t\x12\x0e\n\x06status\x18\x04 \x01(\t\"9\n\x10\x41uditLogResponse\x12%\n\x04logs\x18\x01 \x03(\x0b\x32\x17.medimesh.AuditLogEntry\"m\n\x1ePatientPermissionUpdateRequest\x12\x12\n\npatient_id\x18\x01 \x01(\t\x12\x0e\n\x06\x61pp_id\x18\x02 \x01(\t\x12\x11\n\tdata_type\x18\x03 \x01(\t\x12\x14\n\x0cgrant_access\x18\x04 \x01(\x08\"B\n\x1fPatientPermissionUpdateResponse\x12\x0e\n\x06status\x18\x01 \x01(\t\x12\x0f\n\x07message\x18\x02 \x01(\t2\xbf\x03\n\x0fMediMeshService\x12R\n\x0bRegisterApp\x12 .medimesh.AppRegistrationRequest\x1a!.medimesh.AppRegistrationResponse\x12\x41\n\nGetEMRData\x12\x18.medimesh.EMRDataRequest\x1a\x19.medimesh.EMRDataResponse\x12]\n\x14UpdateAppPermissions\x12!.medimesh.PermissionUpdateRequest\x1a\".medimesh.PermissionUpdateResponse\x12\x45\n\x0cGetAuditLogs\x12\x19.medimesh.AuditLogRequest\x1a\x1a.medimesh.AuditLogResponse\x12o\n\x18UpdatePatientPermissions\x12(.medimesh.PatientPermissionUpdateRequest\x1a).medimesh.PatientPermissionUpdateResponseb\x06proto3')

_globals = globals()
_builder.BuildMessageAndEnumDescriptors(DESCRIPTOR, _globals)
_builder.BuildTopDescriptorsAndMessages(DESCRIPTOR, 'medimesh_pb2', _globals)
if not _descriptor._USE_C_DESCRIPTORS:
  DESCRIPTOR._loaded_options = None
  _globals['_APPREGISTRATIONREQUEST']._serialized_start=28
  _globals['_APPREGISTRATIONREQUEST']._serialized_end=93
  _globals['_APPREGISTRATIONRESPONSE']._serialized_start=95
  _globals['_APPREGISTRATIONRESPONSE']._serialized_end=170
  _globals['_EMRDATAREQUEST']._serialized_start=172
  _globals['_EMRDATAREQUEST']._serialized_end=260
  _globals['_EMRDATARESPONSE']._serialized_start=263
  _globals['_EMRDATARESPONSE']._serialized_end=498
  _globals['_VITALS']._serialized_start=500
  _globals['_VITALS']._serialized_end=552
  _globals['_BILL']._serialized_start=555
  _globals['_BILL']._serialized_end=717
  _globals['_INSURANCE']._serialized_start=719
  _globals['_INSURANCE']._serialized_end=828
  _globals['_COPAYMENTS']._serialized_start=830
  _globals['_COPAYMENTS']._serialized_end=937
  _globals['_LABRESULTS']._serialized_start=939
  _globals['_LABRESULTS']._serialized_end=1004
  _globals['_FIELDPERMISSION']._serialized_start=1006
  _globals['_FIELDPERMISSION']._serialized_end=1063
  _globals['_PERMISSIONUPDATEREQUEST']._serialized_start=1065
  _globals['_PERMISSIONUPDATEREQUEST']._serialized_end=1175
  _globals['_PERMISSIONUPDATERESPONSE']._serialized_start=1177
  _globals['_PERMISSIONUPDATERESPONSE']._serialized_end=1236
  _globals['_AUDITLOGREQUEST']._serialized_start=1238
  _globals['_AUDITLOGREQUEST']._serialized_end=1291
  _globals['_AUDITLOGENTRY']._serialized_start=1293
  _globals['_AUDITLOGENTRY']._serialized_end=1378
  _globals['_AUDITLOGRESPONSE']._serialized_start=1380
  _globals['_AUDITLOGRESPONSE']._serialized_end=1437
  _globals['_PATIENTPERMISSIONUPDATEREQUEST']._serialized_start=1439
  _globals['_PATIENTPERMISSIONUPDATEREQUEST']._serialized_end=1548
  _globals['_PATIENTPERMISSIONUPDATERESPONSE']._serialized_start=1550
  _globals['_PATIENTPERMISSIONUPDATERESPONSE']._serialized_end=1616
  _globals['_MEDIMESHSERVICE']._serialized_start=1619
  _globals['_MEDIMESHSERVICE']._serialized_end=2066
# @@protoc_insertion_point(module_scope)
