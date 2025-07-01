import router from '@ohos.router';
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { LocationInter, ViewpointInter } from '../model/LocationInter';

@Observed
export class Article{
  id:number
  city:string
  cover_image:ResourceStr
  description:string
  distance_km:number
  latitude:number
  longitude:number
  name:string
  rating:number
  score:number

  constructor(id:number, city: string, cover_image: ResourceStr, description: string, distance_km: number, latitude: number,
    longitude:number,name:string, rating:number, score:number) {
    this.id = id
    this.city = city
    this.cover_image = cover_image
    this.description = description
    this.distance_km = distance_km
    this.latitude = latitude
    this.longitude = longitude
    this.name = name
    this.rating = rating
    this.score = score
  }
}

interface recommendedjingdian{
  city:string
  cover_image:ResourceStr
  description:string
  distance_km:number
  latitude:number
  longitude:number
  name:string
  rating:number
  score:number

}

@Component
export struct Tuijian{
  @Link @Watch("WatchLocalityChanged")locality:string;
  @Link @Watch("WatchLocationChanged")location:LocationInter;
  @Link RecommenderViewpointArray:Array<ViewpointInter>;

  @State cityname:string=this.locality;  //.split(':')[1].split(',')[0].replace('"','').replace('"','')


  @State ItemArray:Array<Article>=[]

  aboutToAppear(): void {
  }

  WatchLocationChanged(){
    console.info("tuijian side:"+String(this.location))
  }
  WatchLocalityChanged(){
    console.info("tuijian side:"+this.locality)
  }

  //向服务端发送数据
  sendhttp(){
    let httpRequest = http.createHttp();
    httpRequest.on('headersReceive', (header) => {
      console.info('header: ' + JSON.stringify(header));
    });
    //let result=encodeURIComponent(this.currentArea)   //.split(':')[1].split(',')[0].replace('"','').replace('"','')
    let cityname_url = encodeURIComponent(this.cityname)
    if (this.cityname.endsWith("市")) {
      cityname_url =encodeURIComponent(this.cityname.slice(0, -1));
    }

    let lat = this.location.latitude
    let lon = this.location.longitude
    console.log(cityname_url)

    httpRequest.request(
      // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
      `http://192.168.3.16:5000/recommend?n=5&city=${cityname_url}&lat=${lat}&lon=${lon}`,
      {
        header: {
          'Content-Type': 'application/json',
        },
        method: http.RequestMethod.GET,
        expectDataType:http.HttpDataType.OBJECT,
        connectTimeout: 60000, // 可选，默认为60000ms
        readTimeout: 60000, // 可选，默认为60000ms

      }, (err: BusinessError, response: http.HttpResponse) => {
        if (!err) {
          // data.result为HTTP响应内容，可根据业务需要进行解析
          console.info("type of response" + typeof response.result)
          console.info('Result:' + JSON.stringify(response.result));
          //console.info('Result:' + JSON.stringify(data.result['recommended_jingdians'][0]));

          if (response.responseCode == http.ResponseCode.OK){
            try {
              const items = response.result['recommended_jingdians'] as recommendedjingdian[]
              const tempArtical:Array<Article> = []
              const tempRecommenderViewpointArray:Array<ViewpointInter>=[]
              for (let i = 0;i < items.length; i++){
                console.info(`第${i}个景点：${items[i].name}`)
                console.info(items[i].name)
                tempArtical.push(new Article(
                  i,
                  items[i].city,
                  items[i].cover_image,
                  items[i].description,
                  items[i].distance_km,
                  items[i].latitude,
                  items[i].longitude,
                  items[i].name,
                  items[i].rating,
                  items[i].score
                ))
                tempRecommenderViewpointArray.push({
                  latitude:items[i].latitude,
                  longitude:items[i].longitude,
                  viewpointname:items[i].name
                })
              }
              this.ItemArray = tempArtical
              console.info(this.ItemArray.length.toString())
              console.info(String(this.ItemArray[0].id))
              console.info(this.ItemArray[0].name)
              console.info(this.ItemArray[0].description)
              this.RecommenderViewpointArray = tempRecommenderViewpointArray

            } catch (e){
              console.error(`数据处理出错：${e}`)
            }
          }
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
                })
              }
            }, (item: Article) => String(item.id))
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
  build() {
    Row(){
      //左文字
      //文字上下排布
      Column(){
        Text(this.oneItem.name)//标题
          .height(19)
          .width('100%')
          .fontSize(16)
          .textAlign(TextAlign.Start)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontWeight(400)
          .margin({ top: 4 })
          .fontColor(Color.White)
        Text(this.oneItem.description)//简介
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
      Image(this.oneItem.cover_image)
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
            'title':this.oneItem.name,
            'area':this.oneItem.city
          }
        })
      }

    })
  }
}