//
//  LXUtil.m
//  sparrow
//
//  Created by mac on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LXUtil.h"
#import "Constant.h"

@implementation LXUtil

+ (NSString *)contatImageURL:(NSString *)url
{
    NSRange range = [url rangeOfString:@"statics/images"];
    if (range.location == 0) {
        return [NSString stringWithFormat:@"%@/%@", PREFIX_URL, url];
    } else if (range.location == 1) {
        return [NSString stringWithFormat:@"%@%@", PREFIX_URL, url];
    }
    return url;
}

+ (UIColor *)cellImageBorderColor
{
    UIColor *imageBorderColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0];
    return imageBorderColor;
}

+ (UIImage *)invertContrast:(UIImage *)image
{
    CGImageRef inImage = image.CGImage;
    CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    NSInteger width = CGImageGetWidth(inImage);
    NSInteger height = CGImageGetHeight(inImage);
    NSInteger bpc = CGImageGetBitsPerComponent(inImage);
    NSInteger bpp = CGImageGetBitsPerPixel(inImage);
    NSInteger bpl = CGImageGetBytesPerRow(inImage);
    UInt8 *m_PixelBuf = (UInt8 *)CFDataGetBytePtr(m_DataRef);
    NSInteger length = CFDataGetLength(m_DataRef);
    NSLog(@"len %d", length);  
    NSLog(@"width=%d, height=%d", width, height);          
    NSLog(@"1=%d, 2=%d, 3=%d", bpc, bpp,  bpl);
    for (int index=0; index<length; index += 4) {
        
        m_PixelBuf[index + 0] = 255 - m_PixelBuf[index + 0];
        m_PixelBuf[index + 1] = 255 - m_PixelBuf[index + 1];
        m_PixelBuf[index + 2] = 255 - m_PixelBuf[index + 2];
        NSLog(@"r=%d, g=%d, b=%d, alpha=%d", m_PixelBuf[index + 0], m_PixelBuf[index + 1],  m_PixelBuf[index + 2], m_PixelBuf[index + 3]);
    }
    CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf, width, height, bpc, bpl, CGImageGetColorSpace(inImage), kCGImageAlphaPremultipliedLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *rawImage = [UIImage imageWithCGImage:imageRef];
    CGContextRelease(ctx);
    return rawImage;
}

@end
