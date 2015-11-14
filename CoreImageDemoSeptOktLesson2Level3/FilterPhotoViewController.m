//
//  FilterPhotoViewController.m
//  CoreImageDemoSeptOktLesson2Level3
//
//  Created by Nikolay Shubenkov on 13/11/15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#import "FilterPhotoViewController.h"

@import AssetsLibrary;

#import <CZPhotoPickerController/CZPhotoPickerController.h>
#import "CIFilter+SpExtention.h"

@interface FilterPhotoViewController ()

@property (strong, nonatomic) CIImage *ciimage;
@property (weak, nonatomic) IBOutlet UIImageView *originalImageView;
@property (weak, nonatomic) IBOutlet UIImageView *filteredImageView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *filterValue;
@property (weak, nonatomic) IBOutlet UILabel *maxFilterValue;
@property (weak, nonatomic) IBOutlet UILabel *minFilterValue;
@property (strong, nonatomic) CIContext *context;
@property (strong, nonatomic) CZPhotoPickerController *photoPicker;

@end

@implementation FilterPhotoViewController

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
//    [CIFilter sp_allFilteres];
    self.image = [UIImage imageNamed:@"HDtimelapse.net_City_1150_hirez"];
    [self setup];
    
}

#pragma mark - Setup

-(void)setup {
    
    self.context = [CIContext contextWithOptions:nil];

    
    self.originalImageView.image = self.image;
//    self.image = image;
    
    self.ciimage = [CIImage imageWithCGImage:self.image.CGImage];
    
    self.filter = [CIFilter filterWithName:@"CISepiaTone"];
    [self.filter setValue:self.ciimage forKey:kCIInputImageKey];
    
    [self filterImage:@0.8];
}

-(void)filterImage:(id)value {
    
    CIFilter *filter = self.filter;
    
    
    NSParameterAssert(filter);
    
    [filter setValue:value forKey:@"inputIntensity"];
    
    
    CIImage *result = [filter outputImage];
    
    CGImageRef resultRef = [self.context createCGImage:result fromRect:[result extent]];
    
    
    self.filteredImageView.image = [UIImage imageWithCGImage:resultRef];
    
    CGImageRelease(resultRef);
    
    
}

#pragma mark - UI Events
- (IBAction)saveCameraPressed:(id)sender {
    
    UIImage *image = self.filteredImageView.image;
    ALAssetsLibrary *library = [ALAssetsLibrary new];
    [library writeImageToSavedPhotosAlbum:image.CGImage
                              orientation:self.image.imageOrientation
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              if (error) {
                                  NSLog(@"Warning. Did not save to gallery");
                              }
                          }];
    
}

- (IBAction)selectPhotoPressed:(id)sender {
    
    self.photoPicker = [[CZPhotoPickerController alloc] initWithCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict) {
        UIImage *image = [imageInfoDict valueForKey:UIImagePickerControllerEditedImage];
        if (!image) {
            image = [imageInfoDict valueForKey:UIImagePickerControllerOriginalImage];
        }
        
        if (image) {
            self.image = image;
            [self setup];
        }
        
        [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    self.photoPicker.allowsEditing = YES;
    [self.photoPicker presentFromViewController:self];
    
}
- (IBAction)showComlexFilter:(id)sender {
    
    CIFilter *sepiaFilter = [CIFilter filterWithName:@"CISepiaTone"];
    [sepiaFilter setValue:self.ciimage forKey:kCIInputImageKey];
    
    [sepiaFilter setValue:@(self.slider.value) forKey:@"inputIntensity"];
    
    CIFilter *randomFilter = [CIFilter filterWithName:@"CIRandomGenerator"];
    
    CIFilter *brightFilter = [CIFilter filterWithName:@"CIColorControls"];
    
    [brightFilter setValue:@0.5 forKey:@"inputBrightness"];
    [brightFilter setValue:0 forKey:@"inputSaturation"];
    [brightFilter setValue:randomFilter.outputImage forKey:kCIInputImageKey];
    
    CIImage *randomNoiseImage = [[brightFilter outputImage] imageByCroppingToRect:self.ciimage.extent];
    
    CIFilter *lightBlend = [CIFilter filterWithName:@"CIHardLightBlendMode"];
    [lightBlend setValue:sepiaFilter.outputImage forKey:kCIInputImageKey];
    
    [lightBlend setValue:randomNoiseImage forKey:kCIInputBackgroundImageKey];
    
    CIFilter *finalFilter = [CIFilter filterWithName:@"CIVignette"];
    [finalFilter setValue:lightBlend.outputImage forKey:kCIInputImageKey];
    [finalFilter setValue:@3 forKey:@"inputIntensity"];
    [finalFilter setValue:@20 forKey:@"inputRadius"];
    
    
    CIImage *result = [finalFilter outputImage];
    
    CGImageRef resultRef = [self.context createCGImage:result fromRect:[result extent]];
    
    
    self.filteredImageView.image = [UIImage imageWithCGImage:resultRef];
    
    CGImageRelease(resultRef);
    
}

- (IBAction)filterValueChanged:(UISlider *)sender {
    
    [self filterImage:@( sender.value )];
}




@end








