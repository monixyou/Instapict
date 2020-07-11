//
//  PostCell.m
//  Instapict
//
//  Created by Monica Bui on 7/9/20.
//  Copyright © 2020 fbu. All rights reserved.
//

#import "PostCell.h"
#import "Post.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
    _post = post;
    
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height /2;
    self.profilePicture.layer.masksToBounds = YES;
    self.profilePicture.layer.borderWidth = 0;
    
    __weak __typeof(self) weakSelf = self;
    [post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            weakSelf.postPicture.image = [UIImage imageWithData:data];
        }
    }];
    
    self.captionLabel.text = post.caption;
    self.numLikesLabel.text = [NSString stringWithFormat:@"%@", post.likeCount];
    self.usernameLabel.text = post.author.username;
    
    self.profilePicture.image = nil;
    [post.author[@"profilePicture"] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            weakSelf.profilePicture.image = [UIImage imageWithData:data];
        }
    }];
    NSLog(@"%@",self.profilePicture.image);
}

//-(void)postCell:(PostCell *)postCell getUser:(NSString *) userObjectId completion:(void(^)(void))completion;
//
//
//- (IBAction)getUsername:(id)sender {
//
//    [self.delegate postCell:self getUser:self.post.author.objectId completion:^(PFUser *user, NSError *error) {
//        if (error) {
//            NSLog(@"Error: %@", error.localizedDescription);
//        }
//        else {
//            self.usernameLabel.text.
//        }
//    }];
//
//}

-(NSString *)queryUsername:(NSString *)objectId {
    __block NSString *username = @"";
    NSLog(@"%@", objectId);
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:objectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
    {
        if (!error) {
            //You found the user!
            PFUser *queriedUser = (PFUser *)object;
            username = queriedUser.username;
        }
        else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    NSLog(@"%@", username);
    return username;
}

@end
