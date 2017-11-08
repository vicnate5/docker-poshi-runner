FROM java:8

RUN apt-get update

# Install Ant
RUN apt-get --assume-yes install ant
ENV ANT_OPTS -Xmx2048m -Xms2048m -XX:MaxPermSize=512m

# Install Firefox
RUN wget https://ftp.mozilla.org/pub/firefox/releases/45.0.1esr/linux-x86_64/en-US/firefox-45.0.1esr.tar.bz2
RUN tar -xjvf firefox-45.0.1esr.tar.bz2
RUN mv firefox/ /usr/lib/firefox/
RUN ln -s /usr/lib/firefox/firefox /usr/bin/firefox
RUN firefox -version

# Setting up headless screen
RUN apt-get --assume-yes install Xvfb
RUN apt-get --assume-yes install libxtst6
ENV DISPLAY :99
RUN (echo "Xvfb :99 -screen 0 1680x1050x16 &> xvfb.log &" ; echo "echo 'Virtual Screen Created'") >> /run.sh
RUN chmod a+x /run.sh