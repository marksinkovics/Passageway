//
//  MSJSONUnmapper.m
//  JSONMapperApp
//
//  Created by Mark Sinkovics on 3/3/13.
//  Copyright (c) 2013 Mark Sinkovics. All rights reserved.
//

#import "MSJSONUnmapper.h"
#import "MSJSONMapEntity.h"

@implementation MSJSONUnmapper

- (id)initWithObject:(id<MSJSONMapperProtocol>)object mappedTemplates:(NSDictionary*)mappedTemplates
{
	self = [super init];
	
    if (self)
	{
		_object = [object retain];
		
		_reverseMappedTemplates = [[self reverseMappedTemplates:mappedTemplates] retain];
    }
    return self;
}

- (NSMutableDictionary*)reverseMappedTemplates:(NSDictionary*)mappedTemplates
{
	NSMutableDictionary* _reversed = [NSMutableDictionary dictionary];
	
	for(NSSet* properties in [mappedTemplates allKeys])
	{
		MSJSONMapEntity* entity = [mappedTemplates objectForKey:properties];
		
		[_reversed setObject:entity.mappedProperties forKey:NSStringFromClass(entity.mappedClass)];
	}
	
	return _reversed;
}

- (void)dealloc
{
    [_object release], _object = nil;
	
	[_reverseMappedTemplates release], _reverseMappedTemplates = nil;
	
    [super dealloc];
}

- (id)unmap
{
	id unmappedObject = [self unmapObject:_object];
	
	NSData* _jsonData = nil;

	if(unmappedObject)
	{
		NSError *error = nil;
		
		_jsonData = [NSJSONSerialization dataWithJSONObject:unmappedObject
													options:0
													  error:&error];
	}

	return _jsonData;
}

- (NSSet*)findMappedPropertiesByClassName:(NSString*)className
{
	return [_reverseMappedTemplates objectForKey:className];
}

- (NSString*)unmapObject:(id)object
{
	id resultObject = nil;
	
	if ([object isKindOfClass:[NSArray class]])
	{
		resultObject = [NSMutableArray array];
		
		for(id obj in (NSArray*)object)
		{
			[resultObject addObject:[self unmapObject:obj]];
		}
	}
	else if([object isKindOfClass:[NSDictionary class]])
	{
		resultObject = [NSMutableDictionary dictionary];
		
		for(id key in [(NSDictionary*)object allKeys])
		{
			id newKey = [self unmapObject:key];
			
			id newObject = [self unmapObject:[object objectForKey:key]];
			
			[resultObject setObject:newObject forKey:newKey];
		}
	}
	else if ([object conformsToProtocol:@protocol(MSJSONMapperProtocol)])
	{
		NSSet* mappedProperties = [self findMappedPropertiesByClassName:NSStringFromClass([object class])];
		
		resultObject = [NSMutableDictionary dictionary];
		
		for(id key in mappedProperties)
		{
			id value = [object valueForKey:key];
			
			if (value)
			{
				[resultObject setObject:[self unmapObject:value] forKey:key];
			}
		}
	}
	else
	{
		resultObject = object;
	}
	
	return resultObject;
}

@end
