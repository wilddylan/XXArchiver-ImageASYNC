//
//  XXArchiverObject.h
//  XXUSERS
//
//  Created by xx-nb on 14-9-12.
//  Copyright (c) 2014年 xx-nb. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^block)(UIImage * image);

@interface XXArchiverObject : NSObject

// 复杂对象字典归档到数组  参数1： 包含key对应对象的字典  参数2：路径
- (BOOL)ArchiverObjectWithClassDict:(NSMutableDictionary *)objectDict forPath:(NSString *)filePath;

// 反归档复杂对象到字典 参数1：路径 参数2：模型对象
- (NSMutableDictionary *)UnarchiverWithPath: (NSString *)filePath model:(id)objectModel;

// 缓存图片 参数：URL 参数2： Block类型的参数 自己在函数中调用自己去寻找自己
+ (void)imageWithASYNUrlString: (NSString *)urlString
                           getimage: (block)myblock;
@end