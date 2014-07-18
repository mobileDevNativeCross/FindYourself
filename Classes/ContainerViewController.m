//
//  ContainerViewController.m
//  FindYourself
//
//  Created by Mac on 15.07.14.
//
//

#import "ContainerViewController.h"
#import "HeaderViewController.h"

@interface ContainerViewController ()

@end

@implementation ContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    for (UIViewController *viewController in _parentViewController) {
    
//        NSLog(@"viewController==%@",viewController);
//    }
    // Do any additional setup after loading the view.
    for (UIViewController *viewController in self.childViewControllers) {
//        NSLog(@"viewController==%@",viewController);
        if([viewController isKindOfClass:[PictureViewController class]]){
            self.runTableViewController = (PictureViewController *)viewController;
            self.runTableViewController.sourceImage = self.sourceImage;
             self.delegatePict = self.runTableViewController;
            NSLog(@"IMMM==%@",self.delegatePict);
             self.runTableViewController.delegateCursor = self.delegateCursor;
            
            [self.delegatePict performSelector:@selector(MergeImages) withObject:nil];
            
            for (UIViewController *viewController in self.childViewControllers) {
                
                if([viewController isKindOfClass:[HeaderViewController class]]){
                    self.headerViewController = (HeaderViewController *)viewController;
                    self.headerViewController.delegate = self;
                    
                    self.delegate = self.headerViewController;
                    
                }
            }
//            self.headerViewController.delegate =(id)self;
            self.runTableViewController.delegate = (id)self;
           
            NSLog(@"DelegateP==%@",self.runTableViewController.delegateCursor);
//            NSLog(@"Delegate2==%@",self.headerViewController.delegate2);
        }
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)CloseViewContainer{
    NSLog(@"CloseView");
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
