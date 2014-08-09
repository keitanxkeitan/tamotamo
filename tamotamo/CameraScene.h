//
//  CameraScene.h
//  tamotamo
//
//  Created by 筒井 啓太 on 2014/08/09.
//  Copyright 2014年 keitanxkeitan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//------------------------------------------------------------------------------
/**
 *  カメラシーン
 */
@interface CameraScene : CCScene<UINavigationBarDelegate, UIImagePickerControllerDelegate> {
    
}
//------------------------------------------------------------------------------
+ (CameraScene *)scene;
- (id)init;
//------------------------------------------------------------------------------
@end
