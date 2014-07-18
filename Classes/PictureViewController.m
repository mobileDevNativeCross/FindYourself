//
//  PictureViewController.m
//  FindYourself
//
//  Created by Mac on 14.07.14.
//
//

#import "PictureViewController.h"
#import <sys/utsname.h>
#import "GUIHelper.h"
#import <QuartzCore/QuartzCore.h>

@interface PictureViewController (){
    BOOL isIPhone5;
    NSString *modelName;
    NSArray *faces;
    NSMutableArray *imageviews;
    UIImageView *MergedImage;
    UIImage *merImage;
    UIImageView *glass;
}
@end

@implementation PictureViewController

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
    
                           CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 127.0, 217.0);
//    CGPathAddQuadCurveToPoint(path, NULL,180, 232,127.0, 217.0);
    //CGPathAddArc(path, NULL,127.0, 217.0, 15, 0, 360, YES); //Clockwise
    CGPathAddArc(path, NULL, 127.0, 221.0, 12, 360, 6.24, NO); //Anti Clockwise
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.path = path;
    [pathAnimation setCalculationMode:kCAAnimationCubic];
    [pathAnimation setFillMode:kCAFillModeForwards];
    pathAnimation.duration = 2.0;
    glass = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"glass.png"]];
//    [self.LeftEye.layer addAnimation:pathAnimation forKey:nil];
       faces = [[NSArray alloc] initWithObjects:@"face1.png",@"face2.png",@"face3.png",@"face4.png",@"face4.png",@"face1.png",@"face2.png",@"face3.png",@"face4.png",@"face4.png",@"face1.png",@"face2.png",@"face3.png",@"face4.png",@"face4.png", nil];
    [self deviceModelName];
    
   
}
-(void)generatePictOnView{
    
//    UIImageView *timage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[faces objectAtIndex:0]]];
//    UIImageView *timage2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[faces objectAtIndex:1]]];
//    UIImageView *timage3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[faces objectAtIndex:2]]];
    
    float t = 0;
    float sumW = 0;
    imageviews = [[NSMutableArray alloc] init];
    MergedImage = [[UIImageView alloc] initWithImage:merImage];

   
    for(int i =0;i<3;i++){
        
        [imageviews addObject:[[UIImageView alloc]initWithImage:[UIImage imageNamed:[faces objectAtIndex:i]]]];
        [[imageviews objectAtIndex:i] setTag:i];
    }
    [imageviews addObject:MergedImage];
     for(int i =0;i<[imageviews count];i++){

        NSInteger width = (arc4random() % (90))+30;
         NSInteger angle = (arc4random() % (360));
      NSLog(@"WWW==%d",width);

        CGRect frame1 = self.view.frame;

         
         ((UIImageView*)[imageviews objectAtIndex:i]).image = [self imageByScalingProportionallyToSize:CGSizeMake(width, width) :((UIImageView*)[imageviews objectAtIndex:i]).image];
         
         ((UIImageView*)[imageviews objectAtIndex:i]).image =   [self normarEllipse:((UIImageView*)[imageviews objectAtIndex:i]).image].image;
       
         
         ((UIImageView*)[imageviews objectAtIndex:i]).frame = CGRectMake(sumW, 0, ((UIImageView*)[imageviews objectAtIndex:i]).image.size.width, ((UIImageView*)[imageviews objectAtIndex:i]).image.size.height);
        
       
         
         CGRect frame2 = ((UIImageView*)[imageviews objectAtIndex:i]).frame;
         
         float degrees = angle; //the value in degrees
                     ((UIImageView*)[imageviews objectAtIndex:i]).transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
          NSLog(@"Wieg1===%@",NSStringFromCGRect(frame1));
           [self.view addSubview:(UIImageView*)[imageviews objectAtIndex:i]];
t =         frame2.size.width;
        sumW +=t-frame2.size.height/5;
        NSLog(@"Wieg2===%f",/*NSStringFromCGRect(frame2)*/sumW);
        NSLog(@" delta%f", frame1.size.width-frame2.size.width);
    }
    [self.view addSubview:glass];

}
-(UIImageView* )normarEllipse:(UIImage *)image{
    UIImageView *timage = [[UIImageView alloc]initWithImage:image];
    [timage setBackgroundColor:[UIColor redColor]];
    UIImage * fooImage = image;
    
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size,NO,0.0);
    // create a bezier path defining rounded corners
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0.0, 0.0, CGRectGetWidth(timage.frame), CGRectGetHeight(timage.frame))];
    
    // use this path for clipping in the implicit context
    [path addClip];
    // draw the image into the implicit context
    [fooImage drawInRect:imageRect];
    // save the clipped image from the implicit context into an image
    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
        timage.image=maskedImage;
    
    
    CALayer *imageLayer = timage.layer;
    [imageLayer setCornerRadius:timage.frame.size.height/2];
