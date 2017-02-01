#!/usr/bin/perl

#apt-get install smartmontools
#./smartctl-physical-disks-data.pl --d /dev/sda --k Temperature_Celsius
#perl /etc/zabbix/zabbix_agentd.d/smartctl-physical-disks-data.pl --d /dev/sda --k Temperature_Celsius
#perl /etc/zabbix/zabbix_agentd.d/smartctl-physical-disks-data.pl --d /dev/sda --k Overall_Health

use strict;
use warnings;
use Getopt::Long;
use 5.010;
no warnings 'experimental';

my $DISK;
my $KEY;

    main();

#======================================================================================
sub parse_argv
{
    GetOptions ('d=s' => \$DISK, 'k=s' => \$KEY);
}

#======================================================================================
sub do_smartctl_smart
{
    #get smart attributes: smartctl -A /dev/sda
    #smartctl -A /dev/sda | grep Temperature_Celsius | awk '{print $10}'

    my ($disk, $field) = @_;
    my $column = 10;

    my $result = `smartctl -A $disk | grep "$field" | awk '{print \$($column)}'`;

    return $result;
}

#======================================================================================
sub get_temperature_celsius
{
    my $disk = shift;

    my $result = do_smartctl_smart($disk, 'Temperature_Celsius');

    return $result;
}

#======================================================================================
sub get_power_cycle_count
{
    my $disk = shift;

    my $result = do_smartctl_smart($disk, 'Power_Cycle_Count');

    return $result;
}

#======================================================================================
sub get_reallocated_sector_st
{
    my $disk = shift;

    my $result = do_smartctl_smart($disk, 'Reallocated_Sector_Ct');

    return $result;
}

#======================================================================================
sub get_start_stop_count
{
 my $disk = shift;

    my $result = do_smartctl_smart($disk, 'Start_Stop_Count');

    return $result;
}

#======================================================================================
sub get_raw_read_error_rate
{
    my $disk = shift;

    my $result = do_smartctl_smart($disk, 'Raw_Read_Error_Rate');

    return $result;
}

#======================================================================================
sub get_seek_error_rate
{
    my $disk = shift;

    my $result = do_smartctl_smart($disk, 'Seek_Error_Rate');

    return $result;
}

#======================================================================================
sub get_spin_up_time
{
    my $disk = shift;

    my $result = do_smartctl_smart($disk, 'Spin_Up_Time');

    return $result;
}

#======================================================================================
sub get_spin_retry_count
{
    my $disk = shift;

    my $result = do_smartctl_smart($disk, 'Spin_Retry_Count');

    return $result;
}

#======================================================================================
sub get_power_off_retract_count
{
    my $disk = shift;

    my $result = do_smartctl_smart($disk, 'Power-Off_Retract_Count');

    return $result;
}

#======================================================================================
sub get_load_cycle_count
{
    my $disk = shift;

    my $result = do_smartctl_smart($disk, 'Load_Cycle_Count');

    return $result;
}

#======================================================================================
sub get_current_pending_sector
{
    my $disk = shift;

    my $result = do_smartctl_smart($disk, 'Current_Pending_Sector');

    return $result;
}

#======================================================================================
sub get_udma_crc_error_count
{
    my $disk = shift;

    my $result = do_smartctl_smart($disk, 'UDMA_CRC_Error_Count');

    return $result;
}

#======================================================================================
sub get_overall_health
{
    #for example: smartctl -H /dev/sda | grep -Eio 'PASSED|FAIL'
    my $disk = shift;

    my $result = `smartctl -H $disk | grep -Eio 'PASSED|FAIL'`;

    return $result;
}

#======================================================================================
sub main
{
    parse_argv();

    given ($KEY)
    {
	when ($_ eq 'Temperature_Celsius')
	{
	    print get_temperature_celsius($DISK);
	}
	when ($_ eq 'Power_Cycle_Count')
	{
            print get_power_cycle_count($DISK);
	}
	when ($_ eq 'Reallocated_Sector_Ct')
	{
            print get_reallocated_sector_st($DISK);
	}
	when ($_ eq 'Start_Stop_Count')
	{
            print get_start_stop_count($DISK);
	}
	when ($_ eq 'Raw_Read_Error_Rate')
	{
            print get_raw_read_error_rate($DISK);
	}
	when ($_ eq 'Seek_Error_Rate')
	{
            print get_seek_error_rate($DISK);
	}
	when ($_ eq 'Spin_Up_Time')
	{
            print get_spin_up_time($DISK);
	}
	when ($_ eq 'Spin_Retry_Count')
	{
            print get_spin_retry_count($DISK);
	}
	when ($_ eq 'Power-Off_Retract_Count')
	{
            print get_power_off_retract_count($DISK);
	}
	when ($_ eq 'Load_Cycle_Count')
	{
            print get_load_cycle_count($DISK);
	}
	when ($_ eq 'Current_Pending_Sector')
	{
            print get_current_pending_sector($DISK);
	}
	when ($_ eq 'UDMA_CRC_Error_Count')
	{
            print get_udma_crc_error_count($DISK);
	}
	when ($_ eq 'Overall_Health')
	{
            print get_overall_health($DISK);
	}
    }
}
