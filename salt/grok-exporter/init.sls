{% if salt['pillar.get']('grok_exporter:enabled', True) %}

extract-grok:
  archive.extracted:
    - name: /etc/grok-exporter
    - source: salt://grok-exporter/files/grok_exporter-1.0.0.tar
    - user: root
    - group: root
    - mode: 644
    - archive_format: tar

cron-usb:
  cron.present:
    - name: usb-devices | grep Product= > /etc/grok-exporter/grok_exporter-1.0.0.RC3.linux-amd64/example/usb_devices.log
    - identifier: Rotina de Log para registrar dispositivos conectados
    - user: root

cron-grok:
  cron.present:
    - name: nohup /etc/grok-exporter/grok_exporter-1.0.0.RC3.linux-amd64/example/grok_exporter -config /etc/grok-exporter/grok_exporter-1.0.0.RC3.linux-amd64/example/config_usb_devices.yml &> /dev/null &
    - identifier: Rodar o grok exporter sempre que a maquina reiniciar
    - user: root
    - special: '@reboot'

run-grok:
  cmd.run:
    - name: nohup ./grok_exporter -config ./example/config_usb_devices.yml &> /dev/null &
    - cwd: /etc/grok-exporter/grok_exporter-1.0.0.RC3.linux-amd64/
    - bgFalse: True

{% else %}
{% endif %}
