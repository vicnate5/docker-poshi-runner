FROM openjdk:8-jdk

RUN apt-get update

# Install Ant

ENV ANT_OPTS -Xmx2048m -Xms2048m -XX:MaxPermSize=512m

RUN apt-get --assume-yes install ant

# Install Firefox

RUN apt-get --assume-yes install libdbus-glib-1-2 && \
	wget https://ftp.mozilla.org/pub/firefox/releases/45.0.1esr/linux-x86_64/en-US/firefox-45.0.1esr.tar.bz2 && \
	tar -xjvf firefox-45.0.1esr.tar.bz2 && \
	mv firefox/ /usr/lib/firefox/ && \
	ln -s /usr/lib/firefox/firefox /usr/bin/firefox && \
	firefox -version

# Setting up headless screen

ENV DISPLAY :99

RUN apt-get --assume-yes install xvfb libxtst6 && \
	(echo "Xvfb :99 -screen 0 1680x1050x16 &> xvfb.log &" ; echo "echo 'Virtual Screen Created'") >> /run.sh && \
	chmod a+x /run.sh