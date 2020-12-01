UUID := $(shell id -u)
UGID := $(shell id -g)

build:
	docker build --build-arg UUID=${UUID} --build-arg UGID=${UGID} \
		-t cempassi/neovim-nightly .

run:
	docker container run \
		--interactive \
		--rm \
		--tty \
		--volume "${PWD}/nvim:/home/neovim/.config/nvim" \
		cempassi/neovim-nightly
