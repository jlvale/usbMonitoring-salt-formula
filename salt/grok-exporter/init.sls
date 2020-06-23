{% if salt['pillar.get']('grok_exporter:enabled', True) %}
  archive.extracted:
    - name: /etc/grok-exporter
    - source: salt://grok-exporter/files/grok_exporter-1.0.0.tar
    - user: root
    - group: root
    - mode: 644
Cron usb:
  cron.present:
    - name: usb-devices | grep Product= > /etc/grok-exporter/grok_exporter-1.0.0.RC3.linux-amd64/example/usb_devices.log
    - identifier: Rotina de Log para registrar dispositivos conectados
    - user: root
Cron grok:
  cron.present:
    - name: nohup ./grok_exporter -config ./example/config_usb_devices.yml &> /dev/null &
    - identifier: Rodar o grok exporter sempre que a máquina reiniciar
    - user: root
    - special: '@reboot'
  cmd.run:
    - name: nohup ./grok_exporter -config ./example/config_usb_devices.yml &> /dev/null &
    - cwd: /etc/grok-exporter/grok_exporter-1.0.0.RC3.linux-amd64/
    - bgFalse: True
{% else %}
{% endif %}
