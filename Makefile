.PHONY: 

gen_ssh:
	ssh-keygen -t rsa -C "18922251299@163.com"

show_ssh:
	cat ~/.ssh/id_rsa.pub
