FROM garethflowers/svn-server
LABEL maintainer="karthrand"
ADD create.sh /home/create.sh
ADD config /home/config
RUN touch /home/flag
ENTRYPOINT /bin/sh /home/create.sh;/usr/bin/svnserve --daemon --foreground --root /var/opt/svn