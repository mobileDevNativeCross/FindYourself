
#import "ViewController.h"
#import "PictureViewController.h"
#import "ContainerViewController.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <sys/utsname.h>

#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
@implementation ViewController{
    AVCaptureStillImageOutput* stillImageOutput;
    float fXpos,fYpos;
    NSString* modelName;
    
    
    BOOL isIPhone5;
    BOOL isUsingFrontFacingCamera;
    float xCursor;
    float yCursor;
}

@synthesize captureSession;


- (id)init
{
    
    self = [super init];
    if (self) {
    }
    return self;
    
}
- (NSString*)deviceModelName {
    struct utsname systemInfo;
    uname(&systemInfo);
    modelName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if([modelName isEqualToString:@"i386"]) {
        modelName = @"iPhone Simulator";
    }
    else if([modelName isEqualToString:@"iPhone1,1"]) {
        modelName = @"iPhone";
    }
    else if([modelName isEqualToString:@"iPhone1,2"]) {
        modelName = @"iPhone 3G";
    }
    else if([modelName isEqualToString:@"iPhone2,1"]) {
        modelName = @"iPhone 3GS";
    }
    else if([modelName isEqualToString:@"iPhone3,1"]) {
        modelName = @"iPhone4";
    }
    else if([modelName isEqualToString:@"iPhone4,1"]) {
        modelName = @"iPhone4";//S
    }
    else if([modelName isEqualToString:@"iPhone5,1"]) {
        modelName = @"iPhone5";//S
    }
    else if([modelName isEqualToString:@"iPhone5,3"]) {
        modelName = @"iPhone5";//S
    }
    
    else if([modelName isEqualToString:@"iPod1,1"]) {
        modelName = @"iPod 1st Gen";
    }
    else if([modelName isEqualToString:@"iPod2,1"]) {
        modelName = @"iPod 2nd Gen";
    }
    else if([modelName isEqualToString:@"iPod3,1"]) {
        modelName = @"iPod 3rd Gen";
    }
    else if([modelName isEqualToString:@"iPad1,1"]) {
        modelName = @"iPad";
    }
    else if([modelName isEqualToString:@"iPad2,1"]) {
        modelName = @"iPad";
    }
    else if([modelName isEqualToString:@"iPad2,2"]) {
        modelName = @"iPad";
    }
    else if([modelName isEqualToString:@"iPad2,3"]) {
        modelName = @"iPad";
    }
    else if([modelName isEqualToString:@"iPad2,5"]) {
        modelName = @"iPad";
    }
    if ([modelName rangeOfString:@"iPhone5"].location != NSNotFound) {
        NSLog(@"Yes it does contain that word");
        modelName = @"iPhone5";
        isIPhone5 = YES;
    }
    else{
        isIPhone5 = NO;
    }
    NSLog(@"modelName1==%@",modelName);
    return modelName;
}