//    [self.view addSubview:timage];
    return timage;
}
-(CGRect)makeFrameForView: (UIImageView*)theImageView
{
    NSInteger randomX = arc4random() % (300);
    NSInteger randomY = arc4random() % (300);
     NSInteger width = (arc4random() % (20))+100;
    CGRect newFrame = CGRectMake(0, randomY, width, width); // create your new frame here using arc4random etc and the parameters you prefer.
// UIImage *frameImage =    [self imageByScalingProportionallyToSize:CGSizeMake(width, width) :theImageView.image];
    
    NSLog(@"makeFrameForView");
    for (int i = 0; i < [imageviews count]; i++)
    {
        UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[faces objectAtIndex:i]]];
        
        // first, ensure you aren't checking the same view against itself!
        if (theImageView.tag != imageview.tag)
        {
            BOOL intersectsRect = CGRectIntersectsRect(imageview.frame, newFrame);
            
            if (intersectsRect)
                return CGRectZero;
//            else
                // throw an "error" rect we can act upon.
             [self.view addSubview:[imageviews objectAtIndex:i]];
            
        }
    }
//    CGRect framet = newFrame;
//    newFrame.size.height = frameImage.size.height;
//    newFrame.size.width = frameImage.size.width;
    
    return newFrame;
}
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize :(UIImage*) image{
    
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}

- (UIImage *)cropImage:(UIImage *)input inElipse:(CGRect)rect {
    CGRect drawArea = CGRectMake(-rect.origin.x, -rect.origin.y, input.size.width, input.size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, rect.size.width, rect.size.height));
    CGContextClip(ctx);
    
    [input drawInRect:drawArea];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
-(void)getUpdatredXYpositions{
    
    NSUserDefaults *XY = [[NSUserDefaults alloc] init];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        dispatch_async(dispatch_get_main_queue(), ^(void){
//            NSLog(@"XYX==%@", [XY valueForKey:@"XCursorPos"]);
//            NSLog(@"XYY==%@", [XY valueForKey:@"YCursorPos"]);
          /*  if(self.LeftEye.frame.origin.x>=127.0 &&self.LeftEye.frame.origin.x<=157.0 && self.LeftEye.frame.origin.y>=221.0 && self.LeftEye.frame.origin.y<=230.0 && [XY valueForKey:@"XCursorPos"]>0 && [XY valueForKey:@"YCursorPos"]>0){
                
                self.LeftEye.frame = CGRectMake(self.LeftEye.frame.origin.x+1,self.LeftEye.frame.origin.y+1, self.LeftEye.frame.size.width, self.LeftEye.frame.size.height);
                NSLog(@"XYy==%f", self.LeftEye.frame.origin.x);
                NSLog(@"XYy==%f", self.LeftEye.frame.origin.y);
            }
            else if([XY valueForKey:@"XCursorPos"]<0 && [XY valueForKey:@"YCursorPos"]<0){
                
                  self.LeftEye.frame = CGRectMake(self.LeftEye.frame.origin.x-1,self.LeftEye.frame.origin.y-1, self.LeftEye.frame.size.width, self.LeftEye.frame.size.height);

            
            }
            else{
//                 self.LeftEye.frame = CGRectMake(127,221, self.LeftEye.frame.size.width, self.LeftEye.frame.size.height);
            }*/
            glass.frame  = CGRectMake([[XY valueForKey:@"XCursorPos"] floatValue],[[XY valueForKey:@"YCursorPos"] floatValue], glass.frame.size.width, glass.frame.size.height);
//
            
        });
    });
   
    [XY synchronize];
    
}
-(void)MergeImages{
     NSLog(@"DELVC===%@",self.delegateCursor);

    dispatch_async(dispatch_get_main_queue(), ^{
  NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getUpdatredXYpositions) userInfo:nil repeats:YES];
    });
