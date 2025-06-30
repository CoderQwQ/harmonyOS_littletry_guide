import {Person} from "./Setting"
import {MapDemo} from "./mapstation"
import {Tuijian} from './tuijian'
import {Tansuo}from './tansuo'
import font from '@ohos.font';
import router from '@ohos.router';
import {LocationService} from './mapservice'
import { connection } from '@kit.NetworkKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Index]'

@Entry
@Component
struct Index {
  @State currentArea:string=''
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()
  aboutToAppear(): void {
    //注册字体
    font.registerFont({
      familyName:'fontpinlun',
      familySrc:'/font/iconfont.ttf'
    })


  }


  // 自定义导航页签的样式
  @Builder TabBuilder(title: string, targetIndex: number, selectedImg: string, normalImg: string) {
    Column() {
      Text(selectedImg)
        .fontSize(25)
        .fontFamily('fontpinlun')
        .fontColor(this.currentIndex === targetIndex ? '#28bff1' : '#8a8a8a')
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#28bff1' : '#8a8a8a')
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex
      this.controller.changeIndex(this.currentIndex)
    })
  }

  build() {
    Column() {
      Tabs({
        barPosition: BarPosition.End,
        controller: this.controller
      }) {
        TabContent() {
          Column() {
            // 标题栏
            Text("地图")
              .size({ width: '100%', height: 50 })
              .backgroundColor("#ffacafb1")
              .fontColor("#ff0c0c0c")
              .textAlign(TextAlign.Center)
              .fontSize("18fp")
            // 内容项
            //Text("地图").width('100%').height('100%').textAlign(TextAlign.Center).fontSize("25fp")
            // MapDemo({
            //   currentArea:this.currentArea
            // })
            LocationService()
          }.size({ width: '100%', height: '80%' })
        }.tabBar(this.TabBuilder('地图', 0,  '\ue622','\ueb37'))

        TabContent() {
          Column() {
            // 标题栏
            Row() {
              Text("探索")
                .size({ width: '100%', height: 50 })
                .backgroundColor("#fff6f6f6")
                .fontColor("#ff131111")
                .textAlign(TextAlign.Center)
                .fontSize("18fp")
              Text('\ue604')
                .fontFamily('fontpinlun')
                .fontSize(30)
                .position({x:320,y:15})
                .onClick(() => {
                  router.pushUrl({
                    url:'pages/pyqcreate'
                });
              })
            }
               Tansuo()
          }.size({ width: '100%', height: '100%' })
        }.tabBar(this.TabBuilder('探索', 1,'\ueb3a','\ue72b'))

        TabContent() {
          Column() {
            // 标题栏
            Text("景点推荐")
              .size({ width: '100%', height: 50 })
              .backgroundColor("#ffb0b0ba")
              .fontColor("#ff0e0909")
              .textAlign(TextAlign.Center)
              .fontSize("18fp")
            Tuijian({
              currentArea:this.currentArea
            })
          }.size({ width: '100%', height: '100%' })
        }.tabBar(this.TabBuilder('推荐', 2, '\ueb38','\ue623'))

        TabContent() {
          Column() {
            Person()
          }.size({ width: '100%', height: '100%' })
        }.tabBar(this.TabBuilder('个人', 3,  '\ueb39','\ue62d'))
      }.scrollable(false) // 禁止滑动切换
    }
    .width('100%')
    .height('100%')
  }
}