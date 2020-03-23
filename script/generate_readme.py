import os
from pathlib import Path
import re

REPO_LINK = "https://github.com/OpenVisualCloud/Dockerfiles/blob/master/"

#Platform to full name
platform_subs = {
                "Xeon" : "Xeon&reg; platform",
                "XeonE3" : "Xeon&reg; E3 platform",
                "VCA2" : "VCA2 platform",
                "QAT" : "QAT platform",
                "VCAC-A" : "VCAC-A platform",
                }

#When image is based on another OVC image, this is used to find path of inherited image
path_subs = {
                "xeone3-centos75-media-ffmpeg" : "XeonE3/centos-7.5/media/ffmpeg/",
                "xeone3-ubuntu1804-media-ffmpeg" : "XeonE3/ubuntu-18.04/media/ffmpeg/",
                "xeone3-ubuntu1604-media-ffmpeg" : "XeonE3/ubuntu-16.04/media/ffmpeg/",
                "xeone3-centos74-media-ffmpeg" : "XeonE3/centos-7.4/media/ffmpeg/",
                "xeone3-centos76-media-ffmpeg" : "XeonE3/centos-7.6/media/ffmpeg/",
                "xeon-centos75-media-ffmpeg" : "Xeon/centos-7.5/media/ffmpeg/",
                "xeon-centos75-media-dev" : "Xeon/centos-7.5/media/dev/",
                "xeon-ubuntu1804-media-ffmpeg" : "Xeon/ubuntu-18.04/media/ffmpeg/",
                "xeon-ubuntu1804-media-dev" : "Xeon/ubuntu-18.04/media/dev/",
                "xeon-ubuntu1604-media-ffmpeg" : "Xeon/ubuntu-16.04/media/ffmpeg/",
                "xeon-ubuntu1604-media-dev" : "Xeon/ubuntu-16.04/media/dev/",
                "xeon-centos74-media-ffmpeg" : "Xeon/centos-7.4/media/ffmpeg/",
                "xeon-centos74-media-dev" : "Xeon/centos-7.4/media/dev/",
                "xeon-centos76-media-ffmpeg" : "Xeon/centos-7.6/media/ffmpeg/",
                "xeon-centos76-media-dev" : "Xeon/centos-7.6/media/dev/",
                "vca2-centos75-media-ffmpeg" : "VCA2/centos-7.5/media/ffmpeg/",
                "vca2-ubuntu1804-media-ffmpeg" : "VCA2/ubuntu-18.04/media/ffmpeg/",
                "vca2-ubuntu1604-media-ffmpeg" : "VCA2/ubuntu-16.04/media/ffmpeg/",
                "vca2-centos74-media-ffmpeg" : "VCA2/centos-7.4/media/ffmpeg/",
                "vca2-centos76-media-ffmpeg" : "VCA2/centos-7.6/media/ffmpeg/"
                }

#OS subs to their version detail 
os_subs = {
                "centos-7.4" : "CentOS-7.4.1708",
                "centos-7.5" : "CentOS-7.5.1804",
                "centos-7.6" : "CentOS-7.6.1810",
                "ubuntu-16.04" : "Ubuntu 16.04",
                "ubuntu-18.04" : "Ubuntu 18.04"
          }

#included components links
included_subs = {
                "nginx" : ["[NGINX](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/doc/nginx.md)"],
                "svt" : ["[SVT](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/doc/svt.md)"],
                "owt" : ["[OWT](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/doc/owt.md)"],
                "owt-immersive" : ["[OWT-Immersive](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/doc/owt-immersive.md)"],
                "ospray" : ["[OSPRay](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/doc/ospray.md)"],
                "ospray-mpi" : ["[OSPRay-MPI](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/doc/ospray-mpi.md)"],
                "ffmpeg" : ["[FFmpeg](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/doc/ffmpeg.md)"],
                "gst" : ["[GStreamer](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/doc/gst.md)"],
                "dev" : ["[FFmpeg](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/doc/ffmpeg.md)","[GStreamer](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/doc/gst.md)"]
                }

