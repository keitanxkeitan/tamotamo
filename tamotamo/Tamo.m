//
//  Tamo.m
//  tamotamo
//
//  Created by 筒井 啓太 on 2014/08/10.
//  Copyright 2014年 keitanxkeitan. All rights reserved.
//

#import "Tamo.h"

@implementation Tamo

//------------------------------------------------------------------------------
#pragma mark - Create & Destroy
//------------------------------------------------------------------------------
+ (Tamo *)tamoWithImage:(CIImage *)image size:(CGSize)size
{
  CIImage* resizedImage = [self resizeImage:image size:size];
  CGImageRef cgImageRef = [self convertCIImageToCGImageRef:resizedImage];
  Tamo* tamo = [Tamo spriteWithCGImage:cgImageRef key:nil];
  [tamo setupPhysics];
  return tamo;
}
//------------------------------------------------------------------------------
+ (Tamo *)tamoWithTamo:(Tamo *)aTamo
{
  Tamo* tamo = [Tamo spriteWithTexture:[aTamo texture]];
  [tamo setupPhysics];
  return tamo;
}
//------------------------------------------------------------------------------
- (void)setupPhysics
{
  self.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(0.f, 0.f, self.boundingBox.size.width, self.boundingBox.size.height) cornerRadius:0.f];
  self.physicsBody.type = CCPhysicsBodyTypeDynamic;
}
//------------------------------------------------------------------------------
- (void)dealloc
{
}
//------------------------------------------------------------------------------
#pragma mark - Image
//------------------------------------------------------------------------------
+ (CIImage *)resizeImage:(CIImage *)image size:(CGSize)size
{
  CGFloat scaleX = size.width / image.extent.size.width;
  CGFloat scaleY = size.height / image.extent.size.height;
  CIImage* resizedImage = [image imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
  return resizedImage;
}
//------------------------------------------------------------------------------
+ (CGImageRef)convertCIImageToCGImageRef:(CIImage *)ciImage
{
  CIContext* context = [CIContext contextWithOptions:nil];
  CGImageRef cgImageRef = [context createCGImage:ciImage fromRect:ciImage.extent];
  return cgImageRef;
}
//------------------------------------------------------------------------------
@end
