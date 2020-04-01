//
//  FirstViewController.h
//  iOS_Socket
//
//  Created by 李小龙 on 2020/4/1.
//  Copyright © 2020 李小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FirstViewController : UIViewController
typedef void (^udpSocketBlock)(NSDictionary* dic,NSError* err);// block用于硬件返回信息的回调
@property (nonatomic,copy) udpSocketBlock udpSocketBlock;
- (void)sendUdpBoardcast:(udpSocketBlock)block;

@end

NS_ASSUME_NONNULL_END
