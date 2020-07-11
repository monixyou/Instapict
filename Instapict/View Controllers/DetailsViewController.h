//
//  DetailsViewController.h
//  Instapict
//
//  Created by Monica Bui on 7/9/20.
//  Copyright © 2020 fbu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostCell.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet PostCell *postCellView;
@property (nonatomic, strong) Post *post;

@end

NS_ASSUME_NONNULL_END
