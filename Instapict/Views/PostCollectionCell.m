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
    
    [post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            self.postPicture.image = [UIImage imageWithData:data];
        }
    }];
}

@end
