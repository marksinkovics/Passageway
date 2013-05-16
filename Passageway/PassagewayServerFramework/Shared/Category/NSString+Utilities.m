//
//  NSString+Utilities.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 12/28/12.
//
//

#import "NSString+Utilities.h"

@implementation NSString (Loading)

+ (NSString*)sizeInComputerUnit:(unsigned long long)size
{
    int c = 0;
    
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
	
    return [NSString stringWithFormat:@"%.2f%cB", (float)size, prefix];
}

+ (NSString*)remainingTimeForLoadingWithTotalBytes:(unsigned long long)totalBytes
										movedBytes:(unsigned long long)movedBytes
									startTimestamp:(NSDate*)startTimestamp
{
    NSTimeInterval dt = -[startTimestamp timeIntervalSinceNow];
    
    double speed = movedBytes / dt;
    
    unsigned long long remaining = totalBytes - movedBytes;
    
    unsigned long long remainingTime = (long long)(remaining / speed);
    
    unsigned long long hours = remainingTime / 3600;
    
    unsigned long long minutes = (remainingTime - hours * 3600) / 60;
    
    unsigned long long seconds = remainingTime - hours * 3600 - minutes * 60;
    
    return [NSString stringWithFormat:@"%llu:%llu:%llu", hours, minutes, seconds];
}

+ (NSString*)loadingSpeedWithMovedBytes:(unsigned long long)movedBytes startTimestamp:(NSDate*)startTimestamp
{
	NSTimeInterval dt = -[startTimestamp timeIntervalSinceNow];
    
    float speed = movedBytes / dt;

	return [NSString stringWithFormat:@"%@/s", [self sizeInComputerUnit:@(speed).unsignedLongLongValue]];
}

@end

@implementation NSString (C)

NSString* NSStringFromBOOL(BOOL boolValue)
{
	return boolValue ? @"YES" : @"NO";
}

@end


@implementation NSString (UUID)

+ (NSString*)generateUUID
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	
	CFRelease(theUUID);
	
	return [(NSString *)string autorelease];
}

@end


@implementation NSData (Utilities)

- (NSString*)stringValue
{
	NSString* str = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
	
	return [str autorelease];
}

@end