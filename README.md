# Zabbix smartmontools
you need to install:
- apt-get install smartmontools
- cpan install JSON
- cpan install Data::Dumper (for Debug)

and change the keys in the configuration file:

- EnableRemoteCommands=1
- AllowRoot=1
- Include=/etc/zabbix/zabbix_agentd.d/*.conf

for check:

```shell
#perl smartctl-physical-disks-discovery.pl
#perl smartctl-physical-disks-data.pl --d /dev/sda --k Temperature_Celsius
```

![example](https://cloud.githubusercontent.com/assets/12140221/23781986/87cfdc8c-0583-11e7-9b0d-7f0981a0bf89.PNG)
