import font from '@ohos.font';
import {CommentData1,createListRange} from '../model/CommentData1'
import {pyqItem} from '../view/pyqItem'
import router from '@ohos.router';
export class HotItem{
  id:string='';
  title:string='';
  words:string='';
  img:string='';
  hotpoint:string=''
  url:string=''
  constructor(id:string,title:string,words:string,img:string,hotpoint:string,url:string){
    this.id=id;
    this.title=title;
    this.words=words;
    this.img=img;
    this.hotpoint=hotpoint;
    this.url=url;
  }
}

@Entry
@Component
export struct Tansuo {
  @State message: string = 'Hello World';
  @State commentList: CommentData1[] = createListRange()
  @State tab_index:number=5
  @State HOT_COLUMN_MAX_COUNT:number=5
  @State HOST_LIST_ARRAY:Array<HotItem>=[
    new HotItem('1','黄山','风景优美的一座山',`https://img04.sogoucdn.com/app/a/100520093/3c670571f22cbab3-c0d15de948651440-ba5f7fe8281efe3e4c142e4799d8e1ba.jpg`,'980','https://travel.qunar.com/p-cs300200-huangshan'),
    new HotItem('2','西湖','风景优美的一个湖',`https://imgsa.baidu.com/exp/w=500/sign=6da7d78fc3cec3fd8b3ea775e689d4b6/5bafa40f4bfbfbed7fd11c3c78f0f736aec31fec.jpg`,'890'
    ,'https://travel.qunar.com/p-oi708952-xihufengjingmingsheng'),
    new HotItem('3','扬州','风景优美的一个湖',`https://inews.gtimg.com/newsapp_bt/0/13446233088/1000`,'870','https://travel.qunar.com/p-cs299941-yangzhou'),
    new HotItem('4','泰山','风景优美的一个湖',`https://img04.sogoucdn.com/app/a/100520093/3bd3a77eb2c612b9-92e6d608d3fe11d2-59e043fc001aabd8dd0db92661927111.jpg`,'720','https://travel.qunar.com/p-oi712332-taishanfengjingqu'),
    new HotItem('5','九寨沟','风景优美的一个湖',`http://m.tuniucdn.com/fb2/t1/G1/M00/5A/9C/Cii-U1k6LSyIO0IgAHELK7sVAXcAAMAKgFB-HoAcQtD014.jpg`,'666','https://travel.qunar.com/p-oi703517-jiuzhaigoufengjingqu'),
  ]
  //一加载Index入口页面，就进行注册
  //aboutToAppear->会在组件一加载时，自动调用执行
  aboutToAppear(): void {
    //注册字体
    font.registerFont({
      familyName: 'fontpinlun',
      familySrc: '/font/iconfont.ttf'
    })

  }
  @Builder
  hotListBuilder() {
    Column() {
      List() {
        ForEach(this.HOST_LIST_ARRAY, (item: HotItem, index: number) => {
          ListItem() {
            OneItem({ oneItem: item })
          }

        })
      }
      .width('100%')
      .scrollBar(BarState.On)
    }
    .alignItems(HorizontalAlign.Start)
  }

  handleLike(index: number) {
    //子调用父的方法，每个子都能调用父的方法，需要区分出来
    //由于是数组操作，可以传递下标
    //可以用下标来区分不同的对象
    //父组件的方法，如果抽取出来传递给子组件，会有this的指向问题，
    // this一般直接指向调用者，需要用箭头函数包一层，保证this 还是指向父组件
    //根据index，根据数据，进行判断+1还是-1
    let dataItem = this.commentList[index]
    if (dataItem.isLike) {
      dataItem.likeNum -= 1
    } else {
      dataItem.likeNum += 1
    }
    dataItem.isLike = !dataItem.isLike
    //对于复杂类型：状态对象，状态数组，只会对第一层数据进行监视变化(现在好像升级了,但我的不行）
    this.commentList.splice(index, 1, dataItem)
  }

  build() {
    Scroll() {
      Column() {
        this.hotListBuilder()
        Stack() {

          List() {
            ForEach(this.commentList, (item: CommentData1, index: number) => {
              //将item对象，通过prop传值，传递下去
              ListItem() {
                pyqItem({
                  index: index,
                  itemObj: item,
                })
              }
              .padding(10)
            })
          }.margin({ top: 50 }) //朋友圈内容
        }
      }
    }
  }
}


@Component
export struct OneItem {
  @Prop oneItem: HotItem;
  build() {
    Row() {
      Text(this.oneItem.id)
        .height(20)
        .fontSize(20)
        .fontColor(Color.Orange)
        .margin({ top: 27, right: 5 })
      //左图片
      Image(this.oneItem.img)
        .height(64)
        .width(64)
        .objectFit(ImageFit.Cover)
        .borderRadius(16)
      //左文字
      //文字上下排布
      Column() {
        Text(this.oneItem.title)//标题
          .height(19)
          .width('100%')
          .fontSize(16)
          .textAlign(TextAlign.Start)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontWeight(400)
          .margin({ top: 4 })
          .fontColor(Color.Black)
        Text(this.oneItem.words)//简介
          .height(32)
          .width('100%')
          .fontColor(Color.Black)
          .fontSize(12)
          .textAlign(TextAlign.Start)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(2)
          .fontWeight(400)
          .margin({ top: 5 })
      }
      .height('100%')
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .margin({ right: 12 })
      Row() {
        Text(this.oneItem.hotpoint)
          .fontSize(10)
        Text('\ue6c9')
          .fontSize(10)
          .fontColor(Color.Red)
          .fontFamily('fontpinlun')
      }
      .margin({ left: 5,top:20 })
    }
    .width('100%')
    .height(88)
    .borderRadius(16)
    .padding(12)
    .alignItems(VerticalAlign.Top)
    .onClick(()=>{
      if(this.oneItem){
        router.pushUrl({
          url:'pages/next_tansuo',
          params:{
            'url':this.oneItem.url
          }
        })
      }

    })
  }
}