# License to be included based on m4 templates
license_subs = {
                "dav1d" : ["|dav1d|BSD 2-clause \"Simplified\" License|"],
                "dldt-ie" : ["|DLDT|Apache License v2.0|"],
                "embree" : ["|embree|Apache License 2.0|"],
                "ffmpeg" : ["|FFmpeg|GNU Lesser General Public License v2.1 or later|"],
                "ffmpeg-n4.1" : ["|FFmpeg|GNU Lesser General Public License v2.1 or later|"],
                "gmmlib" : ["|Intel Graphics Memory Management Library| MIT License|"],
                "gst" : ["|gstreamer|GNU Lesser General Public License v2.1 or later|"],
                "gst-orc" : ["|gst orc|GNU Lesser General Public License v2.1 or later|"],
                "gst-plugin-base" : ["|gst plugin base|GNU Lesser General Public License v2.1 or later|"],
                "gst-plugin-bad" : ["|gst plugin bad|GNU Lesser General Public License v2.1 or later|"],
                "gst-plugin-good" : ["|gst plugin good|GNU Lesser General Public License v2.1 or later|"],
                "gst-plugin-libav" : ["|gst plugin libav|GNU Lesser General Public License v2.1 or later|"],
                "gst-plugin-svt" : ["|gst plugin svt|GNU Lesser General Public License v2.1 or later|"],
                "gst-plugin-ugly" : ["|gst plugin ugly|GNU Lesser General Public License v2.1 or later|"],
                "gst-plugin-vaapi" : ["|gst plugin vaapi|GNU Lesser General Public License v2.1 or later|"],
                "gstreamer-videoanalytics" : ["|gst video analytics|MIT License|"],
                "ispc" : ["|ispc|BSD 3-clause License|"],
                "libaom" : ["|Aomedia AV1 Codec Library|BSD 2-clause \"Simplified\" License|"],
                "libdrm" : ["|libdrm|MIT license|"],
                "libjsonc" : ["|json-c|MIT License|"],
                "libnice014" : ["|libnice|GNU Lesser General Public License|"],
                "libogg" : ["|libogg|BSD 3-clause \"New\" or \"Revised\" License|"],
                "libopus" : ["|Opus Interactive Audio Codec|BSD 3-clause \"New\" or \"Revised\" License|"],
                "librdkafka" : ["|librdkafka|BSD 2-clause \"Simplified\" License|"],
                "libre" : ["|libre|BSD 3-clause License|"],
                "libsrtp2" : ["|libsrtp2|BSD 3-clause License|"],
                "libva" : ["|Intel libva| MIT License"],
                "libvorbis" : ["|libvorbis|BSD 3-clause \"New\" or \"Revised\" License|"],
                "libvpx" : ["|libvpx|BSD 3-clause \"New\" or \"Revised\" License|"],
                "libx264" : ["|x264|GNU General Public License v2.0 or later|"],
                "libx265" : ["|x265|GNU General Public License v2.0 or later|"],
                "media-driver" : ["|Intel media-driver | MIT License|"],
                "media-sdk" : ["|Intel media SDK|MIT License|"],
                "nginx-http-flv" : ["|NGINX_HTTP_FLV|BSD 2-clause \"Simplified\" License|"],
                "nginx" : ["|NGINX|BSD 2-clause \"Simplified\" License|"],
                "nginx-qat" : ["|asynch_mode_nginx |BSD 3-clause \"New\" or \"Revised\" License|"],
                "nginx-upload" : ["|NGINX_Upload_Module|BSD 3-clause \"Simplified\" License|"],
                "nodetools" : ["|nodejs| MIT Open Source License|"],
                "opencl" : ["|intel-opencl | MIT License|"],
                "opencv" : ["|opencv|BSD 3-clause \"New\" or \"Revised\" License|"],
                "OpenImageIO" : ["|oiio|BSD 3-clause License|,|openexr|BSD 3-clause \"New\" or \"Revised\" License|"],
                "openssl" : ["|openssl|Apache License 2.0|"],
                "openvino.binary" : ["|OpenVINO|End User License Agreement for the Intel(R) Software Development Products|"],
                "ospray" : ["|ospray|Apache License v2.0|"],
                "ospray-mpi" : ["|ospray|Apache License v2.0|"],
                "owt-immersive" : ["|owt-server|Apache License v2.0|","|owt-sdk|Apache License v2.0|","|owt-deps-webrtc|BSD 3-clause License|"],
                "owt" : ["|owt-server|Apache License v2.0|","|owt-sdk|Apache License v2.0|","|owt-deps-webrtc|BSD 3-clause License|"],
                "qat-engine" : ["|qat-engine|BSD 3-clause \"New\" or \"Revised\" License|"],
                "qat-openssl" : ["|openssl|Apache License 2.0|"],
                "qat-zip" : ["|qat-zip|BSD 3-clause \"New\" or \"Revised\" License|"],
                "svt-av1" : ["|Intel SVT-AV1|BSD-2-Clause Plus Patent License|"],
                "svt-hevc.1-3-0" : ["|Intel SVT-HEVC|BSD-2-Clause Plus Patent License|"],
                "svt-hevc" : ["|Intel SVT-HEVC|BSD-2-Clause Plus Patent License|"],
                "svt-vp9" : ["|Intel SVT-VP9|BSD-2-Clause Plus Patent License|"],
                "usrsctp" : ["|usrsctp|BSD 3-clause \"New\" or \"Revised\" License|"]
               }

