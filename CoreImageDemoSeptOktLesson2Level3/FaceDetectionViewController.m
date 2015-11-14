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



@end
