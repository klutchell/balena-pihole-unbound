
FROM linuxserver/wireguard:arm32v7-v1.0.20200827-ls29

COPY insmod.sh /

RUN chmod +x /insmod.sh

ENTRYPOINT [ "/bin/bash", "-c", "/insmod.sh && /init" ]
