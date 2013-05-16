//
//  MSJSONMapper.m
//  JSONMapperApp
//
//  Created by Mark Sinkovics on 3/3/13.
//  Copyright (c) 2013 Mark Sinkovics. All rights reserved.
//

#import "MSJSONMapper.h"
#import "MSJSONMapEntity.h"

@implementation MSJSONMapper

- (id)initWithJSONData:(NSData *)jsonData mappedTemplates:(NSDictionary*)mappedTemplates
{
    self = [super init];
	
    if (self)
	{
		_jsonData = [jsonData retain];
		_mappedTemplates = [mappedTemplates retain];
    }
    return self;
}

- (void)dealloc
{
    [_jsonData release], _jsonData = nil;
	
	[_mappedTemplates release], _mappedTemplates = nil;
	
    [super dealloc];
}

- (id)map
{
	id resultObject = nil;
	
	NSError *error = nil;
	
	_jsonObject = [NSJSONSerialization JSONObjectWithData:_jsonData
												  options: NSJSONReadingMutableContainers
													error: &error];
	if (!error)
	{
		resultObject = [self mapObject:_jsonObject];
	}
	
	return resultObject;
}

- (MSJSONMapEntity*)findMapEntityByMappedProperties:(NSSet*)mappedProperties
{
	MSJSONMapEntity* mapEntity = nil;
	
	NSInteger maxMatchingCount = 0;
	
	for (NSSet* properties in [_mappedTemplates allKeys])
	{
		if ([properties isSubsetOfSet:mappedProperties])
		{
			mapEntity = [_mappedTemplates objectForKey:properties];
			
			break;
		}
		else if([properties intersectsSet:mappedProperties])
		{
			NSMutableSet* propertiesMutableSet = [NSMutableSet setWithSet:mappedProperties];
			
			[propertiesMutableSet intersectSet:properties];
			
			if (maxMatchingCount < propertiesMutableSet.count)
			{
				mapEntity = [_mappedTemplates objectForKey:properties];
			}
		}
	}
	
	return mapEntity;
}

- (id)mapObject:(id)object
{
	id resultObject = nil;
	
	if ([object isKindOfClass:[NSArray class]])
	{
		resultObject = [NSMutableArray array];
		
		for(id obj in (NSArray*)object)
		{
			[resultObject addObject:[self mapObject:obj]];
		}
	}
	else if([object isKindOfClass:[NSDictionary class]])
	{
		resultObject = [NSMutableDictionary dictionary];
		
		for(id key in [(NSDictionary*)object allKeys])
		{
			[resultObject setObject:[self mapObject:[object objectForKey:key]] forKey:key];
		}
		
		MSJSONMapEntity* mapEntity = [self findMapEntityByMappedProperties:[NSSet setWithArray:[object allKeys]]];
		
		resultObject = [mapEntity createObjectFromValues:resultObject];		
	}
	else
	{
		resultObject = object;
	}

	return resultObject;
}

@end
