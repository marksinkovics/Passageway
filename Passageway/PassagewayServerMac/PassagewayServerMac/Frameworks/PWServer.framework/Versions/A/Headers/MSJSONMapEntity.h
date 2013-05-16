//
//  MSJSONMapEntity.h
//  JSONMapperApp
//
//  Created by Mark Sinkovics on 3/3/13.
//  Copyright (c) 2013 Mark Sinkovics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSJSONMapEntity : NSObject
{
	Class _mappedClass;
	NSSet* _mappedProperties;
}

@property (nonatomic, assign) Class mappedClass;
@property (nonatomic, retain) NSSet* mappedProperties;

+ (MSJSONMapEntity*)entityWithMappedClass:(Class)mappedClass withMappedProperties:(NSSet*)mappedProperties;

- (id)initWithMappedClass:(Class)mappedClass withMappedProperties:(NSSet*)mappedProperties;

- (id)createObjectFromValues:(NSDictionary*)values;

@end
