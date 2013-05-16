//
//  PWBaseBufferDelegate.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 1/28/13.
//
//

#import <Foundation/Foundation.h>

@class PWBaseBuffer;

@protocol PWBaseBufferDelegate <NSObject>

@optional

- (void)buffer:(PWBaseBuffer*)buffer didWriteData:(NSData*)wroteData;

- (void)buffer:(PWBaseBuffer*)buffer didReadData:(NSData*)readData;

- (void)buffer:(PWBaseBuffer*)buffer didFailWithError:(NSError*)error;

- (void)buffer:(PWBaseBuffer*)buffer updateProgressValue:(NSNumber*)progressValue;

#pragma mark - Connect

- (void)didConnectAtBuffer:(PWBaseBuffer*)buffer;

- (void)didDisconnectAtBuffer:(PWBaseBuffer*)buffer;

#pragma mark - Status

- (void)buffer:(PWBaseBuffer*)buffer didChangeStatus:(NSNumber*)status;

@end
