FROM centos:7
ENV container docker
MAINTAINER "Jordan Wamser" <jwamser@redpandacoding.com>

RUN yum -y update
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum -y install yum-utils
RUN yum-config-manager --enable remi-php72 && yum update -y

RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/mssql-release.repo

RUN ACCEPT_EULA=Y yum install -y msodbcsql mssql-tools unixODBC-devel
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN source ~/.bashrc
RUN yum install -y php \
               php-fpm \
               php-opcache \
               php-pdo \
               php-sqlsrv
RUN yum clean all

COPY ./etc/php.ini /etc/php.ini
COPY ./etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf
COPY ./etc/php.d/50-errlog.ini /etc/php.d/50-errlog.ini

#RUN ln -sf /dev/stderr /var/log/php-fpm/error.log

EXPOSE 9000

CMD ["php-fpm", "--allow-to-run-as-root", "--nodaemonize"]