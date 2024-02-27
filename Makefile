upgrade:
	ansible-playbook playbooks/upgrade_os/upgrade_and_reboot.yml \
		-i inventory.yml \
		-e "target=$${TARGET}" \
		-e "UPGRADE=true" \
		-e "REBOOT=false" \
		-e@./vault.yml

upgrade_and_reboot:
	ansible-playbook playbooks/upgrade_os/upgrade_and_reboot.yml \
		-i inventory.yml \
		-e "target=$${TARGET}" \
		-e "UPGRADE=true" \
		-e "REBOOT=true" \
		-e@./vault.yml

reboot:
	ansible-playbook playbooks/upgrade_os/upgrade_and_reboot.yml \
		-i inventory.yml \
		-e "target=$${TARGET}" \
		-e "UPGRADE=false" \
		-e "REBOOT=true" \
		-e@./vault.yml


list-hosts:
	ansible all -i inventory.yml --list-hosts

ping:
	ansible -i inventory.yml -m ping -e@./vault.yml "$${TARGET}"

deploy_mediaviewer:
	ansible-playbook playbooks/mediaviewer/deploy.yml -i inventory.yml -e@./vault.yml -v

remove_host:
	ansible-playbook playbooks/ca/remove_host.yml \
		-i inventory.yml \
		-e@./vault.yml \
		-e "target=$${TARGET}" \
		-v

provision_host:
	ansible-playbook playbooks/ca/provision_host.yml \
		-i inventory.yml \
		-e@./vault.yml \
		-e "target=$${TARGET}" \
		-v

provision_nginx:
	ansible-playbook playbooks/host/nginx.yml \
		-i inventory.yml \
		-e "target=$${TARGET}" \
		-e@./vault.yml \
		-v

provision_fail2ban:
	ansible-playbook playbooks/host/fail2ban/fail2ban.yml \
		-i inventory.yml \
		-e "target=$${TARGET}" \
		-e@./vault.yml \
		-v

install_pyenv:
	ansible-playbook playbooks/client/pyenv.yml \
		-i inventory.yml \
		-e@./vault.yml \
		-e "target=$${TARGET}" \
		-v

install_neovim:
	ansible-playbook playbooks/client/neovim.yml \
		-i inventory.yml \
		-e@./vault.yml \
		-e "target=$${TARGET}" \
		-v

install_docker:
	ansible-playbook playbooks/client/docker.yml \
		-i inventory.yml \
		-e@./vault.yml \
		-e "target=$${TARGET}" \
		-v

install_dotfiles:
	ansible-playbook playbooks/client/dotfiles.yml \
		-i inventory.yml \
		-e@./vault.yml \
		-e "target=$${TARGET}" \
		-v

gogs_setup:
	ansible-playbook playbooks/git/gogs-setup.yml \
		-i inventory.yml \
		-e@./vault.yml \
		-e "target=$${TARGET}" \
		-v

nixos_rebuild:
	ansible-playbook playbooks/upgrade_os/rebuild_nixos.yml \
		-i inventory.yml \
		-e@./vault.yml \
		-e "target=$${TARGET}" \
		-v

rebuild_nixos: nixos_rebuild

install_tailscale:
	ansible-playbook playbooks/host/tailscale.yml \
		-i inventory.yml \
		-e@./vault.yml \
		-e "target=$${TARGET}" \
		-v

install_matrix:
	ansible-playbook playbooks/matrix/matrix-docker-ansible-deploy/setup.yml \
		-i inventory.yml \
		--tags=install-all,ensure-matrix-users-created,start \
		-e@./vault.yml \
		-e "target=$${TARGET}" \
		-v

register_github:
	ansible-playbook playbooks/git/register-github.yml \
		-i inventory.yml \
		-e@./vault.yml \
		-e "target=$${TARGET}" \
		-v

initialize:
	ansible-playbook playbooks/host/initialize.yml \
		-i inventory.yml \
		--ssh-common-args='-o StrictHostKeyChecking=no' \
		-e@./vault.yml \
		-e "target=$${TARGET}" \
		-v

_deploy_linode:
	ansible-playbook playbooks/host/deploylinode.yml \
		-i inventory.yml \
		-e@./vault.yml \
		-v

deploy_linode: _deploy_linode initialize register_github install_tailscale install_docker install_pyenv install_neovim install_dotfiles

delete_github:
	ansible-playbook playbooks/git/delete-github.yml \
		-i inventory.yml \
		-e@./vault.yml \
		-e "target=$${TARGET}" \
		-v

delete_linode: delete_github
	ansible-playbook playbooks/host/removelinode.yml \
		-i inventory.yml \
		-e@./vault.yml \
		-e "target=$${TARGET}" \
		-v

remove_linode: delete_linode
