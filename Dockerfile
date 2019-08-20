FROM centos7

ENV user=dependencycheck
ENV version_url=https://jeremylong.github.io/DependencyCheck/current.txt
ENV download_url=https://dl.bintray.com/jeremy-long/owasp

RUN yum install -y unzip
RUN yum install -y wget

# Use this block for auto-update 
#RUN wget -O /tmp/current.txt ${version_url} && \
 #version=$(cat /tmp/current.txt) && \
 #file="dependency-check-${version}-release.zip" && \

#5.0.0 reduces the download thread count to 2 and utilizes the META files from the NVD as opposed to using a HEAD request
RUN file="dependency-check-5.2.0-release.zip" && \
 wget "$download_url/$file" && \
 unzip ${file} && \
 rm ${file} && \
 mv dependency-check /usr/share/

COPY odc-wrapper.sh /usr/share/dependency-check/bin/
COPY config.ini /usr/share/dependency-check/bin/
COPY HELP.txt /usr/share/dependency-check/bin/
COPY dependencycheck-base-suppression.xml /usr/share/dependency-check/
COPY settings.xml /usr/share/dependency-check/bin/

RUN useradd -ms /bin/bash ${user} && \
 chown -R ${user}:${user} /usr/share/dependency-check && \
 chmod -R 744 /usr/share/dependency-check/bin/odc-wrapper.sh && \
 mkdir /report && \
 chown -R ${user}:${user} /report

USER ${user}

RUN sh /usr/share/dependency-check/bin/dependency-check.sh --updateonly

VOLUME ["/src" "/report"]

WORKDIR /report

CMD ["--help"]
ENTRYPOINT ["/usr/share/dependency-check/bin/odc-wrapper.sh"]
