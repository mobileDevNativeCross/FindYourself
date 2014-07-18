
#import <UIKit/UIKit.h>
#import <Umoove/UMooveEngine.h>

@class AppDelegate;

@interface ViewController : UIViewController < umooveDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,UIAlertViewDelegate >{
    
    AppDelegate *appDelegate;
    IBOutlet UILabel *labelOne;
    IBOutlet UILabel *labelTwo;
    IBOutlet UILabel *labelThree;
    IBOutlet UILabel *labelFour;
    CFTimeInterval currentTime, previousTime;
    CGVector currentDirections, PreviousDirections;
    int count;
}

@property (retain) AVCaptureSession *captureSession;
-(CGSize)UpdateCursorPos;
- (IBAction)detectPressed:(id)sender;

@end
