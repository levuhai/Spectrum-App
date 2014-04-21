//
//  BandPassViewController.m
//  audioRecorder
//
//  Created by Hai Le on 27/2/14.
//  Copyright (c) 2014 Hai Le. All rights reserved.
//

#import "BandPassViewController.h"
#import "AudioController.h"
#import "AMGraphView.h"
#import "ACScrollView.h"
#import "ACTextField.h"
#import "UIColor+Expanded.h"

@interface BandPassViewController () <UITextFieldDelegate>  {
    AudioController *_audioController;
    NSTimer *_timer;
}
@end

@implementation BandPassViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _audioController = [AudioController sharedInstance];
    
    [self startDrawing];
    
    [waveView setMinVal:0 maxVal:75];
    
    // Textfield
    [cutOffTextField setDelegate:self];
    [cutOffTextField setPlaceholderColor:[UIColor colorWithHexString:@"#16A085"]];
    [cutOffTextField setFloatingLabelActiveTextColor:[UIColor colorWithHexString:@"#1ABC9C"]];
    
    [noiseFloorTextField setDelegate:self];
    [noiseFloorTextField setPlaceholderColor:[UIColor colorWithHexString:@"#16A085"]];
    [noiseFloorTextField setFloatingLabelActiveTextColor:[UIColor colorWithHexString:@"#1ABC9C"]];
    
    [bandwidthTextField setDelegate:self];
    [bandwidthTextField setPlaceholderColor:[UIColor colorWithHexString:@"#16A085"]];
    [bandwidthTextField setFloatingLabelActiveTextColor:[UIColor colorWithHexString:@"#1ABC9C"]];

}

- (void)waveViewUpdate{
    [waveView addX:0 y:_audioController.bpf z:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)startDrawing {
    if (![_timer isValid]) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.015 target:self selector:@selector(waveViewUpdate) userInfo:nil repeats:YES];
    }
}

- (void)stopDrawing {
    [_timer invalidate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopDrawing];
    _audioController.bpGraphColor = [UIColor colorWithRed:RSlider.value green:GSlider.value blue:BSlider.value alpha:1];
}

- (void)viewWillAppear:(BOOL)animated {
    [self startDrawing];
    // Display color view
    [colorView setBackgroundColor:_audioController.bpGraphColor];
    
    // Set value for sliders
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [colorView.backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
    RSlider.value = red;
    BSlider.value = blue;
    GSlider.value = green;
    
    // Set value text field
    cutOffTextField.text = [NSString stringWithFormat:@"%.0f",_audioController.bpfFreq1];
    bandwidthTextField.text = [NSString stringWithFormat:@"%.0f",_audioController.bpfFreq2];

    noiseFloorTextField.text = [NSString stringWithFormat:@"%.0f",_audioController.bpNoiseFloor];
}

- (void)updateColor {
    _audioController.bpGraphColor = [UIColor colorWithRed:RSlider.value green:GSlider.value blue:BSlider.value alpha:1];
}

#pragma Actions

- (IBAction)RBGChanged:(id)sender {
    [colorView setBackgroundColor:[UIColor colorWithRed:RSlider.value green:GSlider.value blue:BSlider.value alpha:1]];
    [self updateColor];
    [waveView setNeedUpdate];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    float value;
    if (textField.text.length == 0) {
        value = 50;
        textField.text = [NSString stringWithFormat:@"%.0f",value];
    } else {
        value = [textField.text floatValue];
    }
    
    if (textField == cutOffTextField) {
        _audioController.bpfFreq1 = value;
    } else if (textField == noiseFloorTextField) {
        _audioController.bpNoiseFloor = value;
    } else if (textField == bandwidthTextField) {
        _audioController.bpfFreq2 = value;
    }

}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

@end
