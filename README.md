# usbMonitoring-salt-formula
Salt Formula for monitoring USBs

This salt formula uses Grok Exporter (https://github.com/fstab/grok_exporter) and the Linux command *usb-devices* to export connected USBs devices as metrics to be monitored using Prometheus and Grafana. Beyond that, the formula is implemented to be used with SUSE Manager to be applied directly into the salt-minions through the web interface.

# Step by step 

1. First you need to download the latest release of Grok Exporter, extract it, and create the following config file (inside the /examples directory): 

        global:
          config_version: 3
        input:
          type: file #stdin not working yet 
          path: ./example/usb_devices.log #path to the log file to be monitored 
          readall: true
        grok_patterns:
        - 'DEVICE [^=]*$'
        metrics:
        - type: counter
          name: dispositivos_usb_conectados
          help: Exibe se um dispositivo USB está conectado ou não
          match: '%{DEVICE:device}'
          cumulative: false
          labels:
              dispositivo: '{{.device}}'
        server:
          protocol: http
          port: 9144

2. Then, create an .tar of the grok exporter directory and export it to the Salt master (in my case it's a SUSE Manager server).

3. In the salt master server: `cd /srv/salt`
  3. `mkdir grok-exporter` and `cd grok-exporter/` 
  3. Create the salt formula: `vim init.sls` with the following content:

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
  
  3. `mkdir /files` inside the grok-exporter directory and `mv .tar ` created in step 2
  
4. This step contains the needed metadata for using the graphical web interface of SUSE Manager, so if you are just using a common salt-master you don´t need to repeat these next steps. 

cd /srv/formula_metada
mkdir grok-exporter
