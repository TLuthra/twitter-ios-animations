//
//  MenuViewController.m
//  twitter
//
//  Created by Tanooj Luthra on 2/28/15.
//  Copyright (c) 2015 Tanooj Luthra. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) IBOutlet UIButton *profileButton;
@property (strong, nonatomic) IBOutlet UIButton *mentionsButton;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    UIGraphicsBeginImageContext(self.backgroundImageView.bounds.size);
    [self.backgroundImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = self.backgroundImageView.image;
    UIGraphicsEndImageContext();
    
    //Blur the UIImage with a CIFilter
    CIImage *imageToBlur = [CIImage imageWithCGImage:viewImage.CGImage];
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:imageToBlur forKey: @"inputImage"];
    [gaussianBlurFilter setValue:[NSNumber numberWithFloat: 75] forKey: @"inputRadius"];
    CIImage *resultImage = [gaussianBlurFilter valueForKey: @"outputImage"];
    UIImage *endImage = [[UIImage alloc] initWithCIImage:resultImage];
    self.backgroundImageView.image = endImage;
    [self.backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
}

- (void)openMenu {
    NSLog(@"opening menu");
}

- (void)closeMenu {
    NSLog(@"closing menu");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onHomeSelected:(UIButton *)sender {
    [self.delegate onSelectHome];
}
- (IBAction)onProfileSelected:(UIButton *)sender {
    [self.delegate onSelectProfile];
}
- (IBAction)onMentionsSelected:(UIButton *)sender {
    [self.delegate onSelectMentions];
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
