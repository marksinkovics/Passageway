//
//  PWImageMacLib.h
//  PassagewayServerMac
//
//  Created by Mark Sinkovics on 2/21/13.
//
//

#import <Cocoa/Cocoa.h>


@interface PWImageMacLib : NSObject

@end

/*!
 @function getNumberOfTileByFullScreen
 @param scale
 @param horizontal int*
 @param vertical int*
 @param width CGFloat*
 @param height CGFloat*
 */
void getNumberOfTileByFullScreen(CGFloat scale, int* horizontal, int* vertical, float* width, float* height);

/*!
 @function dataFromFullscreen
 @return An retained intance of NSData
 */
NSData* dataFromFullscreen();

/*!
 @function imageFromFullScreen
 @return An retained intance of NSSImage
 */
NSImage* imageFromFullScreen();

/*!
 @function
 @param
 @param
 @return
 */
NSData** imageSliceDatasFromFullScreen(CGFloat scale, int* size);

/*!
 @function
 @param scale
 @param size It is an int pointer
 @param oldImageRefs
 @return It is an NSData* C container. Every NSData objects are retained!
 @discussion Size int pointer contains the number of elements.
 <br/> One of the NSData contains an PWUDPImageHeader struct header.
 <br/> This header's property contains the size of the png compressed CGImageRef
 */
NSData** imageSliceDatasFromFullScreenWithComparing(CGFloat scale, int* size, CGImageRef** oldImageRefs);