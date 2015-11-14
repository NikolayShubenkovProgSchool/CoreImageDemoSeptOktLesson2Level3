//
//  FilterPhotoViewController.m
//  CoreImageDemoSeptOktLesson2Level3
//
//  Created by Nikolay Shubenkov on 13/11/15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#import "FilterPhotoViewController.h"

@interface FilterPhotoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *originalImageView;

@property (strong, nonatomic) CIImage *ciimage;
@property (weak, nonatomic) IBOutlet UIImageView *filteredImageView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *filterValue;
@property (weak, nonatomic) IBOutlet UILabel *maxFilterValue;
@property (weak, nonatomic) IBOutlet UILabel *minFilterValue;
@property (strong, nonatomic) CIContext *context;

@end

@implementation FilterPhotoViewController

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

#pragma mark - Setup

- (void)setup {
    //Внутри этого объекта будет происходить вся фильтрация и прочее
    self.context = [CIContext contextWithOptions:nil];
    
    UIImage *image = [UIImage imageNamed:@"HDtimelapse.net_City_1150_hirez"];
    self.originalImageView.image = image;
    self.image = image;
    self.ciimage = [CIImage imageWithCGImage:self.image.CGImage];
    
    
    self.filter = [CIFilter filterWithName:@"CISepiaTone"];
    
    //Дадим на вход изображение
    [self.filter setValue:self.ciimage forKey:kCIInputImageKey];
    
    [self filterImage:@0.8];
}

- (void)filterImage:(id)value {
    
    //Создадим фильтр
    CIFilter *filter = self.filter;
    //Надеюсь,
    NSParameterAssert(filter);
    
    [filter setValue:value forKey:@"inputIntensity"];
    
    
    CIImage *result = [filter outputImage];
    
    //С помощью уже созданного контекста создадим картинку
    CGImageRef resultRef = [self.context createCGImage:result fromRect:[result extent]];
    
    self.filteredImageView.image = [UIImage imageWithCGImage:resultRef];
    
    CGImageRelease(resultRef);
}

#pragma mark - UI Events

- (IBAction)selectPhotoPressed:(id)sender {
    
}

- (IBAction)filterValueChanged:(UISlider *)sender {
    [self filterImage:@( sender.value )];
}



@end
