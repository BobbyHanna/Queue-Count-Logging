ARG IMAGE=intersystems/iris:2019.1.0S.111.0
ARG IMAGE=store/intersystems/iris:2019.1.0.511.0-community
ARG IMAGE=store/intersystems/iris:2019.2.0.107.0-community
ARG IMAGE=intersystemsdc/iris-community:2020.4.0.547.0-zpm
ARG IMAGE=intersystemsdc/iris-community:latest
FROM $IMAGE
ARG NAMESPACE="QLOG"

USER root  
WORKDIR /opt/app
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/app
USER ${ISC_PACKAGE_MGRUSER}

COPY ./Installer.cls ./
COPY ./cls ./src/

RUN mkdir -p /tmp/deps \

 && cd /tmp/deps \

 && wget -q https://pm.community.intersystems.com/packages/zpm/latest/installer -O zpm.xml

RUN iris start $ISC_PACKAGE_INSTANCENAME quietly EmergencyId=sys,sys && \
    /bin/echo -e "sys\nsys\n" \
            " Do ##class(Security.Users).UnExpireUserPasswords(\"*\")\n" \
            " Do ##class(Security.Users).AddRoles(\"admin\", \"%ALL\")\n" \
            " Do ##class(Security.System).Get(,.p)\n" \
            " Set p(\"AutheEnabled\")=\$zb(p(\"AutheEnabled\"),16,7)\n" \
            " Do ##class(Security.System).Modify(,.p)\n" \
            " Do \$system.OBJ.Load(\"/tmp/deps/zpm.xml\", \"ck\")" \
            " Do \$system.OBJ.Load(\"/opt/app/Installer.cls\",\"ck\")\n" \
            " Set sc = ##class(App.Installer).setup(, 3)\n" \
            " If 'sc do \$zu(4, \$JOB, 1)\n" \
            " halt" \
    | iris session $ISC_PACKAGE_INSTANCENAME && \
    /bin/echo -e "sys\nsys\n" \
    | iris stop $ISC_PACKAGE_INSTANCENAME quietly

CMD [ "-l", "/usr/irissys/mgr/messages.log" ]
