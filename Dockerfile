FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar paquetes necesarios
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    && mkdir /var/run/sshd

# Crear usuario ansible
RUN useradd -m -s /bin/bash ansible && \
    echo "ansible:ansible" | chpasswd && \
    usermod -aG sudo ansible && \
    echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Configurar SSH
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    nginx \
    && mkdir /var/run/sshd

RUN useradd -m -s /bin/bash ansible && \
    echo "ansible:ansible" | chpasswd && \
    usermod -aG sudo ansible && \
    echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

EXPOSE 80

CMD service nginx start && /usr/sbin/sshd -D