# M4 files for which no license is needed
license_exclude = ['automake', 'build-tools', 'cleanup', 'cmake', 'install', 'install.pkgs', 'install.pkgs.owt', 'libfdk-aac', 'libmp3lame', 'nasm', 'nginx-cert', 'nginx-conf', 'qat', 'transform360', 'yasm', 'libva-utils', 'ospray-example_san-miguel', 'ospray-example_xfrog']

# Walk through the repo and find folder with Dockerfiles.m4
def walk_path(path):
    for root, dirs, files in os.walk(path):
        for my_file in files:
            if ( my_file == 'Dockerfile.m4' ):
                path_components = parse_ingredients(root)
                create_readme(root, path_components)

# Find image platform / OS / image type / image name from file path
def parse_ingredients(path):
    path_components = path.split('/')
    image_name = path_components[-1]
    image_type = path_components[-2]
    image_os = path_components[-3]
    image_platform = path_components[-4]
    return [image_platform, image_os, image_type, image_name]

#method that generates URL placeholder for link to DOckerfiles
def url_generator(local_path, image_name, image_type, image_os, image_platform):
    url = ' - ['+image_platform.lower()+'-'+image_os.lower().replace('.','')+'-'+image_type.lower()+'-'+image_name.lower()+']('+REPO_LINK+local_path.split('Dockerfiles/')[1]+'/Dockerfile'+')'
    return url

# Generate links to docs of included components
def included_components(image_name):
    included_holder = ''
    for comp in included_subs[image_name]:
        included_holder += comp
        included_holder += '\t'
    return included_holder
    
# Generate quick reference part of README
def quick_reference(local_path, image_name, image_type, image_os, image_platform):
    text_holder = "## Quick reference\n"
    text_holder += "- #### Supported platform and OS\n"
    text_holder += "Intel&reg; "+platform_subs[image_platform]+", "+os_subs[image_os]
    text_holder += "\n\n"
    text_holder += "- #### Included components:\n"
    text_holder += included_components(image_name)
    text_holder += "\n\n"
    text_holder +="""
- #### Where to get help:
- [Open Visual Cloud Dockerfiles Github](https://github.com/OpenVisualCloud/Dockerfiles)
- [Getting Started With Open Visual Cloud Docker Files](https://01.org/openvisualcloud/documents/get-started-docker)
- [the Docker Community Forums](https://forums.docker.com)
- [the Docker Community Slack](https://www.docker.com/docker-community)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/docker)

-  #### Where to file issues:
[OpenVisualCloud Dockerfiles Issues](https://github.com/OpenVisualCloud/Dockerfiles/issues)

- #### Maintained by:
[OpenVisualCloud Dockerfiles Community](https://github.com/OpenVisualCloud/Dockerfiles/graphs/contributors)
"""
    text_holder += "\n\n"
    return text_holder

