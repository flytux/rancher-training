# docker build -t 157.245.240.248:30005/kw/dev:v1 .


FROM maven:3.8.3-jdk-11-slim

RUN apt-get update && apt-get install -y net-tools iproute2 dnsutils iputils-ping openssh-server zsh git vim tmux jq netcat neovim

COPY bins/* /usr/local/bin/

COPY scripts/dev-shell.tgz  /root
RUN tar xvzf /root/dev-shell.tgz -C /root && rm /root/dev-shell.tgz

RUN apt-get install -y ca-certificates gnupg lsb-release

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update
RUN apt-get install -y docker-ce-cli
RUN rm -rf /var/lib/apt/lists/*

RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'root:1' | chpasswd

WORKDIR /root

ENTRYPOINT ["/usr/bin/zsh"]
