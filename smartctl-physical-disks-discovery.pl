#!/usr/bin/perl

#zabbix config: 
#		EnableRemoteCommands=1
#               AllowRoot=1
#               Include=/etc/zabbix/zabbix_agentd.d/*.conf

#apt-get install smartmontools

#cpan install JSON
#cpan install Data::Dumper

#Configuration->Templates->smartmoontools->Discovery->smartctl-physical-disks-discovery

use strict;
use warnings;
use JSON qw(encode_json decode_json);

#for debug
#use Data::Dumper;

my @DISKS;

    get_disks();

if (scalar @DISKS != 0)
{
    my $count = scalar @DISKS;

    print_data();
}

#======================================================================================
sub print_data
{
    #Don't use, because => 'TERM environment variable not set'
    #system('clear');

    my %data;

    foreach my $count (0..scalar @DISKS-1)
    {
        #General information
	my $device_model = get_device_model($DISKS[$count]);
        my $serial_number = get_serial_number($DISKS[$count]);
        my $model_family = get_model_family($DISKS[$count]);
        my $firmware_version = get_firmware_version($DISKS[$count]);
        my $rotation_rate = get_rotation_rate($DISKS[$count]);
        my $form_factor = get_form_factor($DISKS[$count]);

        #General information
	$data{'data'}[$count]{'{#DISKCOUNT}'} = $count+1;
	$data{'data'}[$count]{'{#DISKNAME}'} = $DISKS[$count];
	$data{'data'}[$count]{'{#DEVICEMODEL}'} = $device_model;
        $data{'data'}[$count]{'{#SERIALNUMBER}'} = $serial_number;
        $data{'data'}[$count]{'{#MODELFAMILY}'} = $model_family;
        $data{'data'}[$count]{'{#FIRMWAREVERSION}'} = $firmware_version;
        $data{'data'}[$count]{'{#ROTATIONRATE}'} = $rotation_rate;
        $data{'data'}[$count]{'{#FORMFACTOR}'} = $form_factor;
    }

    my $data_json = encode_json(\%data);

    print $data_json;
}

#======================================================================================
sub get_disks
{
    #smartctl --scan
    open(my $temp, '-|', 'smartctl --scan') or die $!;

    while (my $line = <$temp>)
    {
	my @chunks = split ' ', $line;
	$DISKS[++$#DISKS] = $chunks[0];
    }
}

#======================================================================================
sub do_smartctl_info
{
    #get information about disk: smartctl -i /dev/sda

    my ($disk, $field, $cut) = @_;

    my @temp = `smartctl -i $disk | grep "$field" | cut -c$cut- | tr -d " \t\n\r"`;

    return $temp[0];
}

#======================================================================================
sub get_device_model
{
    my $disk = shift;

    my $result = do_smartctl_info($disk, 'Device Model', 14);

    return $result;
}

#======================================================================================
sub get_serial_number
{
    my $disk = shift;

    my $result = do_smartctl_info($disk, 'Serial Number', 18);

    return $result;
}

#======================================================================================
sub get_model_family
{
    my $disk = shift;

    my $result = do_smartctl_info($disk, 'Model Family', 18);

    return $result;
}

#======================================================================================
sub get_firmware_version
{
    my $disk = shift;

    my $result = do_smartctl_info($disk, 'Firmware Version', 18);

    return $result;
}

#======================================================================================
sub get_rotation_rate
{
    my $disk = shift;

    my $result = do_smartctl_info($disk, 'Rotation Rate', 18);

    return $result;
}

#======================================================================================
sub get_form_factor
{
    my $disk = shift;

    my $result = do_smartctl_info($disk, 'Form Factor', 18);

    return $result;
}