# Populate license info based on if the image is based of another image
def inheritance_populate(handler_list, inherited_file_path):
    inherited_entry_holder = ''
    with open(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))+'/'+inherited_file_path+'/Dockerfile.m4', 'r') as fh:
        line = fh.readline()
        while line:
            if 'm4' in line:
                m = re.search('[a-zA-Z0-9\-\.\_]+.m4', line)
                if m:
                    handler = (m.group(0).split('.m4')[0])
                    if handler not in license_exclude and handler not in handler_list:
                        for license_entry in license_subs[handler]:
                            inherited_entry_holder += license_entry
                            inherited_entry_holder += '\n'
            line = fh.readline()
    return inherited_entry_holder

# Parse M4 to populate license info
def parse_m4(local_path):
    entry_holder = ''
    os_flag = False
    ovc_inheritance_flag = False
    handler_list = []
    with open(local_path+'/Dockerfile.m4', 'r') as fp:
        line = fp.readline()
        while line:
            if 'FROM' in line:
                if 'FROM ubuntu' in line and not os_flag:
                    entry_holder += '|Ubuntu| [Various](https://hub.docker.com/_/ubuntu) |'
                    entry_holder += '\n'
                    os_flag = True
                elif 'FROM centos' in line and not os_flag:
                    entry_holder += '|CentOS| [Various](https://hub.docker.com/_/centos) |'
                    entry_holder += '\n'
                    os_flag = True
                elif 'FROM openvisualcloud' in line and not ovc_inheritance_flag:
                    inherited_file = line.split('/')[1].split(':')[0]
                    entry_holder += inheritance_populate(handler_list, path_subs[inherited_file])
                    ovc_inheritance_flag = True
            if 'm4' in line:
                m = re.search('[a-zA-Z0-9\-\.\_]+.m4', line)
                if m:
                    handler = (m.group(0).split('.m4')[0])
                    handler_list.append(handler)
                    if handler not in license_exclude:
                        for license_entry in license_subs[handler]:
                            entry_holder += license_entry
                            entry_holder += '\n'
            line = fp.readline()
    return entry_holder

# Main method
def generate_license(local_path, image_name, image_type, image_os, image_platform):
    text_holder = """## License
This docker installs third party components licensed under various open source licenses.  The terms under which those components may be used and distributed can be found with the license document that is provided with those components.  Please familiarize yourself with those terms to ensure your distribution of those components complies with the terms of those licenses.\n\n
"""
    text_holder += "| Components | License |\n"
    text_holder += "| ----- | ----- |\n"
    text_holder += parse_m4(local_path) 
    text_holder += "\n\n"
    text_holder += """More license information can be found in [components source package](https://github.com/OpenVisualCloud/Dockerfiles-Resources).   
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses and potential fees for all software contained within. We will have no indemnity or warranty coverage from suppliers.
"""
    return text_holder

