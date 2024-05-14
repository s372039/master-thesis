output "IPv4_DEV_SERVER" {
  value = openstack_compute_instance_v2.dev_server.access_ip_v4
}

output "IPv4_DVC_REMOTE_STORAGE_SERVER" {
  value = openstack_compute_instance_v2.dvc_remote_server.access_ip_v4
}

output "IPv4_CENTRAL_DATA_REPOSITORY_SERVER" {
  value = openstack_compute_instance_v2.central_data_repository_server.access_ip_v4
}
