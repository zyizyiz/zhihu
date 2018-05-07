//
//  StoriesModel.h
//  zhihu
//
//  Created by 张义镇 on 2018/5/7.
//  Copyright © 2018年 zyiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoriesModel : NSObject

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *ga_prefix;
@property (nonatomic,strong)NSArray *images;
@property (nonatomic,assign)long long id;
@end
