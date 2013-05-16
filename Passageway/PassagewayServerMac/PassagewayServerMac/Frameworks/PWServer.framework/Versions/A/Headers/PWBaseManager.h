//
//  PWBaseManager.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 12/26/12.
//
//

#import <Foundation/Foundation.h>

/*!
 @class PWBaseManager
 */
@interface PWBaseManager : NSObject

#pragma mark - Singleton Methods

/*!
 @method sharedManager
 @return return the instance of PWBaseManager class
 @discussion This object is contained it the stack.
 */
+ (PWBaseManager*)sharedManager;

/*!
 @method createInstance
 @return return an istance of PWBaseManager class
 */
+ (id)createInstance;

#pragma mark - Test

/*!
 @method destroy
 Used for unit testing. In this method need to remove all instances
 */
- (void)destroy;

@end
