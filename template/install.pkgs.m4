ifelse(index(DOCKER_IMAGE,centos),-1,,
RUN ifdef(`INSTALL_PKGS_FFMPEG',yum install -y epel-release; ) \
ifdef(`INSTALL_PKGS_GST_PLUGIN_BAD',    `dnl 
    yum localinstall -y --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm; \
')dnl
    yum install -y -q defn(`INSTALL_PKGS_FFMPEG',`INSTALL_PKGS_TRANSFORM360',`INSTALL_PKGS_GST',`INSTALL_PKGS_NGINX',`INSTALL_PKGS_LIBDRM',`INSTALL_PKGS_GST_PLUGIN_VAAPI',`INSTALL_PKGS_GST_PLUGIN_BASE', `INSTALL_PKGS_MEDIA_DRIVER', `INSTALL_PKGS_VA_GST_PLUGINS', `INSTALL_PKGS_LIBVA', `INSTALL_PKGS_GST_PLUGIN_GOOD', `INSTALL_PKGS_GST_PLUGIN_BAD', `INSTALL_PKGS_PYTHON'); \
ifdef(`INSTALL_PKGS_FFMPEG',`dnl
    yum remove -y -q epel-release; \
')dnl
ifdef(`INSTALL_PKGS_GST_PLUGIN_BAD',    `dnl 
    yum remove -y -q rpmfusion-free-release; \
')dnl
    rm -rf /var/cache/yum/*;dnl
)dnl
ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,,
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends defn(`INSTALL_PKGS_FFMPEG',`INSTALL_PKGS_TRANSFORM360',`INSTALL_PKGS_GST',`INSTALL_PKGS_NGINX',`INSTALL_PKGS_GST_PLUGIN_VAAPI',`INSTALL_PKGS_GST_PLUGIN_BASE', `INSTALL_PKGS_GST_PLUGIN_GOOD', `INSTALL_PKGS_PYTHON', `INSTALL_PKGS_VA_GST_PLUGINS',`INSTALL_PKGS_OPENCL',`INSTALL_PKGS_LIBVA',`INSTALL_PKGS_OPENVINO'); \
    rm -rf /var/lib/apt/lists/*;dnl
)dnl
ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,,
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime; \
    DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends defn(`INSTALL_PKGS_FFMPEG',`INSTALL_PKGS_TRANSFORM360',`INSTALL_PKGS_GST',`INSTALL_PKGS_NGINX',`INSTALL_PKGS_GST_PLUGIN_VAAPI',`INSTALL_PKGS_GST_PLUGIN_BASE', `INSTALL_PKGS_GST_PLUGIN_GOOD', `INSTALL_PKGS_PYTHON', `INSTALL_PKGS_VA_GST_PLUGINS',`INSTALL_PKGS_OPENCL',`INSTALL_PKGS_LIBVA',`INSTALL_PKGS_OPENVINO'); \
    rm -rf /var/lib/apt/lists/*;dnl
)dnl
