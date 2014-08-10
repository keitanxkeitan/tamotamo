//
//  Tamo.h
//  tamotamo
//
//  Created by 筒井 啓太 on 2014/08/10.
//  Copyright 2014年 keitanxkeitan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//------------------------------------------------------------------------------
/**
 *  タモ
 */
@interface Tamo : CCSprite {
    
}
//------------------------------------------------------------------------------
+ (Tamo *)tamoWithImage:(CIImage *)image size:(CGSize)size;
+ (Tamo *)tamoWithTamo:(Tamo *)aTamo;
//------------------------------------------------------------------------------
@end
