VM_NAME := rio-barge

NETWORK_ADAPTER := en0: Wi-Fi (AirPort)

ID := `cat .vagrant/machines/$(VM_NAME)/virtualbox/id`

provision:
	@vagrant up
	@vagrant ssh-config > .ssh_config
	@vagrant halt
	@echo "Making the first network interface bridged to [$(NETWORK_ADAPTER)]"
	@VBoxManage modifyvm $(ID) --nic1 bridged --bridgeadapter1 "$(NETWORK_ADAPTER)"
	@echo "Ready to make up!"

up resume:
	@VBoxManage startvm $(ID) --type headless
	@while \
		ID=$(ID); \
		VALUE=`VBoxManage guestproperty get $${ID} /VirtualBox/GuestInfo/Net/0/V4/IP`; \
		[ "$${VALUE}" = "No value set!" ]; do \
		sleep 0.5; \
	done

status:
	@VBoxManage showvminfo $(ID) | grep State

ip:
	@VBoxManage guestproperty get $(ID) /VirtualBox/GuestInfo/Net/0/V4/IP | awk '{print $$2}'

ssh:
	$(eval IP=$(shell make ip))
	@sed -i '' 's/HostName .*/HostName $(IP)/' .ssh_config
	@sed -i '' 's/Port .*/Port 22/g' .ssh_config
	@ssh -F .ssh_config $(VM_NAME)

suspend:
	@VBoxManage controlvm $(ID) savestate

halt:
	@VBoxManage controlvm $(ID) acpipowerbutton

destroy:
	@vagrant destroy -f
	@$(RM) -r .vagrant

.PHONY: provision up status ip ssh suspend resume halt destroy
