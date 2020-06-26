//
//  PostVC.h
//  MyWarehouse
//
//  Created by Administrator on 23.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textTextView;
@property (weak, nonatomic) IBOutlet UILabel *nameAttachLabel;

- (IBAction)addAttachAction:(UIButton *)sender;

- (IBAction)addPostAction:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
