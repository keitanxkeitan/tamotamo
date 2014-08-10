//
//  CameraScene.m
//  tamotamo
//
//  Created by 筒井 啓太 on 2014/08/09.
//  Copyright 2014年 keitanxkeitan. All rights reserved.
//

#import "CameraScene.h"
#import "GameScene.h"
#import "IntroScene.h"

@implementation CameraScene

//------------------------------------------------------------------------------
#pragma mark - Create & Destroy
//------------------------------------------------------------------------------
+ (CameraScene *)scene
{
  return [[self alloc] init];
}
//------------------------------------------------------------------------------
- (id)init
{
  // Apple recommend assigning self with supers return value
  self = [super init];
  
  if (!self)
  {
    return nil;
  }
  
  return self;
}
//------------------------------------------------------------------------------
- (void)dealloc
{
  // clean up code goes here
}
//------------------------------------------------------------------------------
#pragma mark - Enter & Exit
//------------------------------------------------------------------------------
- (void)onEnter{
  // always call super onEnter first
  [super onEnter];
  
  // In pre-v3, touch enable and scheduleUpdate was called here
  // In v3, touch is enabled by setting userInteractionEnabled for the individual nodes
  // Per frame update is automatically enabled, if update is overridden
}
//------------------------------------------------------------------------------
- (void)onEnterTransitionDidFinish
{
  [super onEnterTransitionDidFinish];
  
  // カメラ画面を表示する
  [self showCameraView_];
}
//------------------------------------------------------------------------------
- (void)onExit
{
  // always call super onExit last
  [super onExit];
}
//------------------------------------------------------------------------------
#pragma mark - Camera
//------------------------------------------------------------------------------
- (void)showCameraView_
{
  // カメラ利用不可
  if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
  {
    return;
  }
  
  UIImagePickerController* imagePickerCtrl = [[UIImagePickerController alloc] init];
  imagePickerCtrl.delegate = (id)self;
  imagePickerCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
  imagePickerCtrl.wantsFullScreenLayout = YES;
  imagePickerCtrl.allowsEditing = NO;
  
  // モーダルビューとして表示する
  [[CCDirector sharedDirector] presentModalViewController:imagePickerCtrl animated:NO];
}
//------------------------------------------------------------------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  // モーダルビューを閉じる
  [picker dismissModalViewControllerAnimated:NO];
  
  // 顔画像をトリミングする
  NSArray* faceImageList = [self trimFaceImage_:info];
  
  if ([faceImageList count] > 0)
  {
    // ゲームシーンへ遷移    
    GameScene* scene = [GameScene sceneWithFaceImageList:faceImageList];
    [[CCDirector sharedDirector] replaceScene:scene
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
  }
  else
  {
    // アラート表示
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"タモタモ" message:@"顔検出できませんでした。もう一度撮影してください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
    // シーン再入場
    CameraScene* scene = [CameraScene scene];
    [[CCDirector sharedDirector] replaceScene:scene
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
  }
}
//------------------------------------------------------------------------------
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  // モーダルビューを閉じる
  [picker dismissModalViewControllerAnimated:NO];
  
  // タイトルシーンへ遷移
  IntroScene* scene = [IntroScene scene];
  [[CCDirector sharedDirector] replaceScene:scene
                             withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
}
//------------------------------------------------------------------------------
- (NSArray *)trimFaceImage_:(NSDictionary *)info
{  
  // 検出器を生成
  CIDetector* detector = nil;
  {
    NSDictionary* options = [NSDictionary dictionaryWithObject:CIDetectorAccuracyLow forKey:CIDetectorAccuracy];
    detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
  }
  
  // 撮影した画像を取得
  CIImage* ciImage = nil;
  {
    UIImage* originalImage = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
    ciImage = [[CIImage alloc] initWithCGImage:originalImage.CGImage];
  }
  
  // 検出
  NSArray* featureList = nil;
  {
    NSDictionary* options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:6] forKey:CIDetectorImageOrientation];
    featureList = [detector featuresInImage:ciImage options:options];
  }
  
  // 顔画像リスト
  NSMutableArray* faceImageList = [NSMutableArray array];
  
  // 検出されたデータを走査
  for (CIFaceFeature* feature in featureList)
  {
    if (!feature.hasLeftEyePosition ||
        !feature.hasRightEyePosition ||
        !feature.hasMouthPosition)
    {
      continue;
    }
    
    // トリミング
    CIImage* trimmedImage = [ciImage imageByCroppingToRect:feature.bounds];
    
    // トリミングした画像の向きを整える
    trimmedImage = [trimmedImage imageByApplyingTransform:CGAffineTransformMakeRotation(-M_PI_2)];
    
    [faceImageList addObject:trimmedImage];
  }
  
  return faceImageList;
}
//------------------------------------------------------------------------------
@end
