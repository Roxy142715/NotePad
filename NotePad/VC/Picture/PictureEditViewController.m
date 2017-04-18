//
//  PictureViewController.m
//  NotePad
//
//  Created by 陈晓磊 on 17/3/7.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "PictureEditViewController.h"

@interface PictureEditViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation PictureEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
    [self setupView];
}

- (void)setNav
{
    self.navigationItem.title = @"图文记事";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存并返回" style:UIBarButtonItemStylePlain target:self action:@selector(saveAndBack)];
}

- (void)saveAndBack
{
    [self saveToFile];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)saveToFile
{
    NSString *fileDate = @"";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    fileDate = [formatter stringFromDate:[NSDate date]];
    
    //将图片转成NSData
    NSData *imgData = UIImageJPEGRepresentation(self.imgView.image, 1.0);
    
    //保存图片
    NSString *cachePath = [FileManager dirLibCache];
    NSString *picturePath =[NSString stringWithFormat:@"%@/%@.png", cachePath, fileDate];
    [imgData writeToFile:picturePath atomically:YES];
    
    //生成配置文件pictureConfig.txt
    
    NSString *configPath = [NSString stringWithFormat:@"%@/pictureConfig.txt", [FileManager dirLib]];
    NSString *configContent = @"";
    
    if (![FileManager isExitsFile:configPath]) [FileManager writeFile:configPath content:@""];
    
    configContent = [NSString stringWithFormat:@"fileDate:%@%@filePath:%@.png%@fileContent:%@%@", fileDate, itemSpe, fileDate, itemSpe, self.textField.text, atricleSpe];
    
    //追加新项
    [FileManager updateFile:configPath newContent:configContent];
    
    //保存到数据库中
    NSDictionary *dataDic = @{@"date" : fileDate, @"content" : self.textField.text, @"picture" : fileDate };
    
    [[SQLiteManager sharedManager] insertData:dataDic intoTable:@
     "picture"];
    
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *addPictureBtn = [[UIButton alloc] init];
    addPictureBtn.titleLabel.font = [UIFont fontWithName:globalFont size:20];
    [addPictureBtn setTitle:@"添加图片" forState:UIControlStateNormal];
    [addPictureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [addPictureBtn addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addPictureBtn];
    self.addPictureBtn = addPictureBtn;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.layer.shadowColor = [UIColor blackColor].CGColor;
    imgView.layer.shadowOffset = CGSizeMake(-2, -2);
    imgView.layer.shadowOpacity = 0.5;
    imgView.layer.shadowRadius = 10;
    imgView.layer.borderWidth = 5;
    imgView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:imgView];
    self.imgView = imgView;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"请写下要说的话";
    [self.view addSubview:textField];
    self.textField = textField;
    
}

- (void)viewDidLayoutSubviews
{
    self.addPictureBtn.frame = CGRectMake(ZScreenW * 0.3, cellMargin * 8, ZScreenW * 0.4, 30);
    self.imgView.frame = CGRectMake(cellMargin, self.addPictureBtn.y + self.addPictureBtn.height + cellMargin, ZScreenW - 2 * cellMargin, 250);
    self.textField.frame = CGRectMake(self.imgView.x, self.imgView.y + self.imgView.height + cellMargin, self.imgView.width, 30);
}


- (void)addPicture
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择图片来源" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *takePictureAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self getPictureFromCamera];
        
    }];
    [alertVC addAction:takePictureAction];
    
    UIAlertAction *imgAlbumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self getPictureFromImgAlbum];
    }];
    [alertVC addAction:imgAlbumAction];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancleAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)getPictureFromCamera
{
    //查看当前设备是否支持使用UIImagePickerController调用相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
       
        //设置拍照后的照片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        ZLog(@"模拟中...无法打开照相机，请在真机中使用!!!");
    }
    
}

- (void)getPictureFromImgAlbum
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    
    //设置选择后的图片可编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        
        //拿到 并 添加 图片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [self dismissViewControllerAnimated:YES completion:^{
            self.imgView.image = image;
        }];
        
    }
}

@end
