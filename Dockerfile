FROM ubuntu:focal as build

LABEL maintener="Cedric M'PAssi"

ENV DEBIAN_FRONTEND=noninteractive

ARG CMAKE_BUILD_TYPE="Release"

RUN apt-get update -y && apt-get upgrade -y \
			&& apt-get install --no-install-recommends -y make \
																										build-essential \
																										autoconf \
																										automake \
																										ninja-build \
																										coreutils\
																										cmake \
																										libtool-bin \
  																									pkgconf \
																										gettext \
																										ca-certificates \
																										unzip \
																										git \
																										curl \
			&& apt-get clean


RUN git -c advice.detachedHead=false clone \
				--branch "nightly" \
				--depth="1"  \
				--progress \
				https://github.com/neovim/neovim.git \
				&& make -C "/neovim" install

FROM ubuntu:focal

ARG UUID
ARG UGID
RUN apt-get update -y && apt-get upgrade -y \
  	&& apt-get install --no-install-recommends -y gcc \
  																								curl \
  																								git \
																									ca-certificates \
  																								unzip

COPY --from=build /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=build /usr/local/share/nvim /usr/local/share/nvim
COPY --from=build /usr/local/lib/nvim /usr/local/lib/nvim

ENV TERM=xterm-256color

RUN groupadd neovim && useradd -m -u ${UUID} -g ${UGID} -s "/bin/bash" neovim\
		&& su neovim  -c 'git clone https://github.com/wbthomason/packer.nvim \
 			~/.local/share/nvim/site/pack/packer/opt/packer.nvim'

COPY ./entrypoint.sh /entrypoint.sh

RUN chmod 777 /entrypoint.sh

WORKDIR /home/neovim

RUN mkdir -p .config/nvim

ENTRYPOINT [ "/entrypoint.sh" ]
