//
//  NewsInfoModel.h
//  zhihu
//
//  Created by 张义镇 on 2018/5/8.
//  Copyright © 2018年 zyiz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SectionModel;

@interface NewsInfoModel : NSObject

@property (nonatomic,copy)NSString *HTML;
@property (nonatomic,copy)NSString *body;
@property (nonatomic,copy)NSString *image_source;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *image;
@property (nonatomic,copy)NSString *share_url;
@property (nonatomic,copy)NSString *js;
@property (nonatomic,copy)NSString *ga_prefix;
@property (nonatomic,strong)NSArray *images;
@property (nonatomic,assign)NSInteger *type;
@property (nonatomic,assign)long long id;
@property (nonatomic,strong)NSArray *css;


@property (nonatomic,strong)NSArray *recommenders;
@property (nonatomic,assign)SectionModel *section;

//在较为特殊的情况下，知乎日报可能将某个主题日报的站外文章推送至知乎日报首页。
@property (nonatomic,assign)long long theme_id;
@property (nonatomic,copy)NSString *theme_name;
@property (nonatomic,copy)NSString *editor_name;
@end
