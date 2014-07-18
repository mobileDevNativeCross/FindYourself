//
//  ContainerViewController.h
//  FindYourself
//
//  Created by Mac on 15.07.14.
//
//

#import <UIKit/UIKit.h>
#import "PictureViewController.h"
@class HeaderViewController;
@class ViewController;
@interface ContainerViewController : UIViewController
@property (retain, nonatomic) HeaderViewController *headerViewController;

@property (retain, nonatomic) PictureViewController *runTableViewController;


@property (nonatomic, strong) HeaderViewController *delegate;
@property (nonatomic, strong) PictureViewController *delegatePict;
@property (nonatomic, strong) ViewController *delegateCursor;

@property (strong, nonatomic) UIImage *sourceImage;
-(void) CloseViewContainer;
@end
