//
//  PWRemoteDesktopView.h
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 3/25/13.
//  Copyright (c) 2013 mscodefactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWRemoteDesktopView : UIView
{
	int _numVertical;
	int _numHorizontal;
	float _width;
	float _height;
	
	CGImageRef* _images;
	
	NSTimer* _updaterTimer;
}

- (void)setNumberOfImagesVertically:(int)vertically horizontally:(int)horizontally;

- (void)setImageSizeWidth:(float)width height:(float)height;

- (void)updateWithImageRef:(CGImageRef)imageRef atIndex:(short)index;

@end
