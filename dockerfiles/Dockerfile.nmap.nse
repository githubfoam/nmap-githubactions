# https://hub.docker.com/_/alpine
FROM alpine:latest
LABEL org.opencontainers.image.authors="githubfoam"


RUN set -xe && apk --update add nmap \
                     nmap-scripts \
                     git \
                     bash && \ 
        rm -rf /var/lib/apt/lists/* 
        # rm -rf /var/lib/apt/lists/* && \
        # git clone https://github.com/scipag/vulscan.git \
        #     /usr/share/nmap/scripts/vulscan

WORKDIR /usr/share/nmap/scripts/vulscan

RUN set -xe && git clone https://github.com/scipag/vulscan.git \
        /usr/share/nmap/scripts/vulscan && \
        ln -s `pwd`/scipag_vulscan /usr/share/nmap/scripts/vulscan

#update Vuln DBs        
# RUN set -xe && chmod +x utilities/updater/updateFiles.sh && \
#     ./utilities/updater/updateFiles.sh

# stat: can't stat 'utilities/updater/updateFiles.sh': No such file or directory
# RUN rm utilities/updater/updateFiles.sh && stat utilities/updater/updateFiles.sh

RUN rm utilities/updater/updateFiles.sh

COPY dockerfiles/updater_cvs.sh utilities/updater

RUN set -xe && chmod +x utilities/updater/updater_cvs.sh && \
    ./utilities/updater/updater_cvs.sh

#Update CVE databases
# CMD ["/bin/bash","updateFiles.sh"]

ENTRYPOINT ["nmap"]
CMD ["-h"]