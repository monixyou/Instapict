//
//  ProfileViewController.m
//  Instapict
//
//  Created by Monica Bui on 7/9/20.
//  Copyright © 2020 fbu. All rights reserved.
//

#import "ProfileViewController.h"
#import "PostCollectionCell.h"
#import "Post.h"
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray<Post *> *recentPosts;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) UIImage *postPhoto;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height /2;
    self.profilePicture.layer.masksToBounds = YES;
    self.profilePicture.layer.borderWidth = 0;
    
    [self getRecentPosts];
    
    self.usernameLabel.text = [PFUser currentUser].username;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    CGFloat posterPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (posterPerLine - 1)) / posterPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)getRecentPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;

    // fetch data asynchronously
    __weak __typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if (posts != nil) {
            // do something with the array of object returned by the call
            strongSelf.recentPosts = [NSMutableArray arrayWithArray:posts];
            [strongSelf.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
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

- (IBAction)didTapGallery:(id)sender {
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
    
    CGSize size = CGSizeMake(self.profilePicture.frame.size.width, self.profilePicture.frame.size.height);
    self.postPhoto = [self resizeImage:editedImage withSize:size];
    
    [self uploadProfilePicture];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)uploadProfilePicture {
    if (self.postPhoto == nil) {
        // raise alert
    }
    else {
        PFUser *user = [PFUser currentUser];
        user[@"profilePicture"] = [self getPFFileFromImage:self.postPhoto];
        
        __weak __typeof(self) weakSelf = self;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                __strong __typeof(self) strongSelf = weakSelf;
                [strongSelf.profilePicture setImage:strongSelf.postPhoto];
            }
        }];
    }
}

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}


#pragma mark - Collection View Delegate

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionCell" forIndexPath:indexPath];
    
    cell.post = self.recentPosts[indexPath.row];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.recentPosts.count;
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
