import font from '@ohos.font';
import {CommentData1,createListRange} from '../model/CommentData1'
import {pyqItem} from '../view/pyqItem'
@Entry
@Component
export struct pyq {
  @State message: string = 'Hello World';
  @State commentList:CommentData1[]=createListRange()
  //一加载Index入口页面，就进行注册
  //aboutToAppear->会在组件一加载时，自动调用执行
  aboutToAppear(): void {
    //注册字体
    font.registerFont({
      familyName:'fontpinlun',
      familySrc:'/font/iconfont.ttf'
    })

  }
  handleLike(index:number){
    //子调用父的方法，每个子都能调用父的方法，需要区分出来
    //由于是数组操作，可以传递下标
    //可以用下标来区分不同的对象
    //父组件的方法，如果抽取出来传递给子组件，会有this的指向问题，
    // this一般直接指向调用者，需要用箭头函数包一层，保证this 还是指向父组件
    //根据index，根据数据，进行判断+1还是-1
    let dataItem = this.commentList[index]
    if (dataItem.isLike) {
      dataItem.likeNum -=1
    }else{
      dataItem.likeNum +=1
    }
    dataItem.isLike = !dataItem.isLike
    //对于复杂类型：状态对象，状态数组，只会对第一层数据进行监视变化(现在好像升级了,但我的不行）
    this.commentList.splice(index,1,dataItem)
  }
    build() {
    Scroll() {
      Column() {
        Stack() {
          Row() {
            Image($r('app.media.jingdian4'))
          }
          .width('100%')
          .height(270) //朋友圈背景
          .zIndex(1)

          Row() {
            Text('Guard')
              .fontSize(25)
              .fontColor(Color.White)
          }
          .position({ x: 200, y: 240 })
          .zIndex(222)

          Row() {
          }
          .position({ x: 280, y: 230 })
          .width(80)
          .height(80)
          .backgroundColor(Color.Blue)
          .borderRadius(15) //头像和名字
          .zIndex(20)
        }

        List() {
          ForEach(this.commentList, (item: CommentData1, index: number) => {
            //将item对象，通过prop传值，传递下去
            ListItem() {
              pyqItem({
                index: index,
                itemObj: item,
                // onLikeClick: (index: number) => {
                //   //此处的this访问的外部环境的this就是父组件
                //   this.handleLike(index)
                // },
              })
            }
            .padding(10)
          })
        } .margin({top:50})//朋友圈内容

      }
    }
    }

}