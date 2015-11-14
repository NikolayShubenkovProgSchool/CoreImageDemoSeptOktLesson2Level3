//
//  FaceDetectionViewController.m
//  CoreImageDemoSeptOktLesson2Level3
//
//  Created by Nikolay Shubenkov on 14/11/15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#import "FaceDetectionViewController.h"

#import <CZPhotoPickerController/CZPhotoPickerController.h>

@interface FaceDetectionViewController()

@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) CZPhotoPickerController *photoPicker;

@end

@implementation FaceDetectionViewController

- (void)setup {
    self.imageView.image = self.image;
}

#pragma mark - UI Events

- (IBAction)selectPhotoPressed:(UIButton *)sender {
    self.photoPicker = [[CZPhotoPickerController alloc]initWithCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict) {
        UIImage *image = [imageInfoDict valueForKey:UIImagePickerControllerEditedImage];
        if (!image){
            image = [imageInfoDict valueForKey:UIImagePickerControllerOriginalImage];
        }
        if (image){
            self.image = image;
            [self setup];
        }
        
        [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }];
    self.photoPicker.allowsEditing = YES;
    [self.photoPicker presentFromViewController:self];
}

- (IBAction)showFacePressed:(id)sender {
    [self showFace];
}

- (void)showFace {
    
    if (!self.image){
        return;
    }
    
    CIImage *face = [CIImage imageWithCGImage:self.image.CGImage];
    
    NSDictionary *options = @{
                              CIDetectorAccuracy : CIDetectorAccuracyHigh
                              };
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace
                                                  context:nil
                                                  options:options];
    NSArray *faces = [faceDetector featuresInImage:face];
    [self drawFaces:faces onImage:self.image];
}

- (void)drawFaces:(NSArray *)faces onImage:(UIImage *)image {
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1, -1);
    
//    CGFloat scale = [UIScreen mainScreen].scale;
    
//    CGContextScaleCTM(context, 1 / scale, 1 / scale);
    
    for (CIFaceFeature *face in faces){
        [self drawFaceInRect:face.bounds];
        
        if (face.hasLeftEyePosition){
            [self drawEye:face.leftEyePosition forFace:face.bounds];
        }
        if (face.hasRightEyePosition){
            [self drawEye:face.rightEyePosition forFace:face.bounds];
        }
        if (face.hasMouthPosition){
            [self drawLips:face.mouthPosition forFace:face.bounds];
        }
    }
    
    UIImage *faceImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageView.image = faceImage;
}

- (void)drawFaceInRect:(CGRect) rect {
    UIBezierPath *aPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    aPath.lineWidth = 3;
    
    [[UIColor blueColor] setStroke];
    [[[UIColor yellowColor] colorWithAlphaComponent:0.1] setFill];
    
    [aPath fill];
    [aPath stroke];
}

- (void)drawEye:(CGPoint)eyeCenter forFace:(CGRect)faceRect {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:eyeCenter
                                                        radius:CGRectGetWidth(faceRect) / 8
                                                    startAngle:0
                                                      endAngle:M_PI * 2
                                                     clockwise:YES];
    path.lineWidth = CGRectGetWidth(faceRect) / 50;
    [[[UIColor blueColor]colorWithAlphaComponent:0.4] setFill];
    [[UIColor blueColor] setStroke];
    
    [path fill];
    [path stroke];
}

- (void)drawLips:(CGPoint)lipsCenter forFace:(CGRect)faceRect {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:lipsCenter
                                                        radius:CGRectGetWidth(faceRect) / 5
                                                    startAngle:0
                                                      endAngle:M_PI
                                                     clockwise:YES];
    [[[UIColor redColor]colorWithAlphaComponent:0.4] setFill];
    [path fill];
}

@end
