//
//  PWImageMacLib.m
//  PassagewayServerMac
//
//  Created by Mark Sinkovics on 2/21/13.
//
//

#import "PWImageMacLib.h"
#import <PWServer/PWMsgBase.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>
#include <stdio.h>

@implementation PWImageMacLib

@end

NSImage* _imageFromCGImage(CGImageRef imageRef);

CGImageRef _grabFullscreen(CGFloat scale);

CGImageRef _mergeImageRefs(CGImageRef* imageRefs, int count, CGFloat scale);

void CGImageWriteToFile(CGImageRef image, NSString *path)
{
    CFURLRef url = (CFURLRef)[NSURL fileURLWithPath:path];
	
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
	
    CGImageDestinationAddImage(destination, image, nil);
	
    if (!CGImageDestinationFinalize(destination))
	{
        NSLog(@"Failed to write image to %@", path);
    }
	
    CFRelease(destination);
}

#pragma mark
#pragma mark Private Methods
#pragma mark 

// Simple helper to twiddle bits in a uint32_t.
//inline uint32_t ChangeBits(uint32_t currentBits, uint32_t flagsToChange, BOOL setFlags);
inline uint32_t _changeBits(uint32_t currentBits, uint32_t flagsToChange, BOOL setFlags)
{
	if(setFlags)
	{	// Set Bits
		return currentBits | flagsToChange;
	}
	else
	{	// Clear Bits
		return currentBits & ~flagsToChange;
	}
}

CGWindowListOption _getCGWindowListOptionForImageCreating()
{
    CGWindowListOption listOptions = kCGWindowListOptionAll;
    
//	listOptions = _changeBits(listOptions, kCGWindowListOptionOnScreenOnly, 1);
//    
//	listOptions = _changeBits(listOptions, kCGWindowListExcludeDesktopElements, 1);
	
    return listOptions;
}