- (void) viewDidLoad {
    [self deviceModelName];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
//    UIView *border = [[UIView alloc]initWithFrame:CGRectMake(30,435, 322,2 )]; //Y = 90; X = 30 width = 260; height = 345

//    [border setBackgroundColor:[UIColor redColor]];
   
    // enable directions
    [appDelegate.umooveEngine enableDirections:YES];
    [appDelegate.umooveEngine setDirectionsSensitivity:100 CenterZone:0 Levels:500 ];
    
    // enable absolute position
    [appDelegate.umooveEngine enableAbsolutePosition:YES];
    
    // enable cursor
    [appDelegate.umooveEngine enableCursor:YES];
    [appDelegate.umooveEngine setCursorSensitivity:50 HorizontalInitialPosition:.5 VerticalInitialPosition:.5];
    
    // enable speed
    [appDelegate.umooveEngine enableLinearSpeed:YES];
    
    // set high resolution frame if better accuracy is needed. Uses more CPU.
    [appDelegate.umooveEngine setHighResFrame:TRUE];
    
    // set this view controller as umoove's delegate
    [appDelegate.umooveEngine setUmooveDelegate:self];
    
    // add current capture sessions preview layer in order to see the video.
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:appDelegate.umooveEngine.captureSession];
    if([[self deviceModelName] isEqualToString:@"iPhone"])
        [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    else
        [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //    NSLog(@"")
    previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    [self setupCaptureSession];
    [appDelegate.umooveEngine start:NO];
   
    /* AVCaptureSession *session = [[AVCaptureSession alloc] init];
     session.sessionPreset = AVCaptureSessionPresetMedium;
     
     
     AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
     //device.position ;
     NSError *error = nil;
     AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
     [session addInput:input];
     stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
     NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
     [stillImageOutput setOutputSettings:outputSettings];
     
     [session addOutput:stillImageOutput];
     */
    //    [self toggleCamera:self];
//     [self.view addSubview:border];
    
}
-(void) setupCaptureSession {
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetHigh;
    
    //    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer    alloc] initWithSession:session];
    //    [self.view.layer addSublayer:captureVideoPreviewLayer];
    
    NSError *error = nil;
    AVCaptureDevice *device = [self frontFacingCameraIfAvailable];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [session addInput:input];
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [appDelegate.umooveEngine.captureSession addOutput:stillImageOutput];
    
    //    [session startRunning];
}
-(AVCaptureDevice *) frontFacingCameraIfAvailable{
    
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    
    for (AVCaptureDevice *device in videoDevices){
        
        if (device.position == AVCaptureDevicePositionFront){
            
            captureDevice = device;
            break;
        }
    }
    
    //  couldn't find one on the front, so just get the default video device.
    if (!captureDevice){
        
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    return captureDevice;
}

-(void) captureNow {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        // NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        ALAssetsLibraryWriteImageCompletionBlock completionBlock = ^(NSURL *assetURL, NSError *error) {
            if (error) {
                //   if ([[self delegate] respondsToSelector:@selector(captureManager:didFailWithError:)]) {
                //     [[self delegate] captureManager:self didFailWithError:error];
                //}
            }
        };
        if (imageSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
//            const uint8_t *cipherBuffer = (const uint8_t*)[(id)imageSampleBuffer bytes];
//            [appDelegate.umooveEngine proccessFrame:cipherBuffer withWidth:30 withHeight:30];
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            
            UIImage *image = [[UIImage alloc] initWithData:imageData];//gets image
            ////Y = 90; X = 30 width = 260; height = 345
            NSLog(@"imageW==%f",image.size.width);
            
//             if(isIPhone5)
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle: nil];
            
            ContainerViewController *controller = (ContainerViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"ContainerViewController"];
            controller.sourceImage = image;
            controller.delegateCursor = self;
            [self.navigationController pushViewController:controller animated:YES];
            [self presentViewController:controller animated:YES completion:^{
                
            }];
           

            
//            [library writeImageToSavedPhotosAlbum:[image CGImage]
//                                      orientation:(ALAssetOrientation)[image imageOrientation]
//                                  completionBlock:completionBlock];
            [image release];
            
            [library release];
        }
        else
            completionBlock(nil, error);
    }];
    
    
}
- (IBAction)toggleCamera:(id)sender {
    
    AVCaptureDevicePosition newPosition;
    if (!isUsingFrontFacingCamera)
        newPosition = AVCaptureDevicePositionBack;
    else
        newPosition = AVCaptureDevicePositionFront;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
            if ([d position] == newPosition) {
                [appDelegate.umooveEngine.captureSession  beginConfiguration];
                AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
                for (AVCaptureInput *oldInput in [appDelegate.umooveEngine.captureSession  inputs]) {
                    [appDelegate.umooveEngine.captureSession  removeInput:oldInput];
                }
                [appDelegate.umooveEngine.captureSession  addInput:input];
                [appDelegate.umooveEngine.captureSession  commitConfiguration];
           
                //                _deviceID = d.uniqueID;
                NSLog(@"Device: %@", d);
                //                NSLog(@"_deviceID %@", _deviceID);
                if (newPosition == AVCaptureDevicePositionFront) {
                    // for Front camera
                    //[flashlightBtn setTitle:@"Off" forState:UIControlStateNormal];
                    //                    flashMode = AVCaptureFlashModeOff;
                    //                    torchMode = AVCaptureTorchModeOff;
                }
                //break;
            }
        }
        
        isUsingFrontFacingCamera = !isUsingFrontFacingCamera;
        
    });
}


