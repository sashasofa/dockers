FROM nvcr.io/nvidia/pytorch:20.10-py3


ARG PYCHARM_VERSION=2020.3
ARG PYCHARM_BUILD=2020.3.2

USER root
RUN apt-get update && apt-get install --no-install-recommends -y \
#  python python-dev python-setuptools python-pip \
#  python3 python3-dev python3-setuptools python3-pip \
  gcc git openssh-client less curl \
  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
  libfontconfig1 libgtk2.0-0 libxslt1.1 libxxf86vm1 \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -ms /bin/bash developer

ARG pycharm_source=https://download.jetbrains.com/python/pycharm-community-${PYCHARM_BUILD}.tar.gz
ARG pycharm_local_dir=.PyCharmCE${PYCHARM_VERSION}

WORKDIR /opt/pycharm

RUN curl -fsSL $pycharm_source -o /opt/pycharm/installer.tgz \
  && tar --strip-components=1 -xzf installer.tgz \
  && rm installer.tgz

USER developer
ENV HOME /home/developer

#RUN useradd -m peter
#RUN chown -R peter:peter /home/peter
#COPY --chown=peter . /home/peter/app
COPY --chown=developer . /home/developer/app

#USER peter
RUN pip install kornia
RUN pip install wcmatch
RUN pip install pytorch_ranger
RUN pip install numpy==1.19.4
RUN pip install pillow==8.0.1

USER root
RUN git clone https://github.com/NVIDIA-AI-IOT/torch2trt
RUN cd torch2trt; python setup.py install

USER developer
RUN mkdir /home/developer/.PyCharm \
  && ln -sf /home/developer/.PyCharm /home/developer/$pycharm_local_dir

CMD [ "/opt/pycharm/bin/pycharm.sh" ]


##########################################################
# DOCKER BUILD
# docker build -t pytorch_pycharm .

##########################################################
# DOCKER RUN

#docker run --rm   -e DISPLAY=${DISPLAY}   \
#    -v /tmp/.X11-unix:/tmp/.X11-unix \
#    -v ~/.PyCharm:/home/developer/.PyCharm   \
#    -v ~/.PyCharm.java:/home/developer/.java  \
#    -v ~/.PyCharm.py2:/usr/local/lib/python2.6  \
#    -v ~/.PyCharm.py3:/usr/local/lib/python3.6   \
#    -v ~/.PyCharm.share:/home/developer/.local/share/JetBrains  \
#    -v ~/Project:/home/developer/Project  \
#    -v /home/peter/Downloads/patches_filtering:/home/developer/app \
#    --name pycharm-$(head -c 4 /dev/urandom | xxd -p)-$(date +'%Y%m%d-%H%M%S') \
#    --gpus all --shm-size=2g pytorch_pycharm:latest

 #docker exec -u 0 -it container /bin/bash  - get root acess to the container to install torch2trt
 # git clone https://github.com/NVIDIA-AI-IOT/torch2trt
 # cd torch2trt
 # python setup.py install








