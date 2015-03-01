//
//  HamburgerViewController.m
//  twitter
//
//  Created by Tanooj Luthra on 2/28/15.
//  Copyright (c) 2015 Tanooj Luthra. All rights reserved.
//

#import "HamburgerViewController.h"
#import "TweetsViewController.h"
#import "MentionsViewController.h"
#import "ProfileViewController.h"
#import "MenuViewController.h"
#import "ComposeViewController.h"

@interface HamburgerViewController () <MenuViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *menuView;

//@property (strong, nonatomic) TweetsViewController *tweetsViewController;

@property (strong, nonatomic) ProfileViewController *profileViewController;

@property (strong, nonatomic) MenuViewController *menuViewController;

@property (assign, nonatomic) CGPoint originalCenter;


@end

@implementation HamburgerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.menuViewController = [[MenuViewController alloc] init];
    self.menuViewController.delegate = self;
    
    TweetsViewController *tvc = [[TweetsViewController alloc] init];
    tvc.hamburgerViewController = self;
    
    self.tweetsNavigationViewController = [[UINavigationController alloc] initWithRootViewController:tvc];
    
    self.profileViewController = [[ProfileViewController alloc] init];
    
    MentionsViewController *mvc = [[MentionsViewController alloc] init];
    mvc.hamburgerViewController = self;
    
    self.mentionsNavigationViewController = [[UINavigationController alloc] initWithRootViewController:mvc];
    
    [self.menuView addSubview:self.menuViewController.view];
    
    self.originalCenter = CGPointMake(self.contentView.center.x, self.contentView.center.y);
    
    self.contentView.autoresizesSubviews = NO;
    
    [self onSelectHome];
}

- (void)closeMenu {
    [self.menuViewController closeMenu];
    
    [UIView animateWithDuration:0.25 delay:0 options:0 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)openMenu {
    [self.menuViewController openMenu];
    
    [UIView animateWithDuration:0.25 delay:0 options:0 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.contentView.transform = CGAffineTransformTranslate(self.contentView.transform, 300, 0);
    } completion:^(BOOL finished) {
        
    }];
}
- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint velocity = [sender velocityInView:sender.view];
    CGPoint location = [sender locationInView:sender.view];
    CGPoint translation = [sender translationInView:sender.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        if (velocity.x > 0) {
            [self openMenu];
        } else if (velocity.x < 0) {
            [self closeMenu];
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
    }
    
}

- (void)onHamburger {
    if (self.contentView.frame.origin.x == 0) {
        [self openMenu];
    } else {
        [self closeMenu];
    }
    
}

- (void)onSelectHome {
    NSLog(@"selected Home");
//    self.tweetsNavigationViewController.navigationBar = [[UINavigationBar alloc] init];

    [self addChildViewController:self.tweetsNavigationViewController];
//    self.tweetsNavigationViewController.view.frame = self.contentView.frame;
    [self.contentView addSubview:self.tweetsNavigationViewController.view];
    [self closeMenu];
    [self.tweetsNavigationViewController didMoveToParentViewController:self];
}

- (void)onSelectProfile {
    NSLog(@"selected onSelectProfile");
    self.profileViewController.user = [User currentUser];
//    self.profileViewController.view.frame = self.contentView.frame;
    [self.contentView addSubview:self.profileViewController.view];

    [self closeMenu];
    self.profileViewController.view.frame = self.contentView.frame;
}

- (void)onSelectMentions {
    [self addChildViewController:self.mentionsNavigationViewController];
    //    self.tweetsNavigationViewController.view.frame = self.contentView.frame;
    [self.contentView addSubview:self.mentionsNavigationViewController.view];
    [self closeMenu];
    [self.mentionsNavigationViewController didMoveToParentViewController:self];
}

- (void)onLogout {
    [User logout];
}

- (void)onCompose {
    NSLog(@"on compose pressed");
    [self.tweetsNavigationViewController pushViewController:[[ComposeViewController alloc] init] animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
