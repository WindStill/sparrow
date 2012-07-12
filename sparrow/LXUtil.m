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

@end
