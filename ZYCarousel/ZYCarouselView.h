//
//  ZYCarouselView.h
//  ZYCarousel
//
//  Created by LeMo-test on 16/6/12.
//  Copyright © 2016年 LeMo-test. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum PageModel{
    LeftModel,   //pageControl位于左边
    CenterModel,//中间
    RightModel,//右边
} pageSite;
@class ZYCarouselView;
@protocol ZYCarouseSelectedDelegate <NSObject>

-(void)ZYCarouseView:(ZYCarouselView*)View WithSelectedItemInfo:(id)info;

@end

@interface ZYCarouselView : UIView
/**
 代理方法
 */
@property (nonatomic, assign) id<ZYCarouseSelectedDelegate> delegat;
/**
 存放图片的数组
 */
@property (nonatomic, copy) NSMutableArray *ImageArrys;
/**
 自定义初始化方法
 */
-(instancetype)initWithFrame:(CGRect)frame WithPageControlModel:(pageSite)pageModel;
/**
 图片的相关数据
 */
@property (nonatomic, strong) NSArray * ImageData;
@end
