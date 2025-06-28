import { text } from '@kit.ArkGraphics2D';
import router from '@ohos.router';
export class Article{
  id: string= '';
  imgSource:ResourceStr = '';
  title:string = '';
  brief:string = '';
  weburl:string= '';


  constructor(id: string, imgSource: ResourceStr, title: string, brief: string, weburl: string) {
    this.id = id
    this.imgSource = imgSource
    this.title = title
    this.brief = brief
    this.weburl = weburl;
  }
}

@Component
@Entry

export struct TansuoZujian{

  @State ItemArray:Array<Article>=[
    new Article('0',$r('app.media.jingdian1'),'西湖','西湖是中国著名的风景名胜区，位于浙江省杭州市西湖区','https://www.heishenhua.com/'),
    new Article('1',$r('app.media.jingdian2'),'黄山','黄山风景区是中国著名的旅游胜地，以其独特的自然风光和文化历史价值闻名于世',
      'https://www.bilibili.com/video/BV1tM4m1a7bG'),
    new Article('2',$r('app.media.jingdian1'),'泰山','“五岳之首”和“天下第一山”',
      'https://www.bilibili.com/video/BV1gr421N7dp'),
    new Article('3',$r('app.media.jingdian3'),'嵩山','“五岳之首”和“天下第一山”',
      'https://www.bilibili.com/video/BV1gr421N7dp'),
    new Article('4',$r('app.media.jingdian4'),'华山','“五岳之首”和“天下第一山”',
      'https://www.bilibili.com/video/BV1gr421N7dp'),
    new Article('5',$r('app.media.jingdian2'),'杭州','“五岳之首”和“天下第一山”',
      'https://www.bilibili.com/video/BV1gr421N7dp'),
    new Article('6',$r('app.media.jingdian3'),'杭州电子科技大学','“五岳之首”和“天下第一山”',
      'https://www.bilibili.com/video/BV1gr421N7dp'),]

  build() {
    Column(){
      List({space:10}){
        ForEach(this.ItemArray, (item:Article) => {
          ListItem(){
            OneItem({oneItem:item})
          }

        }, (item: Article) => item.id)
      }
      .scrollBar(BarState.On)
      .padding({ left: 16, right: 16 })
    }
    .margin({ top: 18 })
    .alignItems(HorizontalAlign.Start)
  }
}

@Component
export struct OneItem{
  @Prop oneItem: Article;

  build() {
    Row(){
      //左文字
      //文字上下排布
      Column(){
        Text(this.oneItem.title)//标题
          .height(19)
          .width('100%')
          .fontSize(16)
          .textAlign(TextAlign.Start)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontWeight(400)
          .margin({ top: 4 })
          .fontColor(Color.White)
        Text(this.oneItem.brief)//简介
          .height(32)
          .width('100%')
          .fontSize(12)
          .textAlign(TextAlign.Start)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(2)
          .fontWeight(400)
          .fontColor('rgba(255, 255, 255, 0.6)')
          .margin({ top: 5 })
      }
      .height('100%')
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .margin({ right: 12 })
      //右图片
      Image(this.oneItem.imgSource)
        .height(64)
        .width(108)
        .objectFit(ImageFit.Cover)
        .borderRadius(16)

    }
    .width('100%')
    .height(88)
    .borderRadius(16)
    .backgroundColor('rgba(32, 30, 32, 0.50)')
    .padding(12)
    .alignItems(VerticalAlign.Top)
    .onClick(()=>{
      if(this.oneItem){
        router.pushUrl({
          url:'pages/tab2_gonglue/openWeb',
          params:this.oneItem
        })
      }

    })
  }
}
