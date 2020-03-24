{% set config = pillar.get('nginx',{})%}


install rpms:
  cmd.run:
    - name: yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
install epel:
  cmd.run:
    - name: yum -y install epel-release yum-utils
install php73:
 cmd.run:
    - name: yum-config-manager --enable remi-php73
php.packages:
  pkg.installed:
    - pkgs:
      - nginx
      - php-fpm
      - php-cli
      - php-curl
copy config file:
  file.managed:
    - name: {{ config['config'] }}
    - source: salt://nginx/test.centos.conf
create forder www:
  file.directory:
    - user:  {{ config['user'] }}
    - name:  /var/www
    - group:  {{ config['user'] }}
    - mode:  755
create forder web:
  file.directory:
    - user:  {{ config['user'] }}
    - name:  {{ config['dir']}}
    - group:  {{ config['user'] }}
    - mode:  755
create forder log:
  file.directory:
    - user: {{ config['user'] }}
    - name: {{ config['log'] }}
    - group: {{ config['user'] }}
    - mode:  755
copy file index:
  file.managed:
    - name: {{ config['dir'] }}/index.php
{% if grains['os'] == 'Ubuntu' %}
    - source: salt://ubuntu/index.php
{% elif grains['os']== 'CentOS' %}
    - source: salt://centos/index.php
{% endif %}


