output "bootstrap_server_root_password" {
  value = random_password.kickoffvm_password.result
}
output "bootstrap_server_ip" {
  value = var.tkg_bootvm.ip
}

output "kubctl_config" {
  value = data.sshcommand_command.get_kubectl.result
}



