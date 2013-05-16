//
//  MSJSONMapEntity.m
//  JSONMapperApp
//
//  Created by Mark Sinkovics on 3/3/13.
//  Copyright (c) 2013 Mark Sinkovics. All rights reserved.
//

#import "MSJSONMapEntity.h"

@implementation MSJSONMapEntity

@synthesize mappedClass = _mappedClass;
@synthesize mappedProperties = _mappedProperties;

+ (MSJSONMapEntity*)entityWithMappedClass:(Class)mappedClass withMappedProperties:(NSSet*)mappedProperties
{
	MSJSONMapEntity* entity = [[MSJSONMapEntity alloc] initWithMappedClass:mappedClass withMappedProperties:mappedProperties];
	
	return [entity autorelease];
}

- (id)initWithMappedClass:(Class)mappedClass withMappedProperties:(NSSet*)mappedProperties
{
    self = [super init];
	
    if (self && mappedProperties.count > 0)
	{
		self.mappedClass = mappedClass;
		
		self.mappedProperties = mappedProperties;
    }
    return self;
}

- (void)dealloc
{
	self.mappedClass = nil;
	
    self.mappedProperties = nil;
	
    [super dealloc];
}

- (id)createObjectFromValues:(NSDictionary*)valuesDictionary
{
	id object = [[self.mappedClass alloc] init];
	
	for (NSString* key in self.mappedProperties)
	{
		if ([[valuesDictionary allKeys] containsObject:key])
		{
			[object setValue:[valuesDictionary objectForKey:key] forKey:key];
		}
	}
	
	return [object autorelease];
}

@end
