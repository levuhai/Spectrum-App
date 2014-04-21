//
//  BandPassViewController.h
//  audioRecorder
//
//  Created by Hai Le on 27/2/14.
//  Copyright (c) 2014 Hai Le. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMGraphView;
@class ACScrollView;
@class ACTextField;

@interface BandPassViewController : UIViewController {
    IBOutlet AMGraphView* waveView;
    IBOutlet UIView *colorView;
    IBOutlet UISlider *RSlider;
    IBOutlet UISlider *BSlider;
    IBOutlet UISlider *GSlider;
    
    IBOutlet ACTextField *cutOffTextField;
    IBOutlet ACTextField *bandwidthTextField;
    IBOutlet ACTextField *noiseFloorTextField;
    IBOutlet ACScrollView *scoller;
}

@end
