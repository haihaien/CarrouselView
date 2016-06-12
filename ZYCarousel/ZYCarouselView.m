//
//  ZYCarouselView.m
//  ZYCarousel
//
//  Created by LeMo-test on 16/6/12.
//  Copyright © 2016年 LeMo-test. All rights reserved.
//

#import "ZYCarouselView.h"
#define PagControlDistance 20
#define pageHight 20
#define TIMESPACE  2
#define pageWidth 80
#define PageCurrentcolor      [UIColor orangeColor]
#define PageIndicatorTintColor          [UIColor grayColor]

 NSInteger static ImageCount=3;
@interface ZYCarouselView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView  *CarouseBottomView;

@property (nonatomic, strong) UIPageControl *pageController;

@property (nonatomic, strong)  NSTimer *timer;

@property (nonatomic, assign)  BOOL firstLoad;

@end
@implementation ZYCarouselView
-(UIPageControl *)pageController
{
    if (!_pageController) {
        _pageController = [[UIPageControl alloc] init];
        _pageController.currentPageIndicatorTintColor = PageCurrentcolor;
        _pageController.pageIndicatorTintColor = PageIndicatorTintColor;
        [self addSubview:_pageController];
    }
    return _pageController;

}
-(UIScrollView *)CarouseBottomView
{
    if (!_CarouseBottomView) {
        _CarouseBottomView = [[UIScrollView alloc] init];
        _CarouseBottomView.delegate = self;
        _CarouseBottomView.showsVerticalScrollIndicator = NO;
        _CarouseBottomView.showsHorizontalScrollIndicator = NO;
        _CarouseBottomView.pagingEnabled = YES;
        _CarouseBottomView.bounces = YES;
        _CarouseBottomView.frame = self.bounds;
    }
    return _CarouseBottomView;

}
-(instancetype)initWithFrame:(CGRect)frame WithPageControlModel:(pageSite)pageModel
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.CarouseBottomView];
        for (int i=0; i<ImageCount; i++) {
            UIImageView *image = [[UIImageView alloc] init];
            [self.CarouseBottomView addSubview:image];
        }
        [self createPageControlWithModel:pageModel];
        
    }
    return self;


}
-(void)createPageControlWithModel:(pageSite)model
{
    switch (model) {
        case LeftModel:
            self.pageController.frame=CGRectMake(PagControlDistance, self.CarouseBottomView.frame.size.height-pageHight, pageWidth, pageHight);
            break;
        case CenterModel:
              self.pageController.frame=CGRectMake(PagControlDistance, self.CarouseBottomView.frame.size.height-pageHight, pageWidth, pageHight);
            CGPoint center = self.pageController.center;
            center.x = self.CarouseBottomView.center.x;
            self.pageController.center = center;
            break;
        case RightModel:
              self.pageController.frame=CGRectMake(self.CarouseBottomView.frame.size.width-PagControlDistance, self.CarouseBottomView.frame.size.height-pageHight, pageWidth, pageHight);
            break;
            
        default:
            break;
    }


}

-(void)layoutSubviews
{
[super layoutSubviews];
    [self addTap];
    self.CarouseBottomView.contentSize = CGSizeMake(ImageCount*self.bounds.size.width, 0);
    for (int i=0; i<ImageCount; i++) {
        UIImageView *imagevIew = self.CarouseBottomView.subviews[i];
        imagevIew.frame = CGRectMake(i*self.CarouseBottomView.frame.size.width, 0, self.CarouseBottomView.frame.size.width, self.CarouseBottomView.frame.size.height);
    }
   


}
-(void)addTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCallBack)];
    tap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tap];
}
-(void)tapCallBack
{
    if (self.delegat && [self.delegat respondsToSelector:@selector(ZYCarouseView:WithSelectedItemInfo:)]) {
        [self.delegat ZYCarouseView:self WithSelectedItemInfo:@(self.pageController.currentPage)];
    }
}
#pragma  mark - <UIScrollViewDelegate>主要处理在滚动中手指结束滚动应该显示的图片
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = 0;
    CGFloat Mindistance = MAXFLOAT;
    for (int i =0; i<ImageCount; i++) {
        UIImageView *imageView = self.CarouseBottomView.subviews[i];
        CGFloat distance = 0;
        distance = ABS(scrollView.contentOffset.x-imageView.frame.origin.x);
        if (distance<Mindistance) {
            Mindistance = distance;
            page = imageView.tag;
        }
    }
    self.pageController.currentPage = page;


}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];

}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];

}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self displayImage];

}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self displayImage];
}

-(void)displayImage
{
    for (int i=0;i<ImageCount; i++) {
        UIImageView *imageView = self.CarouseBottomView.subviews[i];
        NSInteger index = self.pageController.currentPage;
        if (i == 0 &&self.firstLoad) {
            index--;
        }else if (i == 2)
        {
            index++;
        
        }
        
        if (index < 0) {
            index = self.pageController.numberOfPages-1;
        }else if (index >= self.pageController.numberOfPages)
        {
            index = 0;
        }
        
        imageView.tag = index;
        imageView.image = self.ImageArrys[index];
        
        
    }
    self.firstLoad = YES;
self.CarouseBottomView.contentOffset = CGPointMake(self.CarouseBottomView.frame.size.width, 0);


}


-(void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;

}
-(void)startTimer
{
    NSTimer *time = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(displayNextImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:time forMode:NSRunLoopCommonModes];
    self.timer = time;
}
-(void)displayNextImage
{
    [self.CarouseBottomView setContentOffset:CGPointMake(2*self.CarouseBottomView.frame.size.width, 0) animated:YES];
    

}

-(void)setImageArrys:(NSMutableArray *)ImageArrys
{
    _ImageArrys = ImageArrys;
    self.pageController.numberOfPages = ImageArrys.count;
    self.pageController.currentPage = 0;
    [self displayImage];
    [self startTimer];


}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
