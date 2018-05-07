//
//  NewsLatestModel.h
//  zhihu
//
//  Created by 张义镇 on 2018/5/7.
//  Copyright © 2018年 zyiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StoriesModel;
@class Top_storiesModel;

@interface NewsLatestModel : NSObject

@property (nonatomic,copy)NSString *date;
@property (nonatomic,strong)NSArray<StoriesModel*> *stories;
@property (nonatomic,strong)NSArray<Top_storiesModel*> *top_stories;

@end
