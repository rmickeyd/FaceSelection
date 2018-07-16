//
//  ViewController.m
//  FaceSelection
//
//  Created by Daniel Lau on 4/26/18.
//  Copyright © 2018 Curious Kiwi Co. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.loadingIndicator.hidden = NO;
    [self.loadingIndicator startAnimating];
    self.imageView.image = nil;
    self.textView.text = nil;
    
    // Image URL: https://s3-us-west-2.amazonaws.com/precious-interview/ios-face-selection/family.jpg
    // JSON URL: https://s3-us-west-2.amazonaws.com/precious-interview/ios-face-selection/family_faces.json
    // JSON contents documentation: https://westus.dev.cognitive.microsoft.com/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236

    // TODO: Start your project here
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
