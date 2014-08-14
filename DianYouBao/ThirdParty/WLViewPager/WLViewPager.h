//
//  WLViewPager.h
//  WLViewPager
//
//  Created by linger on 21/11/13.
//  Copyright (c) 2013年 linger. All rights reserved.
//

/** 使用方法
        1，初始化WLViewPager ,并
         WLViewPager *wlViewPager = [[WLViewPager alloc] initWithWLFrame:CGRectMake(0, 0, 320, 250)];
            
        2. 根据需要设置代理的
        wlViewPager.delegate = self;
        
        3.如果是加载网络照片， 初始化netWorkImagesUrl地址数组 ，如果是本地的初始化localImages图片对象
         wlViewPager.netWorkImagesUrl = [NSArray arrayWithObjects:@"http://img.baidu.com/img/image/zhouweitong.jpg", 
                                                                  @"http://img.baidu.com/img/image/zhouweitong.jpg",nil];
        4. 可以配置pageController点的位置
         wlViewPager.pageControllerXPoint = 150.f;
        5. 设置pageController默认图片和选中图片， 如果不填，默认用系统的小点
         wlViewPager.thumbImage = [UIImage imageNamed:@"login_lost_focus"];
         wlViewPager.seclectImage = [UIImage imageNamed:@"login_get_focus"];
        6.pagecontroller 居中
        wlViewPager.pageControllerAlignmentCenter = YES;
        7. 添加到view即可
         [self.view addSubview:wlViewPager];
         [wlViewPager release];
 */

@protocol WLViewPagerDelegate <NSObject>

@optional

- (void)imageViewDidSelectIndex:(NSNumber *)index;

@end

typedef enum{
    LocalImageType,
    NetworkImageType
} ImageType;

@interface WLViewPager : UIView

@property (nonatomic, assign) BOOL  pageControllerAlignmentCenter;
@property (nonatomic, assign) float pageControllerXPoint;
@property (nonatomic, retain) NSArray *localImages;
@property (nonatomic, retain) NSArray *netWorkImagesUrl;
@property (nonatomic, retain) UIImage *thumbImage;
@property (nonatomic, retain) UIImage *seclectImage;
@property (nonatomic, assign) id <WLViewPagerDelegate> delegate;

- (id)initWithWLFrame:(CGRect)frame;
- (void)startViewPagerTimer;
- (void)stopViewPagerTimer;
- (void)removeWLViewPager;

@end
