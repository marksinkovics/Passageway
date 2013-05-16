//
//  PWRemoteDesktopView.m
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 3/25/13.
//  Copyright (c) 2013 mscodefactory. All rights reserved.
//

#import "PWRemoteDesktopView.h"

@implementation PWRemoteDesktopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	
    if (self)
	{
		self.backgroundColor = [UIColor yellowColor];
		
		_images = NULL;
    }
    return self;
}

- (void)setNumberOfImagesVertically:(int)vertically horizontally:(int)horizontally
{
	if (_images != NULL)
	{
		for(int i = 0; i < _numVertical; i++)
		{
			for(int j = 0; j < _numHorizontal; j++)
			{
				int index =  j + (i * _numHorizontal);
				
				CGImageRef img = _images[index];
				
				CFRelease(img);
			}
		}
		
		free(_images);
	}
	
	_numVertical = vertically;
	
	_numHorizontal = horizontally;
	
	_images = calloc(_numHorizontal * _numVertical, sizeof(CGImageRef));
}

- (void)setImageSizeWidth:(float)width height:(float)height
{
	_width = width;
	
	_height = height;
}

- (void)updateWithImageRef:(CGImageRef)imageRef atIndex:(short)index
{
	if (_images != NULL)
	{
		CGImageRef img = _images[index];
		
		if (img != NULL)
		{
			CFRelease(img);
		}
		
		_images[index] = imageRef;
	}	
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	
	CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
	
	CGContextScaleCTM(context, 1.0f, -1.0f);

	for(int i = 0; i < _numVertical; i++)
	{
		for(int j = 0; j < _numHorizontal; j++)
		{
			int index =  j + (i * _numHorizontal);
			
			CGImageRef img = _images[index];
			
			if (img != NULL)
			{
				CGRect r = CGRectMake(j * _width, CGRectGetHeight(self.bounds) - _height - (i * _height), _width, _height);
				
//				CGRect r = CGRectMake(j*_width, i*_height, _width, _height);
				
				CGContextDrawImage(context, r, img);
			}
		}
	}
	
	CGContextRestoreGState(context);
}


@end
