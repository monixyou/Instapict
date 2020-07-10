//
//  NewPostViewController.m
//  Instapict
//
//  Created by Monica Bui on 7/7/20.
//  Copyright © 2020 fbu. All rights reserved.
//

#import "NewPostViewController.h"
#import <UIKit/UIKit.h>
#import "Post.h"

@interface NewPostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *postPhoto;
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;

@end

@implementation NewPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapCamera:(id)sender {
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        // TODO: change to alert instead
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSLog(@"Camera 🚫 available so we will use photo library instead");
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)didTapPhotoAlbum:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    CGSize size = CGSizeMake(self.postPhoto.frame.size.width, self.postPhoto.frame.size.height);
    UIImage *resizedImage = [self resizeImage:editedImage withSize:size];
    
    [self.postPhoto setImage:resizedImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapShare:(id)sender {
    if (self.postPhoto.image == nil) {
        // raise alert
    }
    else {
        [Post postUserImage:self.postPhoto.image withCaption:self.captionTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            }
            else {
                NSLog(@"Post successfully shared!");
                [self resetView];
            }
        }];
    }
    
    
}

- (void)resetView {
    self.postPhoto.image = nil;
    self.captionTextView.text = @"";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
