//
//  PictureViewController.h
//  FindYourself
//
//  Created by Mac on 14.07.14.
//
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface PictureViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *sourceImage;
@property (nonatomic, strong) PictureViewController *delegate;
@property (nonatomic, strong) UIViewController *delegateCursor;

@property (retain, nonatomic) IBOutlet UIImageView *LeftEye;
@property (retain, nonatomic) IBOutlet UIImageView *RightEye;

- (IBAction)LOGGG:(id)sender;
-(void)MergeImages;

@end