//    [timer release];
//   [self.delegateCursor performSelector:@selector(UpdateCursorPos) withObject:nil];
    CGFloat imageWidth,imageHeight;
    imageWidth = self.sourceImage.size.width;
    imageHeight = self.sourceImage.size.height;
    
    // Fixing export to camera roll
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if([GUIHelper isIPadretina]){
            
            (imageWidth <= 1536 ? imageWidth = 1536 : imageWidth);
            (imageHeight <= 2008 ? imageHeight = 2008 : imageWidth);
        }else{
            (imageWidth <= 768 ? imageWidth = 768 : imageWidth);
            (imageHeight <= 1004 ? imageHeight = 1004 : imageWidth);
        }
    }
    else{
        if([GUIHelper isPhone5]){
            (imageWidth <= 640 ? imageWidth = 640 : imageWidth);
            (imageHeight <= 1136 ? imageHeight = 1136 : imageWidth);
        }else{
            (imageWidth <= 320 ? imageWidth = 320 : imageWidth);
            (imageHeight <= 480 ? imageHeight = 480 : imageWidth);
            
        }
    }
    
    UIImage *scaledImage2 = [GUIHelper imageByScaling: self.sourceImage toSize: CGSizeMake(imageWidth, imageHeight)];
    UIImage *scaledImage = [GUIHelper imageByCropping:scaledImage2 toRect:CGRectMake(55, 270, imageWidth-120, imageHeight/1.775)];
    
    UIImage *ellipseImg = [self cropImage:scaledImage inElipse:CGRectMake(17, 0, imageWidth-120, imageHeight/1.775)];
//    self.imageView.image = ellipseImg;
    
    
    UIImage *hatImage = [UIImage imageNamed:@"faceWholeCenter.png"];
    UIImage *personImage= ellipseImg;
    
    CGSize finalSize = CGSizeMake(111, 160);
    CGSize hatSize = [hatImage size];
    NSLog(@"hatSizeeWidth2==%f",hatSize.width);
    NSLog(@"hatSizeHeight2==%f",ellipseImg.size.width);
    UIGraphicsBeginImageContext(finalSize);
    
    
    [personImage drawInRect:CGRectMake((hatSize.width-hatSize.width/1.5)/2+3,35,hatSize.width/1.5/*1.5*/,hatSize.height/1.5)];
    [hatImage drawInRect:CGRectMake(0,0,hatSize.width,hatSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    /*
     UIImage *personImage = [UIImage imageNamed:@"faceWhole.png"];
     UIImage *hatImage = self.imageView.image;
     
     CGSize finalSize = [personImage size];
     CGSize hatSize = [hatImage size];
     UIGraphicsBeginImageContext(finalSize);
     [personImage drawInRect:CGRectMake(0,0,finalSize.width,finalSize.height)];
     [hatImage drawInRect:CGRectMake(0,0,finalSize.width,finalSize.height)];
     UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     */
    merImage = newImage;
   //    self.imageView.image = newImage;
    [self generatePictOnView];
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)dealloc {
    [_imageView release];
    [_sourceImage release];
    [_LeftEye release];
    [_RightEye release];
    [super dealloc];
    
}
- (IBAction)LOGGG:(id)sender {
   
     NSLog(@"IMAGE====%@",self.sourceImage);
}
@end
