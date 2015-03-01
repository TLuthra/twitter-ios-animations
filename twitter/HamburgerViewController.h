//
//  HamburgerViewController.h
//  twitter
//
//  Created by Tanooj Luthra on 2/28/15.
//  Copyright (c) 2015 Tanooj Luthra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HamburgerViewController : UIViewController

@property (strong, nonatomic) UINavigationController *tweetsNavigationViewController;
@property (strong, nonatomic) UINavigationController *mentionsNavigationViewController;

- (void)onHamburger;
- (void)onCompose;

@end