- (IBAction)detectPressed:(id)sender {
    
    if(((fXpos<-1.7 && fXpos>-3.5)|| ((fXpos>-1.7 && fXpos<1.7))) && ((fYpos >13.0 && fYpos<16.0)|| (fYpos >16.0 && fYpos<17.0)) && isIPhone5){
        [self captureNow];
        
        //        [self toggleCamera:self];
    }
    else if(!isIPhone5 &&( fXpos<-1.8 && fXpos>-4.5 && fYpos>3 && fYpos<10))
    {
        [self captureNow];
    }
    else{
        
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"Wrong face position" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [appDelegate.umooveEngine stop];
        [alert show];
    }
}
//FACE ON BORDER = X>=-1,3 && X<=1 Y >10 && Y <13

#pragma mark -- tracker delegate --

// the users angle relative to the center of the device in px.
- (void) UMAbsolutePosition:(float)x :(float)y {
    
    [labelOne setText:[NSString stringWithFormat:@"absolute position %.2f %.2f", x,y]];
//    NSLog(@"absolute position %.2f %.2f", x,y);
    fXpos  =x;
    fYpos = y;
    
}

// the directions values resemble a real joystick.
- (void) UMDirectionsUpdate:(int)x :(int)y {
    
//    NSLog(@"directions %i %i", x, y);
    [labelTwo setText:[NSString stringWithFormat:@"directions %i %i", x, y]];
    
}

// the cursor values are the cursors position on the device.
- (void) UMCursorUpdate:(float)x :(float)y {
    NSUserDefaults *XY = [[NSUserDefaults alloc] init];
    [XY setFloat:x forKey:@"XCursorPos"];
    [XY setFloat:y forKey:@"YCursorPos"];
    [XY synchronize];
    [labelThree setText:[NSString stringWithFormat:@"cursor %.0f %.0f", x, y]];
//    NSLog(@"cursor %f %f", x, y);
    xCursor = x;
     yCursor = y;

    
}
//-(CGSize)UpdateCursorPos{
//    dispatch_async(dispatch_get_main_queue(), ^{ });
//    return CGSizeMake(xCursor, yCursor);
   
    
//}

- (void) UMLinearSpeedUpdate:(float)x :(float)y {
    
//    NSLog(@"speed %f %f", x, y);
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [labelFour setText:[NSString stringWithFormat:@"speed %.2f %.2f", x, y]];
        
    }];
    
    
}

// the states update is called if a change of state occured
- (void) UMStatesUpdate:(int)state {
    
    switch (state) {
            
        case 1:{
            NSLog(@"detected");
            //            alert =   [[UIAlertView alloc]init];
        }
            break;
        case 2:{
            NSLog(@" notdetected");
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"Your face not detected" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [appDelegate.umooveEngine stop];
                [alert show];
            });        }
            break;
        case 3:{
            NSLog(@"lost");
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"Your face lost" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [appDelegate.umooveEngine stop];
                [alert show];
            });
            
            
            
        }
            break;
        default:
            break;
    }
    //    [alert show];
}
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"index==%d",buttonIndex);
    if (buttonIndex == 0){
        //cancel clicked ...do your action
        [appDelegate.umooveEngine start:NO];
    }else{
        //reset clicked
    }
}

- (void)dealloc {
    [labelOne release];
    [labelTwo release];
    [labelThree release];
    [labelFour release];
    [stillImageOutput release];
    [super dealloc];
}
@end
