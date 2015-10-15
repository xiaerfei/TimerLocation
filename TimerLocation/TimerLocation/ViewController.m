//
//  ViewController.m
//  TimerLocation
//
//  Created by xiaerfei on 15/6/15.
//  Copyright (c) 2015年 RongYu100. All rights reserved.
//

#import "ViewController.h"
#import "TimerLocation.h"

@interface ViewController ()
- (IBAction)stopLocation:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,copy) NSMutableString *stingArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
<<<<<<< HEAD
    _stingArray = [[NSMutableString alloc] init];
=======
>>>>>>> 877f20241894dec5fe20e72d98de787265c76915
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

<<<<<<< HEAD

- (IBAction)stopLocation:(id)sender {
    [_stingArray deleteCharactersInRange:NSMakeRange(0,_stingArray.length)];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"loc.plist"];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSArray *array = [mutableDict allKeys];
    for (int i = 0; i < array.count; i++) {
        NSString *string = [NSString stringWithFormat:@"%@--%@\n",array[i],mutableDict[array[i]]];
        [_stingArray appendString:string];
    }
    _textView.text = _stingArray;
=======
- (IBAction)startLocation:(id)sender {
}

- (IBAction)stopLocation:(id)sender {
>>>>>>> 877f20241894dec5fe20e72d98de787265c76915
}
@end
