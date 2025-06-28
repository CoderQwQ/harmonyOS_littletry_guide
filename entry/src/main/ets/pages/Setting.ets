import {router} from "@kit.ArkUI"
import { url } from '@kit.ArkTS'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { fileIo } from '@kit.CoreFileKit'
import { image } from '@kit.ImageKit';
import font from '@ohos.font';
import { InputMethodListDialog } from '@ohos.inputMethodList'

@Entry
@Component
export struct Person {
  @State name:string='用户名'
  @State img:Resource|image.PixelMap=$r('app.media.background')
  @State isShow: Boolean = false;
  aboutToAppear(): void {
    //注册字体
    font.registerFont({
      familyName:'fontpinlun',
      familySrc:'/font/iconfont.ttf'
    })

  }
  @Builder
  myBuilder() {
    Column() {
      TextInput({
        placeholder:'修改名字',
        text:$$this.name  //添加$$可以实现双向绑定
      }).margin({top:30})
      Button('完成修改')
        .onClick(()=>{
          this.isShow = false
        })
    }
  }
  @Builder personzujian( name:string,normalImg: Resource,nexturl:string) {
    Row(){
      Column(){
        Image(normalImg).objectFit(ImageFit.Fill)
      }.width(80)
      .height(60)
      .padding({right:20})
      Text(name)
        .fontSize(20)
        .margin({left:20})
      Row(){ Text('>').fontSize(25)}
        .alignItems(VerticalAlign.Bottom)
        .position({x:320,y:25})

    }.backgroundColor(Color.White)
    .width('100%')
    .height(80)
    .borderStyle(BorderStyle.Solid)
    .borderColor('#ffc2c6c6')
    .borderWidth(1)
    .onClick(()=>{
      router.pushUrl({
          url:nexturl
      })
    })
    }


  build() {
    Column() {
      Row() {
        //Text('头像')
        Row() {
          Image(this.img)
            .width(70)
            .height(70)
            .margin({ left: 20 })
            .borderRadius(10)
        }.onClick(()=>{
          let picker= new photoAccessHelper.PhotoViewPicker()//唤起对话框 获取图片url
          let options:photoAccessHelper.PhotoSelectOptions={
            MIMEType:photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE,
            maxSelectNumber:1 //选择最大的图片数
          }
          picker.select(options).then((value:photoAccessHelper.PhotoSelectResult)=>{
            //选择图片的地址
            let uri=value.photoUris[0]
            let file=fileIo.openSync(uri)
            //file-->imagesouse-->pixelmap
            let source:image.ImageSource=image.createImageSource(file.fd)
            let decodingoptions:image.DecodingOptions={
              editable:true,
              desiredPixelFormat:3
            }
            source.createPixelMap(decodingoptions).then((value:image.PixelMap)=>{
              this.img=value
            })
          })
        })

        Text(this.name)
          .fontSize(20)
          .fontColor(Color.Black)
          .margin({left:5,bottom:20})
        Text('\ue603')
          .fontSize(25)
          .fontColor(Color.Black)
          .fontFamily('fontpinlun')
          .margin({left:5,bottom:20})
          .onClick(()=>{
            this.isShow = true
          })
          .bindSheet($$this.isShow, this.myBuilder(), {
            height: 150,
            blurStyle: BlurStyle.Thick,
            showClose: false,
            //title: { title: "title", subtitle: "subtitle" },
            preferType: SheetType.CENTER,
            onWillDismiss: ((DismissSheetAction: DismissSheetAction) => {
              if (DismissSheetAction.reason == DismissReason.SLIDE_DOWN) {
                DismissSheetAction.dismiss() //注册dismiss行为
              }
            }),

            onWillSpringBackWhenDismiss: ((SpringBackAction: SpringBackAction) => {
              SpringBackAction.springBack()
            }),
          })
      }.width('100%')
      .height(160)
      .backgroundColor(Color.White)
      .margin({bottom:40})

      //个人头像
      this.personzujian('账号信息',$r('app.media.person_square_fill'),'pages/practice')
      this.personzujian('好友',$r('app.media.checkmark_square_fill'),'pages/page1')
      this.personzujian('个人朋友圈',$r('app.media.square_and_pencil_fill'),'pages/personpyq')
      this.personzujian('收藏',$r('app.media.heart_square_stack_fill'),'pages/shoucang')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ffdee7e7')
  }

}