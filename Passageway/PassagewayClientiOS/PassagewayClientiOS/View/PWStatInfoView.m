//
//  PWStatInfoView.m
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 4/2/13.
//  Copyright (c) 2013 mscodefactory. All rights reserved.
//

#import "PWStatInfoView.h"
#include <sys/sysctl.h>
#import <mach/mach.h>
#import <mach/mach_host.h>

double getFreeMemory()
{
	vm_statistics_data_t vmStats;
	mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
	kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
	
	if (kernReturn != KERN_SUCCESS)
	{
		return NSNotFound;
	}
	
	return (vm_page_size * vmStats.free_count);
}

double getInactiveMemory()
{
	vm_statistics_data_t vmStats;
	mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
	kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
	
	if (kernReturn != KERN_SUCCESS)
	{
		return NSNotFound;
	}
	
	return (vm_page_size * vmStats.inactive_count);
}

double getUsedMemory()
{
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
	
    if( kerr != KERN_SUCCESS )
	{
        return NSNotFound;
    }

	return info.resident_size;
}

NSString* sizeInComputerUnit(unsigned long long bytes)
{
    int c = 0;
	
	unsigned long long size = bytes;
    
    while ((size >> 10) > 0.0)
    {
        size = size >> 10;
        c++;
    }
    
    char prefix;
    
    switch (c) {
        case 0: prefix = '\0';
            break;
        case 1: prefix = 'K';
            break;
        case 2: prefix = 'M';
            break;
        case 3: prefix = 'G';
            break;
        case 4: prefix = 'T';
            break;
        default: prefix = '\0'; break;
    }
	
    return [NSString stringWithFormat:@"%.2f%cB", bytes / pow(1024.0, c), prefix];
}

@implementation PWStatInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)refresh
{
	_memoryFreeLabel.text		= [NSString stringWithFormat:@"%@", sizeInComputerUnit(getFreeMemory())];
	
	_memoryInactiveLabel.text	= [NSString stringWithFormat:@"%@", sizeInComputerUnit(getInactiveMemory())];
	
	_memoryUsedLabel.text		= [NSString stringWithFormat:@"%@", sizeInComputerUnit(getUsedMemory())];
}

- (void)start
{
	if (_refreshTimer)
	{
		[_refreshTimer invalidate];
		
		_refreshTimer = nil;
	}

	_refreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
}

- (void)stop
{
	[_refreshTimer invalidate];
	
	_refreshTimer = nil;
}

- (void)dealloc
{
	[self stop];
}

@end
