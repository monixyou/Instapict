//
//  PostCollectionCell.h
//  Instapict
//
//  Created by Monica Bui on 7/9/20.
//  Copyright © 2020 fbu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *postPicture;

@property (nonatomic, strong) Post *post;

@end

NS_ASSUME_NONNULL_END
