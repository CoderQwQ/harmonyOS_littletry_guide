import router from '@ohos.router';
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Observed
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

// @Preview
// @Component
// struct Banner{
//   @State BannerList:Array<BannerClass>=[
//     new BannerClass('0',$r('app.media.jingdian1')),
//     new BannerClass('1',$r('app.media.jingdian2')),
//     new BannerClass('2',$r('app.media.jingdian3')),
//     new BannerClass('3',$r('app.media.jingdian4'))
//   ];
//   build() {
//     Swiper(){
//       ForEach(this.BannerList,(item: BannerClass, index:number)=>{
//         Image(item.imgSource)
//           .objectFit(ImageFit.Cover)
//           .width('100%')
//           .height(200)
//           .padding({ top: 11, left: 16, right: 16 })
//           .borderRadius(16)
//       },(item: BannerClass, index:number)=> item.id)
//     }
//     .autoPlay(true)
//     .loop(true)
//     .width('100%')
//
//   }
// }

@Component
export struct Tuijian{
  @Link currentArea:string;

  @State cityname:string=this.currentArea;  //.split(':')[1].split(',')[0].replace('"','').replace('"','')
  @State jingdian1:string='西湖'
  @State jingdian2:string='黄山'
  @State jingdian3:string='西湖'
  @State jingdian4:string='黄山'
  @State jingdian5:string='西湖'
  @State jingdian6:string='黄山'
  @State jingdian7:string='西湖'

  @State ItemArray:Array<Article>=[
    new Article('0',$r('app.media.jingdian1'),'西湖','西湖位于浙江省杭州市西湖区龙井路 1 号，是中国著名的风景名胜区','https://www.heishenhua.com/'),
    new Article('1',$r('app.media.jingdian2'),'黄山','黄山，中国著名的山水风光胜地，以其奇松、怪石、云海、温泉四绝闻名于世',
      'https://www.bilibili.com/video/BV1tM4m1a7bG'),
    new Article('2',$r('app.media.jingdian1'),'泰山','泰山，被誉为“五岳之首”、“天下第一山”，是中国第一个世界文化与自然双重遗产，以其雄伟壮丽的山势和深厚的历史文化内涵著称。',
      'https://www.bilibili.com/video/BV1gr421N7dp'),
    new Article('3',$r('app.media.jingdian3'),'嵩山','嵩山，中国五岳中的中岳，以其深厚的历史文化底蕴和壮丽的自然风光而闻名，是儒释道三教荟萃之地，也是中国佛教禅宗的发源地和道教圣地。',
      'https://www.bilibili.com/video/BV1gr421N7dp'),
    new Article('4',$r('app.media.jingdian4'),'华山','华山，古称“西岳”，是中国五岳之一，以“奇险天下第一山”著称，拥有险峻的山势和丰富的历史文化遗迹。',
      'https://www.bilibili.com/video/BV1gr421N7dp'),
    new Article('5',$r('app.media.jingdian2'),'杭州','',
      'https://www.bilibili.com/video/BV1gr421N7dp'),
    new Article('6',$r('app.media.jingdian3'),'杭州电子科技大学','杭州电子科技大学是一所电子信息特色突出，经管学科优势明显，工、理、经、管、文、法、艺等多学科相互渗透的教学研究型大学\n',
      'https://www.bilibili.com/video/BV1gr421N7dp'),]

