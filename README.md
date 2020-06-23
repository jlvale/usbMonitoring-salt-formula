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

2. Then, create an .tar of the grok exporter directory `tar cfv grok_exporter-1.0.0.tar grok_exporter-1.0.0.RC3.linux-amd64/` and export it to the Salt master (in my case it's a SUSE Manager server).

3. In the salt master server: `cd /srv/salt`
  3. `mkdir grok-exporter` and `cd grok-exporter/` 
  3. Create the salt formula: `vim init.sls` with the following content from [init.sls](https://github.com/jlvale/usbMonitoring-salt-formula/blob/master/salt/grok-exporter/init.sls).
  
  3. `mkdir /files` inside the grok-exporter directory and `mv {grok-exporter}.tar ` created in step 2 to this directory.
  
4. This step contains the needed metadata for using the graphical web interface of SUSE Manager, so if you are just using a common salt-master you don´t need to repeat these next steps. 

        cd /srv/formula_metada
        mkdir grok-exporter
        
      `mv` the files from [here](https://github.com/jlvale/usbMonitoring-salt-formula/tree/master/formula_metadata/grok-exporter) to the created directory.

5. `spacewalk-service restart` and you should be able to apply the created formula to any minion. After the formula is applied the minion should be exposing metrics about the connected USB-devices in the default port 9144. 

6. After this you should configure your Prometheus instance do scrape those metrics and your Grafana instance to plot them. 
