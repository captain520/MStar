//
//  MSVLCPlayerVC.h
//  CPSpace
//
//  Created by 王璋传 on 2019/5/9.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSVLCPlayerVC : UIViewController

@property (nonatomic, strong) NSString * videoUrl;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *remainTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIButton *fullactoinButton;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

NS_ASSUME_NONNULL_END
