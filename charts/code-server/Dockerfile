# docker build -t dev:gradle .

FROM maven:3.8.6-openjdk-18-slim

RUN apt-get update && apt-get install -y net-tools iproute2 dnsutils iputils-ping openssh-server zsh git vim tmux jq netcat neovim wget unzip

RUN curl -LO "https://github.com/rancher/rke/releases/download/v1.3.15/rke_linux-amd64"
RUN chmod 755 rke_linux-amd64 && mv rke_linux-amd64 /usr/local/bin/rke

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN chmod 755 kubectl && mv kubectl /usr/local/bin
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

RUN curl -LO "https://github.com/tektoncd/cli/releases/download/v0.28.0/tektoncd-cli-0.28.0_Linux-64bit.deb"
RUN dpkg -i tektoncd-cli-0.28.0_Linux-64bit.deb && rm tektoncd-cli-0.28.0_Linux-64bit.deb

RUN apt-get install -y ca-certificates gnupg lsb-release
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get install -y docker-ce-cli
RUN rm -rf /var/lib/apt/lists/*
RUN curl -LO  "https://services.gradle.org/distributions/gradle-7.6-bin.zip"

RUN mkdir /opt/gradle && unzip -d /opt/gradle gradle-7.6-bin.zip

ENV PATH=$PATH:/opt/gradle/gradle-7.6/bin

RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.zsh/powerlevel10k

RUN echo 'source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
RUN echo 'source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh' >>~/.zshrc
RUN echo 'source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >>~/.zshrc
RUN echo 'POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true' >>~/.zshrc

RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'root:1' | chpasswd

WORKDIR /root

ENTRYPOINT ["/usr/bin/zsh"]
