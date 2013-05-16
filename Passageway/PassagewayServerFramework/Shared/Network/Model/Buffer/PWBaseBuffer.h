//
//  PWBaseBuffer.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 1/28/13.
//
//

#import <Foundation/Foundation.h>
#import "PWDelegateController.h"
#import "PWBaseBufferDelegate.h"
#import "PWBaseBufferHeader.h"

@interface PWBaseBuffer : NSObject
{
	NSMutableData* _buffer;
	
	PWDelegateController* _delegate;

	struct {
		unsigned int enableCompression:1;
	} __base_flag;
}

@property (nonatomic, strong) NSMutableData* buffer;

@property (nonatomic, strong) PWDelegateController* delegate;

#pragma mark - Class Methods

+ (PWBaseBuffer*)bufferWithDelegate:(id<PWBaseBufferDelegate>)delegate;

#pragma mark - Instance Methods

- (id)initWithDelegate:(id<PWBaseBufferDelegate>)delegate;

/** Abstract method */
- (void)disconnect;

#pragma mark - Packing Methods

/**
 @param data It is a raw data.
 @return Return a gzip compressed data with a packet header.
 */
- (NSMutableData*)packData:(NSData*)data;

/**
 @param data It is a row data.
 @param tag Packet header contains a tag property.
 @return Return a gzip compressed data with a packet header.
 */
- (NSMutableData*)packData:(NSData*)data withTag:(unsigned int)tag;

/**
 @param data It is a compressed data. :
 @param header It is a pointer to a PWBufferHeader variable.
 @return Return a gzip decompressed data without a packet header.
 */
- (NSMutableData*)unpackData:(NSData*)data intoHeader:(PWBufferHeader*)header;

@end
