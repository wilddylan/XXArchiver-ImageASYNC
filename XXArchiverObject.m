//
//  XXArchiverObject.m
//  XXUSERS
//
//  Created by xx-nb on 14-9-12.
//  Copyright (c) 2014年 xx-nb. All rights reserved.
//

#import "XXArchiverObject.h"

@interface XXArchiverObject () {
    NSArray * arrays;
}

@end

@implementation XXArchiverObject

// 归档到数组
- (BOOL)ArchiverObjectWithClassDict:(NSMutableDictionary *)objectDict forPath:(NSString *)filePath {
    
    NSMutableArray * array = [NSMutableArray array];
    
    for (NSString * key in objectDict.allKeys) {

        NSMutableData * data = [NSMutableData data];
        NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:objectDict[key] forKey:key];
        [archiver finishEncoding];
        
        [array addObject:data];
        [archiver release];
    }
    
    arrays = [NSArray arrayWithArray:objectDict.allKeys];
    
    // 写入数组
    [array writeToFile:filePath atomically:YES];
    
    return YES;
}

// 反归档
- (NSMutableDictionary *)UnarchiverWithPath: (NSString *)filePath model:(id)objectModel {
    
    NSMutableDictionary * userDict = [NSMutableDictionary dictionary];
    NSArray * array = [NSArray arrayWithContentsOfFile:filePath];
    
    NSInteger i = 0;
    for (NSMutableData * data in array) {
        
        NSKeyedUnarchiver * unArc= [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        id tempObj = [[[objectModel class] alloc] init];
        tempObj = [unArc decodeObjectForKey:arrays[i]];
        [unArc finishDecoding];
        
        [userDict setObject:tempObj forKey:arrays[i]];
        i ++;
    }
    
    return userDict;
} 

// 缓存图片 参数：URL
+ (void)imageWithASYNUrlString: (NSString *)urlString
                      getimage: (block)myBlock {

    NSString * imgPath =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:[urlString lastPathComponent]];
    
    // 判断文件是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath] == YES) {
        myBlock([UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]]);
        
        // 读取数据测试
        NSLog(@"读取缓存啦、");
    } else {
        [NSURLConnection sendAsynchronousRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            [data writeToFile:imgPath atomically:YES];
            myBlock([UIImage imageWithData:data]);
            
            // 读取数据测试
            NSLog(@"没有缓存、正在下载");
        }];
    }

}

@end
