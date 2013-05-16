//
//  PWAppDelegate.h
//  PassagewayServerMac
//
//  Created by Mark Sinkovics Work on 14/09/12.
//  Copyright (c) 2012 Mark Sinkovics. All rights reserved.
//

@class PWMainController;
@class PWMainWindowController;

@interface PWAppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong, readonly) PWMainController* mainController;
@property (nonatomic, strong) PWMainWindowController* mainWindowController;

#pragma mark - Core Data

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
