//
//  NSString+Utilities.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 12/28/12.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Loading)

+ (NSString*)sizeInComputerUnit:(unsigned long long)size;

+ (NSString*)remainingTimeForLoadingWithTotalBytes:(unsigned long long)totalBytes
										movedBytes:(unsigned long long)movedBytes
									startTimestamp:(NSDate*)startTimestamp;

+ (NSString*)loadingSpeedWithMovedBytes:(unsigned long long)movedBytes startTimestamp:(NSDate*)startTimestamp;

@end

@interface NSString (C)

NSString* NSStringFromBOOL(BOOL boolValue);

@end


/*!
 @class NSString extension
 */
@interface NSString (UUID)

/*!
 @property generateUUID
 @return return an unique id
 */
+ (NSString*)generateUUID;

@end

@interface NSData (Utilities)

- (NSString*)stringValue;

@end
