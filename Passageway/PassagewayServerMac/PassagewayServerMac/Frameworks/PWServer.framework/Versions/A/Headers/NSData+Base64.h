//
//  NSData+Base64.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/3/13.
//
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)

+ (NSData *) dataWithBase64EncodedString:(NSString *) string;
- (id) initWithBase64EncodedString:(NSString *) string;

- (NSString *) base64Encoding;
- (NSString *) base64EncodingWithLineLength:(NSUInteger) lineLength;

- (BOOL) hasPrefix:(NSData *) prefix;
- (BOOL) hasPrefixBytes:(const void *) prefix length:(NSUInteger) length;

- (BOOL) hasSuffix:(NSData *) suffix;
- (BOOL) hasSuffixBytes:(const void *) suffix length:(NSUInteger) length;


@end
