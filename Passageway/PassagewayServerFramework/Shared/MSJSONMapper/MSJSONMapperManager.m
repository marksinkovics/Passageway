//
//  MSJSONMapperManager.m
//  JSONMapperApp
//
//  Created by Mark Sinkovics on 3/3/13.
//  Copyright (c) 2013 Mark Sinkovics. All rights reserved.
//

#import "MSJSONMapperManager.h"
#import "MSJSONMapEntity.h"
#import "MSJSONMapper.h"
#import "MSJSONUnmapper.h"

@implementation MSJSONMapperManager

static MSJSONMapperManager *sharedManager = nil;

+ (MSJSONMapperManager*)sharedManager
{
	if (sharedManager == nil)
	{
        sharedManager = [self createInstance];
    }
	
    return sharedManager;
}

#pragma mark - Singleton Methods

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    //denotes an object that cannot be released
    return NSUIntegerMax;
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

+ (id)createInstance
{
    return [[super allocWithZone:NULL] init];
}

#pragma mark - Instance Methods

- (id)init
{
    self = [super init];
    
    if (self)
    {
		_mappedTemplates = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Memory Management

- (void)destroy
{
	[self removeAllTemplate];
}

- (void)dealloc
{
	[_mappedTemplates release], _mappedTemplates = nil;
	
    [super dealloc];
}

- (void)addTemplateWithMappedObject:(Class<MSJSONMapperProtocol>)mappedClass
{
	NSSet* mappedProperties = [mappedClass mappedProperties];

	[self addTemplateWithMappedClass:mappedClass mappedProperties:mappedProperties];
}

- (void)addTemplateWithMappedClass:(Class)mappedClass mappedProperties:(NSArray*)mappedProperties
{
	MSJSONMapEntity* entity = [MSJSONMapEntity entityWithMappedClass:mappedClass withMappedProperties:[mappedClass mappedProperties]];
	
	[_mappedTemplates setObject:entity forKey:mappedProperties];
}

- (void)removeAllTemplate
{
	[_mappedTemplates removeAllObjects];
}

- (id)mapJSONData:(NSData*)jsonData
{
	MSJSONMapper* mapper = [[MSJSONMapper alloc] initWithJSONData:jsonData mappedTemplates:_mappedTemplates];
	
	id result = [mapper map];
	
	[mapper release];
	
	return result;
}

- (NSData*)unmapObject:(id)object
{
	MSJSONUnmapper* unmapper = [[MSJSONUnmapper alloc] initWithObject:object mappedTemplates:_mappedTemplates];
	
	NSData* result = [unmapper unmap];
	
	[unmapper release];
	
	return result;
}
@end
