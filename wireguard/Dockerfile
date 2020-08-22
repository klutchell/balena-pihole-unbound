
# https://www.balena.io/blog/how-to-run-wireguard-vpn-in-balenaos/

FROM balenalib/raspberrypi3-debian:build as build

RUN install_packages curl build-essential libelf-dev libssl-dev pkg-config git flex bison bc python kmod

WORKDIR /usr/src

ENV BALENA_MACHINE_NAME "raspberrypi3"
ENV VERSION "2.47.0+rev1.prod"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN curl -L "https://files.balena-cloud.com/images/${BALENA_MACHINE_NAME}/${VERSION/+/%2B}/kernel_modules_headers.tar.gz" | tar xvz
 
RUN make -C kernel_modules_headers -j"$(nproc)" modules_prepare

FROM linuxserver/wireguard:arm32v7-v1.0.20200820-ls28

COPY --from=build /usr/src/kernel_modules_headers/ /usr/src/kernel_modules_headers/

RUN make -C /usr/src/kernel_modules_headers M=/app/wireguard-linux-compat/src -j"$(nproc)"  

COPY insmod.sh /

RUN chmod +x /insmod.sh

ENTRYPOINT [ "/bin/bash", "-c", "/insmod.sh && /init" ]
