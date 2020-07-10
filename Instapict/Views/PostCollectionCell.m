//
//  PostCollectionCell.m
//  Instapict
//
//  Created by Monica Bui on 7/9/20.
//  Copyright © 2020 fbu. All rights reserved.
//

#import "PostCollectionCell.h"
#import "Post.h"

@implementation PostCollectionCell

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
}

@end