  // httprequest(){
  //   let city11=this.currentArea;
  //   let city1=city11.split(':')
  //   //let city12=JSON.parse(JSON.stringify(`${city11}`));
  //   //let cityname1:string=JSON.stringify((city12 as object)?.["cityname"])
  //   let city_name=city1[1].split(',')[0];
  //   let city_position= 13423;                   //city1[2].split(',')[0];
  //   let travel_way=city1[3].split(',')[0];
  //   this.cityname=city_name;
  //
  // }
aboutToAppear(): void {
}
  sendhttp(){
    let httpRequest = http.createHttp();
    httpRequest.on('headersReceive', (header) => {
      console.info('header: ' + JSON.stringify(header));
    });
    let result=encodeURIComponent(this.currentArea)   //.split(':')[1].split(',')[0].replace('"','').replace('"','')
    console.log(result)
    httpRequest.request(
      // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
      `http://10.0.2.2:5000/?userId=3&city=${result}`,
      {
        header: {
          'Content-Type': 'application/json',
        },
        method: http.RequestMethod.GET,
        expectDataType:http.HttpDataType.OBJECT,
        connectTimeout: 60000, // 可选，默认为60000ms
        readTimeout: 60000, // 可选，默认为60000ms

      }, (err: BusinessError, data) => {
      if (!err) {
        // data.result为HTTP响应内容，可根据业务需要进行解析
        console.info('Result:' + JSON.stringify(data.result));
        //console.info('Result:' + JSON.stringify(data.result['recommended_jingdians'][0]));
        if(JSON.stringify(data.result['recommended_jingdians']).length==2){
          this.jingdian1='没有推荐景点'
          this.jingdian2='没有推荐景点'
          this.jingdian3='没有推荐景点'
          this.jingdian4='没有推荐景点'
          this.jingdian5='没有推荐景点'
          this.jingdian6='没有推荐景点'
          this.jingdian7='没有推荐景点'

          this.ItemArray[0].brief=''
          this.ItemArray[1].brief=''
          this.ItemArray[2].brief=''
          this.ItemArray[3].brief=''
          this.ItemArray[4].brief=''
          this.ItemArray[5].brief=''
          this.ItemArray[6].brief=''
        }
        else {
          this.jingdian1=data.result['recommended_jingdians'][0]['name']
          //console.info(this.jingdian1);
          this.jingdian2=data.result['recommended_jingdians'][1]['name']
          this.jingdian3=data.result['recommended_jingdians'][2]['name']
          this.jingdian4=data.result['recommended_jingdians'][3]['name']
          this.jingdian5=data.result['recommended_jingdians'][4]['name']
          this.jingdian6=data.result['remaining_jingdians'][0]['name']
          this.jingdian7=data.result['remaining_jingdians'][1]['name']


          this.ItemArray[0].brief=data.result['recommended_jingdians'][0]['address']
          this.ItemArray[1].brief=data.result['recommended_jingdians'][1]['address']
          this.ItemArray[2].brief=data.result['recommended_jingdians'][2]['address']
          this.ItemArray[3].brief=data.result['recommended_jingdians'][3]['address']
          this.ItemArray[4].brief=data.result['recommended_jingdians'][4]['address']
          this.ItemArray[5].brief=data.result['remaining_jingdians'][0]['address']
          this.ItemArray[6].brief=data.result['remaining_jingdians'][1]['address']
        }

        this.ItemArray[0].title=this.jingdian1;
        this.ItemArray[1].title=this.jingdian2;
        this.ItemArray[2].title=this.jingdian3;
        this.ItemArray[3].title=this.jingdian4;
        this.ItemArray[4].title=this.jingdian5;
        this.ItemArray[5].title=this.jingdian6;
        this.ItemArray[6].title=this.jingdian7;


          // [
          // new Article('0',$r('app.media.jingdian1'),this.jingdian1,'西湖是中国著名的风景名胜区，位于浙江省杭州市西湖区','https://www.heishenhua.com/'),
          // new Article('1',$r('app.media.jingdian2'),this.jingdian2,'黄山风景区是中国著名的旅游胜地，以其独特的自然风光和文化历史价值闻名于世',
          //   'https://www.bilibili.com/video/BV1tM4m1a7bG'),
          // new Article('2',$r('app.media.jingdian1'),'泰山','“五岳之首”和“天下第一山”',
          //   'https://www.bilibili.com/video/BV1gr421N7dp'),
          // new Article('3',$r('app.media.jingdian3'),'嵩山','“五岳之首”和“天下第一山”',
          //   'https://www.bilibili.com/video/BV1gr421N7dp'),
          // new Article('4',$r('app.media.jingdian4'),'华山','“五岳之首”和“天下第一山”',
          //   'https://www.bilibili.com/video/BV1gr421N7dp'),
          // new Article('5',$r('app.media.jingdian2'),'杭州','“五岳之首”和“天下第一山”',
          //   'https://www.bilibili.com/video/BV1gr421N7dp'),
          // new Article('6',$r('app.media.jingdian3'),'杭州电子科技大学','“五岳之首”和“天下第一山”',
          //   'https://www.bilibili.com/video/BV1gr421N7dp')]
        console.log(this.ItemArray[0].title.toString())
        console.info('header:' + JSON.stringify(data.header))
        httpRequest.destroy();
      } else {
        console.error('error:' + JSON.stringify(err));
        httpRequest.off('headersReceive');
        // 当该请求使用完毕时，调用destroy方法主动销毁
        httpRequest.destroy();
      }
    }
    );
  }
  build() {
    Scroll() {
      Column() {
        //`${ ((JSON.parse(this.city))as object)?.['cityname']}`
        Row() {
          //Text('当前所在地:'+this.currentArea.split(':')[1].split(',')[0]);
          Text('当前所在地:'+this.cityname);
          Button('点击生成推荐景点')
            .backgroundColor('#ff1b4f6d')
            .position({right:0,top:25})
            .onClick(()=>{
              this.sendhttp()
            })
        }
        .backgroundColor('#ff5388a0')
        .width('100%')
        .height(100)
        .borderRadius(10)

        Column(){
          List({space:10}){
            ForEach(this.ItemArray, (item:Article) => {
              ListItem(){
                OneItem({
                  oneItem:item,
                  currentarea:this.currentArea
                })
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
    .layoutWeight(1)
    .scrollBar(BarState.Off)
    .align(Alignment.TopStart)
  }
}


@Component
export struct OneItem{
  @ObjectLink oneItem: Article;
  @Link currentarea:string
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
          url:'pages/next_tuijian',
          params:{
            'title':this.oneItem.title,
            'area':this.currentarea
          }
        })
      }

    })
  }
}