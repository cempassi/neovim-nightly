NAME := "cempassi/neovim-nightly"
UUID := $(shell id -u)
UGID := $(shell id -g)

build:
	docker build --build-arg UUID=${UUID} --build-arg UGID=${UGID} -t $(NAME) .

run:
	docker container run --interactive --rm --tty \
		--volume "${PWD}/nvim:/home/neovim/.config/nvim" \
		$(NAME)
