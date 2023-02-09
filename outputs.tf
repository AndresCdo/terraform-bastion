output "ip_dir" {
  description = "Server's IP."
  value       = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}