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
    
    __weak __typeof(self) weakSelf = self;
    [post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            weakSelf.postPicture.image = [UIImage imageWithData:data];
        }
    }];
    
    self.captionLabel.text = post.caption;
    self.numLikesLabel.text = [NSString stringWithFormat:@"%@", post.likeCount];;
}

@end
