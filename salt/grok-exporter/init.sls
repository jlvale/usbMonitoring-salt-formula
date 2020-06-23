Extrair grok-exporter:
{% if salt['pillar.get']('grok_exporter:enabled', True) %}
  archive.extracted:
    - name: /etc/grok-exporter
    - source: salt://grok-exporter/files/grok_exporter-1.0.0.tar
    - user: root
    - group: root
    - mode: 644
Acrescentar job na cron:
  cron.present:
    - name: usb-devices | grep Product= > /etc/grok-exporter/grok_exporter-1.0.0.RC3.linux-amd64/example/usb_devices.log
    - identifier: Rotina de Log para registrar dispositivos conectados 
    - user: root 
Rodar Grok Exporter:
  cmd.run:
    - name: nohup ./grok_exporter -config ./example/config_usb_devices.yml &> /dev/null &
    - cwd: /etc/grok-exporter/grok_exporter-1.0.0.RC3.linux-amd64/
    - bgFalse: True
{% else %}
{% endif %}
