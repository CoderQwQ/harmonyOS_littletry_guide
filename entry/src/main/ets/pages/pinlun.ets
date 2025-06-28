import InfoTop from '../view/InfoTop'
import {InfoItem1} from '../view/InfoItem'
import font from '@ohos.font';
import {infoBottom} from '../view/infobottom'
import {CommentData,createListRange} from '../model/CommentData'
import json from '@ohos.util.json';
// let listArr:CommentData[]=createListRange()
// console.log('数组列表',json.stringify(listArr))
@Entry
@Component
export struct Pinlun {
  @State commentList:CommentData[]=createListRange()
  //一加载Index入口页面，就进行注册
  //aboutToAppear->会在组件一加载时，自动调用执行
  aboutToAppear(): void {
    //注册字体
    font.registerFont({
      familyName:'fontpinlun',
      familySrc:'/font/iconfont.ttf'
    })

  }
  //处理点赞
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
    //this.commentList.splice(index,1,dataItem)
  }
 // 处理提交
  handleSubmit(content:string){
      const newItem:CommentData=new CommentData(`https://fastly.picsum.photos/id/439/600/600.jpg?hmac=LC9k_bzrN0NhKRyV62fou3ix3cRFZKNfAyXgxGs6zh8`, "Varin", new Date().getTime(), Math.floor(Math.random()*100),content , false)
      this.commentList= [newItem , ...this.commentList]
  }
  //处理排序  0最新 1最热
  handleSort(type:number){
    if(type===0){
      //时间戳从大到小排序
      this.commentList.sort((a,b)=>{
        //b为后一项，a为前一项
        return b.time-a.time//返回值大于0交换位置
      })
    }else if(type===1){
      this.commentList.sort((a,b)=>{
        //b为后一项，a为前一项
        return b.likeNum-a.likeNum//返回值大于0交换位置
      })
    }
  }

  @Builder
  listBar(){
      List() {
        ForEach(this.commentList, (item: CommentData, index: number) => {
          //将item对象，通过prop传值，传递下去
          ListItem() {
            InfoItem1({
              index: index,
              itemObj: item,
              onLikeClick: (index: number) => {
                //此处的this访问的外部环境的this就是父组件
                this.handleLike(index)
              },
            })
          }
          .padding(10)
        })
      }
      .width('100%')
      .layoutWeight(1) //让容器高度自适应
      .listDirection(Axis.Vertical) //调整主轴方向
      .lanes(1, 20) //调整列数和间距
      .divider({
        strokeWidth: 1, //线宽
        color: Color.Gray,
        startMargin: 10 //左边线距离边缘的间隙
      })
    }
  build() {
      Column() {
        //头部标题组件
        InfoTop({
          onSort: (type: number) => {
            this.handleSort(type)
          }
        })
        this.listBar()
        infoBottom({
          onSubmitComment: (content: string) => {
            this.handleSubmit(content)
          }
        })

      }
      .width('100%')
      .height('100%')
      }

}

function InfoItem() {
  throw new Error('Function not implemented.');
}
