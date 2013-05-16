//
//  MSJSONMapper.h
//  JSONMapperApp
//
//  Created by Mark Sinkovics on 3/3/13.
//  Copyright (c) 2013 Mark Sinkovics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSJSONMapperProtocol.h"

@interface MSJSONMapper : NSObject
{
	NSData* _jsonData;
	NSObject* _jsonObject;
	NSDictionary* _mappedTemplates;
}

#pragma mark Mapping Methods

- (id)initWithJSONData:(NSData *)jsonData mappedTemplates:(NSDictionary*)mappedTemplates;

- (id)map;

@end
