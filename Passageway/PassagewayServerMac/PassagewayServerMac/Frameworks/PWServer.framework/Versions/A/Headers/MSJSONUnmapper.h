//
//  MSJSONUnmapper.h
//  JSONMapperApp
//
//  Created by Mark Sinkovics on 3/3/13.
//  Copyright (c) 2013 Mark Sinkovics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSJSONMapperProtocol.h"
@interface MSJSONUnmapper : NSObject
{
	NSObject* _object;
	NSDictionary* _reverseMappedTemplates;
}

#pragma mark Mapping Methods

- (id)initWithObject:(id<MSJSONMapperProtocol>)object mappedTemplates:(NSDictionary*)mappedTemplates;

- (id)unmap;


@end
