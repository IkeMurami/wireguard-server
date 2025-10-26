# Эта переменная в env'ах нужна для docker-compose: локальные пути будут определяться корректно
export PWD := $(shell pwd)

ADDR = $(word 2,$(MAKECMDGOALS))

# Предотвращаем выполнение аргумента как цели
$(ADDR):
	@:

hello:
	@echo 'Build project'
	@cd deploy && make hello

init:
	@cd deploy && make init

plan:
	@cd deploy && make plan

apply:
	@cd deploy && make apply

connect:
	@cd deploy && ssh -l yc-user -i ycvm $(ADDR)

qr:
	@cd deploy && qrencode -t ansiutf8 < client.conf

destroy:
	@cd deploy && make destroy
