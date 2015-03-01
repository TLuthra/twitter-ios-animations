//
//  MenuViewController.h
//  twitter
//
//  Created by Tanooj Luthra on 2/28/15.
//  Copyright (c) 2015 Tanooj Luthra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuViewController;

@protocol MenuViewControllerDelegate <NSObject>

- (void)onSelectHome;
- (void)onSelectProfile;
- (void)onSelectMentions;

@end

@interface MenuViewController : UIViewController

@property (nonatomic, strong) id<MenuViewControllerDelegate> delegate;

- (void)openMenu;
- (void)closeMenu;


@end