CGImageRef _mergeImageRefs(CGImageRef* imageRefs, int count, CGFloat scale)
{
	CGSize size = {CGImageGetWidth(imageRefs[0]) * scale , CGImageGetHeight(imageRefs[0]) * scale};
	
	CGContextRef ctx = CGBitmapContextCreate(NULL,
											 size.width ,
											 size.height,
											 8,
											 size.width * 4,
											 CGImageGetColorSpace(imageRefs[0]),
											 kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
	for(int i = 0; i < count; i++)
	{		
		CGContextDrawImage(ctx, (CGRect){{0.0, 0.0}, size}, imageRefs[i]);
	}
	
	CGImageRef result = CGBitmapContextCreateImage(ctx);
	
	CGContextRelease(ctx);
	
	return result;
}

CGImageRef _drawMouseCursorToImageRef(CGImageRef imageRef)
{
	@autoreleasepool
	{
//		CGEventRef emptyEvent = CGEventCreate(NULL);
//		
//		CGPoint cursorPosition = CGEventGetLocation(emptyEvent);
//		
//		CFRelease(emptyEvent);
		
		NSPoint mouseLoc = [NSEvent mouseLocation];
		
		NSImage *cursorImage = [[NSCursor currentSystemCursor] image];
		
		CGSize cursorSize = CGSizeMake([cursorImage size].width, [cursorImage size].height);
		
		CGSize size = {CGImageGetWidth(imageRef) , CGImageGetHeight(imageRef)};
		
		CGContextRef ctx = CGBitmapContextCreate(NULL,
												 size.width ,
												 size.height,
												 8,
												 size.width * 4,
												 CGImageGetColorSpace(imageRef),
												 kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
		
		CGContextDrawImage(ctx, (CGRect){CGPointZero, size}, imageRef);
		
		CGContextDrawImage(ctx,
						   CGRectMake(mouseLoc.x,
									  mouseLoc.y - (cursorSize.height / 2.0),
									  cursorSize.width,
									  cursorSize.height),
						   [cursorImage CGImageForProposedRect: NULL
													   context: NULL
														 hints: NULL]
						   );
		
		CGImageRef result = CGBitmapContextCreateImage(ctx);
		
		CGContextRelease(ctx);
		
		return result;
	}
}

CGImageRef _grabFullscreen(CGFloat scale)
{
//	struct timeval t1, t2;
//	
//	gettimeofday(&t1, NULL);
	
	CGWindowListOption listOption = _getCGWindowListOptionForImageCreating();
    
	CGImageRef wholeDesktop = CGWindowListCreateImage(CGRectInfinite, listOption, kCGNullWindowID, kCGWindowImageDefault);
	
	CGImageRef wholeDesktopWithMouseCursor = _drawMouseCursorToImageRef(wholeDesktop);
	
	CGImageRef imageRefs[] = {wholeDesktopWithMouseCursor};
	
	CGImageRef fullscreenImageRef = _mergeImageRefs(imageRefs, 1, scale);
	
	CFRelease(wholeDesktop);
	
	CFRelease(wholeDesktopWithMouseCursor);
	
//	gettimeofday(&t2, NULL);
//	
//	double elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000.0;      // sec to ms
//	
//    elapsedTime += (t2.tv_usec - t1.tv_usec) / 1000.0;   // us to ms
//
//	NSLog(@"Elapsed time: %f ms", elapsedTime);
	
	return fullscreenImageRef;
}

void _getNumberOfTileByImageRef(CGImageRef imageRef, int* horizontal, int* vertical, float* width, float* height)
{
	size_t originalImageWidth = CGImageGetWidth(imageRef);
	
	size_t originalImageHeight = CGImageGetHeight(imageRef);
	
	int numTileHorizontal = ceilf(originalImageWidth / originalImageWidth);
	
	int numTileVertical = ceilf(originalImageHeight / originalImageHeight);
	
	float widthTile = (originalImageWidth / numTileHorizontal);
	
	float heightTile = (originalImageHeight / numTileVertical);
	
	*horizontal = numTileHorizontal;
	
	*vertical = numTileVertical;
	
	*width = widthTile;
	
	*height = heightTile;
}

CGImageRef* _cropImageRefToArray(CGImageRef imageRef, int* numImage)
{
	float width, height;
	
	int numTileHorizontal, numTileVertical;
			
	_getNumberOfTileByImageRef(imageRef, &numTileHorizontal, &numTileVertical, &width, &height);
		
	CGImageRef *images = calloc(numTileHorizontal * numTileVertical, sizeof(CGImageRef));
	
	for (int i = 0; i < numTileVertical; i++)
	{
		for (int j = 0; j < numTileHorizontal; j++)
		{
			int index =  (i * numTileHorizontal) + j;
			
			images[index] = CGImageCreateWithImageInRect(imageRef, CGRectMake(j*width, i*height, width, height));
		}
	}
	
	*numImage = (numTileHorizontal * numTileVertical);
	
	return images;
}

NSData* _dataFromCGImageNHeader(CGImageRef imageRef, short index)
{
	CGImageRef image = imageRef;
	
//	CGImageWriteToFile(imageRef, [NSString stringWithFormat:@"/Users/marksinkovics/Desktop/images/img_%d.png", index]);
	
	CFMutableDataRef pngData = CFDataCreateMutable (kCFAllocatorDefault, 0);
	
	CGImageDestinationRef dataDest = CGImageDestinationCreateWithData (pngData, kUTTypeJPEG, 1, NULL);
	
	CGImageDestinationAddImage (dataDest, image, NULL);
	
	CGImageDestinationFinalize (dataDest);
	
	CFRelease(dataDest);
	
	PWUDPImageHeader imageHeader;
	
	imageHeader.index = index;
	
	NSMutableData* data = [[NSMutableData alloc] initWithBytes:&imageHeader length:sizeof(PWUDPImageHeader)];
	
	[data appendData:(NSMutableData*)pngData ];
	
	CFRelease(pngData);
	
	return data;
}

NSData* _dataFromCGImage(CGImageRef imageRef)
{
	CGImageRef image = imageRef;
	
	CFMutableDataRef pngData = CFDataCreateMutable (kCFAllocatorDefault, 0);
	
	CGImageDestinationRef dataDest = CGImageDestinationCreateWithData (pngData, kUTTypeJPEG, 1, NULL);
	
	CGImageDestinationAddImage (dataDest, image, NULL);
	
	CGImageDestinationFinalize (dataDest);
	
	CFRelease(dataDest);
	
	NSData* data = [[NSData alloc] initWithData:(NSData*)pngData];
	
	CFRelease(pngData);
	
	CFRelease(imageRef);
	
	return data;
}

NSImage* _imageFromCGImage(CGImageRef imageRef)
{
	int size = 0;
	
	CGImageRef* images = _cropImageRefToArray(imageRef, &size);
	
	for (int i = 0; i < size; i++)
	{
		NSString* str = [NSString stringWithFormat:@"/Users/marksinkovics/Desktop/testImages/img_%d.png", i];
		
		CGImageRef image = images[i];
		
		CGImageWriteToFile(image, str);
		
		CFRelease(image);
	}
	
	free(images);

	NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:imageRef];
	
	NSGraphicsContext* context = [NSGraphicsContext graphicsContextWithBitmapImageRep:bitmapRep];
	
    [NSGraphicsContext saveGraphicsState];
	
    [NSGraphicsContext setCurrentContext: context];
	
	CGContextDrawImage([context graphicsPort], CGRectMake(0, 0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)), imageRef);
	
    [NSGraphicsContext restoreGraphicsState];
	
	CFRelease(imageRef);
	
	// set up the options for creating a JPEG
    NSDictionary* jpegOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @0, NSImageCompressionFactor,
                                 @YES, NSImageProgressive,
                                 nil];
	
	
	NSData* imgData = [bitmapRep representationUsingType:NSJPEGFileType properties:jpegOptions];
	
	NSLog(@"imgData %f kB", imgData.length / 1024.0);
	
	NSImage* resultImage = [[NSImage alloc] initWithData:imgData];
	
	[bitmapRep release];
	
	return [resultImage autorelease];
}

