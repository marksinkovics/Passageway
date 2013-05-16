//
//  PWBaseBuffer.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 1/28/13.
//
//

#import "PWBaseBuffer.h"
#import "NSData+Compression.h"

@implementation PWBaseBuffer

@synthesize buffer		= _buffer;
@synthesize delegate	= _delegate;

#pragma mark - Class Methods

+ (PWBaseBuffer*)bufferWithDelegate:(id<PWBaseBufferDelegate>)delegate
{
	PWBaseBuffer* _buf = [[self alloc] initWithDelegate:delegate];
	
	return [_buf autorelease];
}

#pragma mark - Instance Methods

- (id)initWithDelegate:(id<PWBaseBufferDelegate>)delegate
{
    self = [super init];
	
    if (self)
	{
		self.delegate = [[[PWDelegateController alloc] initWithProtocol:@protocol(PWBaseBufferDelegate)] autorelease];
		
		[self.delegate addDelegate:delegate];
		
		__base_flag.enableCompression = YES;
    }
	
    return self;
}

#pragma mark - Memory Management

- (void)dealloc
{
    self.buffer = nil;
	
	self.delegate = nil;
	
    [super dealloc];
}

- (void)disconnect
{
	
}

- (NSMutableData*)packData:(NSData*)data
{
	return [self packData:data withTag:0];
}

- (NSMutableData*)packData:(NSData*)data withTag:(unsigned int)tag;
{
	NSMutableData* _data = nil;
	
	if (__base_flag.enableCompression)
	{
		_data = [NSMutableData dataWithData:[data gzipDeflate]];
	}
	else
	{
		_data = [NSMutableData dataWithData:data];
	}
	
	NSMutableData* _resultData = [NSMutableData data];
	
	PWBufferHeader _tempHeader = {@(_data.length).unsignedIntValue, tag};
	
	[_resultData appendBytes:&_tempHeader length:sizeof(PWBufferHeader)];

	[_resultData appendData:_data];
	
	return _resultData;
}

- (NSMutableData*)unpackData:(NSData*)data intoHeader:(PWBufferHeader*)header
{
	NSMutableData* resultData;
	
	[data getBytes:header range:NSMakeRange(0, sizeof(PWBufferHeader))];
	
	if (header->size > (@(data.length).unsignedIntValue - sizeof(PWBufferHeader)))
	{
		resultData = nil;
		
		header = NULL;
	}
	else
	{
		resultData = [NSMutableData dataWithData:[data subdataWithRange:NSMakeRange(sizeof(PWBufferHeader), header->size)]];
				
		if (__base_flag.enableCompression)
		{
			resultData = [NSMutableData dataWithData:[resultData gzipInflate]];
		}
	}
	
	return resultData;

}

@end
