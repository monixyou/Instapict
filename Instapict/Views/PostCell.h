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

@interface PostCell : UITableViewCell

@property (strong, nonatomic) IBOutlet PFImageView *postPicture;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@property (nonatomic, strong) Post *post;

@end

NS_ASSUME_NONNULL_END