BOOL _compareCGImages(CGImageRef imageRef1, CGImageRef imageRef2)
{
	BOOL result = NO;
	
	NSData *data1        = (NSData *)CGDataProviderCopyData(CGImageGetDataProvider(imageRef1));
	NSData *data2        = (NSData *)CGDataProviderCopyData(CGImageGetDataProvider(imageRef2));
	
    char *pixels1        = (char *)[data1 bytes];
    char *pixels2        = (char *)[data2 bytes];
	
    // this is where you manipulate the individual pixels
    // assumes a 4 byte pixel consisting of rgb and alpha
    // for PNGs without transparency use i+=3 and remove int a
    for(int i = 0; i < [data1 length]; i += (4 * 5))
    {
        int r = i;
        int g = i+1;
        int b = i+2;
//        int a = i+3;
		
		result = (pixels1[r] == pixels2[r]);
		
		if (result)
		{
			result = (pixels1[g] == pixels2[g]);
		}
		else
		{
			break;
		}
		
		if (result)
		{
			result = (pixels1[g] == pixels2[g]);
		}
		else
		{
			break;
		}
		
		if (result)
		{
			result = (pixels1[b] == pixels2[b]);
		}
		else
		{
			break;
		}
    }
	
	[data1 release];
	
	[data2 release];
	
	return result;
}

#pragma mark
#pragma mark Public Methods
#pragma mark

void getNumberOfTileByFullScreen(CGFloat scale, int* horizontal, int* vertical, float* width, float* height)
{
	CGImageRef wholeDesktop = _grabFullscreen(scale);

	_getNumberOfTileByImageRef(wholeDesktop, horizontal, vertical, width, height);
	
	CFRelease(wholeDesktop);
}

NSData* dataFromFullscreen()
{
	CGImageRef wholeDesktop = _grabFullscreen(1.0);
	
//	CGImageRef imageRefs[] = {wholeDesktop};
//	
//	CGImageRef mergedImages = mergeImageRefs(imageRefs, 1, 1.0);
//	
//	CFRelease(wholeDesktop);
	
	NSData* result = _dataFromCGImage(wholeDesktop);
	
	CFRelease(wholeDesktop);
	
	return result;
}

NSImage* imageFromFullScreen()
{
	CGImageRef wholeDesktop = _grabFullscreen(1.0);
	
	CGImageRef imageRefs[] = {wholeDesktop};
	
	CGImageRef mergedImages = _mergeImageRefs(imageRefs, 1, 1.0);
	
	CFRelease(wholeDesktop);
	
	NSImage* result = _imageFromCGImage(mergedImages);
	
	return result;
}

NSData** imageSliceDatasFromFullScreen(CGFloat scale, int* size)
{
	CGImageRef fullscreenImageRef = _grabFullscreen(scale);
	
	int numImages = 0;
	
	CGImageRef* images = _cropImageRefToArray(fullscreenImageRef, &numImages);
	
	CFRelease(fullscreenImageRef);
	
	*size = numImages;
	
	NSData** datas = calloc(numImages, sizeof(NSData*));
	
	for(int i = 0; i < numImages; i++)
	{
		CGImageRef image = images[i];
		
		datas[i] = _dataFromCGImageNHeader(image, i);
		
		CFRelease(image);
	}
	
	free(images);
	
	return datas;
}


NSData** imageSliceDatasFromFullScreenWithComparing(CGFloat scale, int* size, CGImageRef** oldImageRefs)
{
	CGImageRef fullscreenImageRef = _grabFullscreen(scale);

	int numImages = 0;
	
	BOOL isEmptyOldImageRefs = (*oldImageRefs == NULL);
	
	CGImageRef* images = _cropImageRefToArray(fullscreenImageRef, &numImages);
	
	if (isEmptyOldImageRefs)
	{
		*oldImageRefs = calloc(numImages, sizeof(CGImageRef));
	}
	
	CFRelease(fullscreenImageRef);
	
	*size = numImages;
	
	NSData** datas = calloc(numImages, sizeof(NSData*));
	
	int c = 0;
	
	for(int i = 0; i < numImages; i++)
	{
		CGImageRef image = images[i];
		
		if(!isEmptyOldImageRefs)
		{
			CGImageRef oldImage = (*oldImageRefs)[i];
			
			if (!_compareCGImages(image, oldImage))
			{
				datas[i] = _dataFromCGImageNHeader(image, i);
				
				CFRelease(oldImage);
				
				(*oldImageRefs)[i] = image;
				
				c++;
			}
			else
			{
				datas[i] = NULL;
				
				CFRelease(image);
			}
		}
		else
		{
			datas[i] = _dataFromCGImageNHeader(image, i);
			
			(*oldImageRefs)[i] = image;
			
			c++;
		}
	}
	
	free(images);
	
	return datas;
}
