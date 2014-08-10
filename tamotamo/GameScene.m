//
//  GameScene.m
//  tamotamo
//
//  Created by 筒井 啓太 on 2014/08/10.
//  Copyright 2014年 keitanxkeitan. All rights reserved.
//

#import "GameScene.h"
#import "Tamo.h"


@implementation GameScene
{
  CCPhysicsNode*  physicsNode_;
  int             tamoTypeNum_;
  NSMutableArray* smallTamoListList_;
  NSMutableArray* largeTamoListList_;
  int             tamoNum_;
  CCTime          timeSinceLastActivate_;
}

//------------------------------------------------------------------------------
# pragma mark - Create & Destroy
//------------------------------------------------------------------------------
+ (GameScene *)sceneWithFaceImageList:(NSArray *)faceImageList
{
  return [[self alloc] initWithFaceImageList:faceImageList];
}
//------------------------------------------------------------------------------
- (id)initWithFaceImageList:(NSArray *)faceImageList
{
  // Apple recommend assigning self with supers return value
  self = [super init];
  
  if (!self)
  {
    return nil;
  }
  
  // ビューサイズ
  CGSize viewSize = [[CCDirector sharedDirector] viewSize];
  
  // 物理
  physicsNode_ = [CCPhysicsNode node];
  physicsNode_.gravity = ccp(0.f, -100.f);
  physicsNode_.collisionDelegate = self;
  [self addChild:physicsNode_];
  
  // 地面
  CCNode* ground = [CCNode node];
  ground.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(0.f, -50.f, viewSize.width, 50.f) cornerRadius:0.f];
  ground.physicsBody.type = CCPhysicsBodyTypeStatic;
  [physicsNode_ addChild:ground];
  
  // 壁
  CCNode* wallLeft = [CCNode node];
  wallLeft.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(-50.f, 0.f, 50.f, viewSize.height) cornerRadius:0.f];
  wallLeft.physicsBody.type = CCPhysicsBodyTypeStatic;
  [physicsNode_ addChild:wallLeft];
  
  CCNode* wallRight = [CCNode node];
  wallRight.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(viewSize.width, 0.f, 50.f, viewSize.height) cornerRadius:0.f];
  wallRight.physicsBody.type = CCPhysicsBodyTypeStatic;
  [physicsNode_ addChild:wallRight];
  
  NSAssert([faceImageList count] > 0, @"face image list is empty.");
  
  // タモの種類
  tamoTypeNum_ = (int)[faceImageList count];
  
  // タモリストのリストを生成
  smallTamoListList_ = [NSMutableArray array];
  largeTamoListList_ = [NSMutableArray array];
  
  // 顔画像リストを走査
  for (CIImage* faceImage in faceImageList)
  {
    // 小タモ
    Tamo* smallTamo = [Tamo tamoWithImage:faceImage size:CGSizeMake(50.f, 50.f)];
    NSAssert(smallTamo.texture != nil, @"nil!!");
    NSMutableArray* smallTamoList = [NSMutableArray array];
    for (int i = 0; i < 20; ++i)
    {
      [smallTamoList addObject:[Tamo tamoWithTamo:smallTamo]];
    }
    [smallTamoListList_ addObject:smallTamoList];
    
    // 大タモ
    Tamo* largeTamo = [Tamo tamoWithImage:faceImage size:CGSizeMake(100.f, 100.f)];
    NSMutableArray* largeTamoList = [NSMutableArray array];
    for (int i = 0; i < 2; ++i)
    {
      [largeTamoList addObject:[Tamo tamoWithTamo:largeTamo]];
    }
    [largeTamoListList_ addObject:largeTamoList];
  }
  
  // タモの数
  tamoNum_ = 0;
  
  return self;
}
//------------------------------------------------------------------------------
- (void)dealloc
{
  
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
}
//------------------------------------------------------------------------------
- (void)onExit
{
  // always call super onExit last
  [super onExit];
}
//------------------------------------------------------------------------------
#pragma mark - Update
//------------------------------------------------------------------------------
-(void)update:(CCTime)delta
{
  timeSinceLastActivate_ += delta;
  
  if ((tamoNum_ < 50) &&
      (timeSinceLastActivate_ >= 0.5f))
  {
    const int type = rand() % tamoTypeNum_;
    const BOOL isLarge = rand() % 10 == 0;
    
    Tamo* tamo = [self activateTamo:type isLarge:isLarge];
    if (tamo)
    {
      CGSize viewSize = [[CCDirector sharedDirector] viewSize];
      tamo.position = ccp(viewSize.width * CCRANDOM_0_1(), viewSize.height);
      ++tamoNum_;
      timeSinceLastActivate_ = 0.f;
    }
  }
}
//------------------------------------------------------------------------------
#pragma mark - Tamo
//------------------------------------------------------------------------------
-(Tamo *)activateTamo:(int)type isLarge:(BOOL)isLarge
{
  NSArray* tamoListList = isLarge ? largeTamoListList_ : smallTamoListList_;
  NSAssert(type < tamoTypeNum_, @"invalid tamo type %d.", type);
  NSArray* tamoList = tamoListList[type];
 
  // タモリストを走査
  for (Tamo* tamo in tamoList)
  {
    // 既にアクティブ
    if ([tamo parent])
    {
      continue;
    }
    
    [physicsNode_ addChild:tamo];
    return tamo;
  }
  
  return nil;
}
//------------------------------------------------------------------------------
@end
