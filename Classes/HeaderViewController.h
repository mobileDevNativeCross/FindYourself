//
//  HeaderViewController.h
//  FindYourself
//
//  Created by Mac on 15.07.14.
//
//

#import <UIKit/UIKit.h>
#import "ContainerViewController.h"
@interface HeaderViewController : UIViewController
- (IBAction)BackAction:(id)sender;

@property (nonatomic, strong)  ContainerViewController*delegate;
@end
