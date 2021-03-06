//
//  PostCell.h
//  Instapict
//
//  Created by Monica Bui on 7/9/20.
//  Copyright © 2020 fbu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@import Parse;

NS_ASSUME_NONNULL_BEGIN

//@protocol PostCellDelegate
//
//-(void)postCell:(PostCell *)postCell getUser:(NSString *)userObjectId completion:(void (^)(PFUser *, NSError *))completion;
//
//@end

@interface PostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (strong, nonatomic) IBOutlet PFImageView *postPicture;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UILabel *numLikesLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;

@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@property (weak, nonatomic) IBOutlet UILabel *createAtLabel;

@property (nonatomic, strong) Post *post;

//@property (nonatomic, weak) id<PostCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