def create_readme(path, path_components):
    my_file = open(path+"/README.md","w")
    my_file.write("This docker image is part of Open Visual Cloud software stacks. ")
    image_name = path_components[3]
    image_type = path_components[2]
    image_os = path_components[1]
    image_platform = path_components[0]
    
    if image_platform=="QAT":
        my_file.write("Optimized for NGINX web server with compute-intensive operations acceleration with Intel® QuickAssist Technology (Intel® QAT).The docker image can be used in the FROM field of a downstream Dockerfile.")
    elif image_name=="dev":
        my_file.write("This is development image aim towards  enabling C++ application compilation, debugging (with the debugging, profiling tools) and optimization (with the optimization tools.) You can compile C++ applications with this image and then copy the applications to the corresponding deployment image. ")
        if image_type=="analytics":
            my_file.write("Included what are in the FFmpeg image. Inferencing engine and tracking plugins to be included, also included Intel hardware accelaration software stack such as media driver, media SDK, gmmlib, OpenVINO and libva. ")
        elif image_type=="media":
            my_file.write("Image for FFmpeg or GStreamer C++ application development for Media creation and media delivery. ")
        elif image_type=="graphics":
            my_file.write("This image is for Intel OSPRay C++ application development. ")
        my_file.write("The docker image can be used in the FROM field of a downstream Dockerfile. ")
    elif image_type=="analytics":
        my_file.write("Optimized for Media Analytics. ")
        if image_name=="gst":
            my_file.write("Included what are in the GStreamer image. Inferencing engine and tracking plugins to be included, also included Intel hardware accelaration software stack such as media driver, media SDK, OpenVINO, gmmlib and libva. The docker image can be used to invoke gstreamer commands or be used in the FROM field of a downstream Dockerfile. ")
        if image_name=="ffmpeg":
            my_file.write("Included what are in the FFmpeg image. Inferencing engine and tracking plugins to be included, also included Intel hardware accelaration software stack such as media driver, media SDK, gmmlib, OpenVINO and libva.	The docker image can be used to invoke FFmpeg commands or be used in the FROM field of a downstream Dockerfile. ")
    elif image_type=="media":
        my_file.write("Optimized for the media creation and delivery use case. ")
        if image_name=="gst":
            my_file.write("Included gstreamer and audio and video plugins that can be connected to process audio and video content, such as creating, converting, transcoding. The docker image can be used to invoke gstreamer commands or be used in the FROM field of a downstream Dockerfile. ")
        if image_name=="ffmpeg":
            my_file.write("Included FFmpeg and codecs such as aac, opus, ogg, vorbis, x264, x265, vp8/9, av1 and SVT-HEVC, also included Intel hardware accelaration software stack such as media driver, media SDK, gmmlib and libva. The docker image can be used to invoke FFmpeg commands or be used in the FROM field of a downstream Dockerfile. ")
        if image_name=="nginx":
            my_file.write("Optimized for NGINX web server that can be used for serving web content, load balancing, HTTP caching, or a reverse proxy. The docker image can be used in the FROM field of a downstream Dockerfile. ")
        if image_name=="svt":
            my_file.write("Image with SVT (Scalable Video Technology) Encoder and decoders. Ready to use SVT apps to try AV1, HEVC, VP9 transcoders. The docker image can be used in the FROM field of a downstream Dockerfile. ")
    elif image_type=="service":
        my_file.write("Optimized for for video conferencing service based on the WebRTC technology and Open WebRTC Toolkit (OWT). ")
        if image_name=="owt":
            my_file.write("Optimized for for video conferencing service based on the WebRTC technology and Open WebRTC Toolkit (OWT). Included conferencing modes: 1:N, N:N with video and audio processing nodes, also included Intel hardware accelaration software stack such as media driver, media SDK, gmmlib and libva. ")
        if image_name=="owt-immersive":
            my_file.write("Docker image optimized for ultra-high resolution immersive video low latency streaming, based on the WebRTC technology and the Open WebRTC Toolkit. Included SVT-HEVC tile-based 4K and 8K transcoding and field of view (FoV) adaptive streaming. ")
        my_file.write("The docker image can be used in the FROM field of a downstream Dockerfile. ")
    elif image_type=="graphics":
        if image_name=="ospray":
            my_file.write("Docker images optimized for Intel OSPRay. Included the Intel OSPRay ray tracing engine and examples. ")
        if image_name=="ospray-mpi":
            my_file.write("Docker images optimized for Intel OSPRay and multi-host connections. Included the Intel OSPRay ray tracing engine with multi-host connections via MPI. ")
        my_file.write("The docker image can be used in the FROM field of a downstream Dockerfile. ")

    my_file.write("\n\n")
    my_file.write("## Supported tags and respective Dockerfile links\n")
    my_file.write(url_generator(path, image_name, image_type, image_os, image_platform))
    my_file.write("\n\n")
    my_file.write(quick_reference(path, image_name, image_type, image_os, image_platform))
    my_file.write(generate_license(path, image_name, image_type, image_os, image_platform))
    my_file.close()

def main():
    walk_path(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

if __name__ == "__main__":
    main()
