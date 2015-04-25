//
//  WCProfileViewController.m
//  WeChat
//
//  Created by 刘超 on 15/4/24.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "WCProfileViewController.h"
#import "XMPPvCardTemp.h"
#import "WCPhotoPickerView.h"

@interface WCProfileViewController () <UIAlertViewDelegate, WCPhotoPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@property (weak, nonatomic) IBOutlet UILabel *orgnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orgunitLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation WCProfileViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人信息";
    
    [self loadvCard];
}

- (void)loadvCard {
    
    XMPPvCardTemp *myvCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    
    self.iconView.layer.cornerRadius = 4.0f;
    self.iconView.clipsToBounds = YES;
    
    if (myvCard.photo) {
        self.iconView.image = [UIImage imageWithData:myvCard.photo];
    }
    self.nicknameLabel.text = myvCard.nickname;
    self.userLabel.text = [WCUserInfo sharedWCUserInfo].user;
    self.orgnameLabel.text = myvCard.orgName;
    if (myvCard.orgUnits.count) {
        self.orgunitLabel.text = [myvCard.orgUnits firstObject];
    }
    self.titleLabel.text = myvCard.title;
    self.phoneLabel.text = myvCard.note;
    self.emailLabel.text = myvCard.mailer;
}

#pragma mark - UITableView 代理方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.tag == 2) {        // 照片
        
        if (IPAD) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"拍照", @"从手机相册选择", nil];
            [alert show];
            
        } else {
            
            WCPhotoPickerView *picker = [[WCPhotoPickerView alloc] init];
            picker.frame = CGRectMake(0, 0, WINSIZE.width, WINSIZE.height);
            [self.view.window addSubview:picker];
            [picker showPickerViewToView:self.view delegate:self];
        }
        
    } else if (cell.tag == 1) { // 修改
        
        
    }
}

#pragma mark - WCPhotoPickerView 代理方法

- (void)photoPickerViewSourceTypeCamera:(WCPhotoPickerView *)pickerView {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)photoPickerViewSourceTypePhotoLibrary:(WCPhotoPickerView *)pickerView {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController & UINavigationController 代理方法

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.iconView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - UIAlertView 代理方法

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {         // 拍照
        
        if (SIMULATOR) {            // 模拟器
            
            UIAlertView *tip = [[UIAlertView alloc] initWithTitle:@"您的设备不支持拍照。"
                                                          message:nil
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [tip show];
            
        } else {
            
            [self photoPickerViewSourceTypeCamera:nil];
        }
        
    } else if (buttonIndex == 2) {  // 相册
        
        [self photoPickerViewSourceTypePhotoLibrary:nil];
    }
}

@end