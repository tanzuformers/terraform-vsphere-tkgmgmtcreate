output "bootstrap_server_root_password" {
  description = "BootVM generated password"
  value = random_password.kickoffvm_password.result
}
output "bootstrap_server_ip" {
  description = "BootVM ip"
  value = var.tkg_bootvm.ip
}

output "kubctl_config" {
  description = "Kubeconf for MGMT cluster content"
  value = data.sshcommand_command.get_kubectl.result
}