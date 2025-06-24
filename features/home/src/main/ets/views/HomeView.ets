import { it } from '@ohos/hypium'
import { BreakpointConstants, BreakPointType, GoodsItemsDataSource, MkLoading, RequestAxios, SleepUtils } from 'basic'
import { getBannerApi, getCategoryApi, getHotInVogueApi, getHotOneStopApi, getHotPreferenceApi,
  getNewApi,
  getRecommendApi} from '../api'
import { DiscountGoodsComp, DiscountType } from '../components/DiscountGoodsComp'
import { MkGoods } from '../components/MkGoods'
import { Banner, CategoryItem, HotResult, MkGoodsItem, Params } from '../viewmodel'



@Component
export struct HomeView {
  @StorageProp('safeTop') safeTop: number = 0
  @StorageProp('currentBreakpoint') breakPoint: string = 'xs'
  @State isLoading: boolean = false
  @State isRefreshing: boolean = false
  // 轮播图
  @State banners: Banner[] = []
  // 分类
  @State categories: CategoryItem[] = []
  // 特惠推荐
  @State saleGoods: MkGoodsItem[] = []
  // 爆款推荐
  @State hotGoods: MkGoodsItem[] = []
  // 一站买全
  @State oneGoods: MkGoodsItem[] = []
  // 新鲜好物
  @State newGoods: MkGoodsItem[] = []
  // 推荐商品
  @State recommendGoods: GoodsItemsDataSource<MkGoodsItem> =new GoodsItemsDataSource<MkGoodsItem>()

  limit:number=10
  async aboutToAppear() {
    this.isLoading=true
    this.getData()
    await SleepUtils.sleep(500)
    this.isLoading=false
  }
  async getData(){

    const proArr = [getBannerApi(), getCategoryApi(), getHotPreferenceApi(), getHotInVogueApi(), getHotOneStopApi(),getNewApi(),getRecommendApi()]
    // allSettled 可以获取到每个请求状态成功或失败
    const resArr = await Promise.allSettled(proArr)

    resArr.forEach((item,index) => {
      if (item.status=='fulfilled') {
        switch (index){
          case 0:
            this.banners = item.value.data.result as Banner[]
            break
          case 1:
            this.categories = item.value.data.result as CategoryItem[]
            break
          case 2:
            this.saleGoods = (item.value.data.result as HotResult).subTypes[0].goodsItems.items
            break
          case 3:
            this.hotGoods = (item.value.data.result as HotResult).subTypes[0].goodsItems.items
            break
          case 4:
            this.oneGoods = (item.value.data.result as HotResult).subTypes[0].goodsItems.items
            break
          case 5:
            this.newGoods = item.value.data.result as MkGoodsItem[]
            break
          case 6:
            this.recommendGoods.reloadData(item.value.data.result as MkGoodsItem[])
            break
        }
      }
    })
  }
  @Builder
  DiscountBuilder(params: Params) {

    Column() {
      Row({ space: 10 }) {
        Text(params.title)
          .fontColor($r('[basic].color.black'))
          .fontSize(14)
        Text(params.subTitle)
          .fontColor($r('[basic].color.text'))
          .fontSize(11)
      }
      .width('100%')
      .margin({ bottom: 10 })

      List({ space: 10 }) {
        ForEach(params.list, (item: MkGoodsItem) => {
          ListItem() {
            DiscountGoodsComp({ type: DiscountType.DISCOUNT, goods: item })
          }
        })
      }
      .width('100%')
      .height(116)
      .scrollBar(BarState.Off)
      .listDirection(Axis.Horizontal)
    }
    .height(160)
    .layoutWeight(1)
    .padding(10)
    .backgroundColor(params.bg)
    .borderRadius(8)
  }

  build() {
    if (this.isLoading == true) {
      MkLoading()
    } else {
      Refresh({refreshing:$$this.isRefreshing, builder: this.RefreshBuilder()}){
        Scroll() {
          Column() {
            // 轮播图 + 搜索
            Stack({ alignContent: Alignment.Top }) {
              Swiper() {
                ForEach(this.banners, (item: Banner) => {
                  Image(item.imgUrl)
                })
              }
              .indicator(
                this.breakPoint == BreakpointConstants.SM ?
                DotIndicator.dot()
                  .itemWidth(8)
                  .itemHeight(4)
                  .color('#33191919')
                  .selectedItemWidth(24)
                  .selectedItemHeight(4)
                  .selectedColor('#191919') : false
              )
              .itemSpace(new BreakPointType({ 'sm': 0, 'md': 10, 'lg': 20 }).getValue(this.breakPoint))
              .displayCount(new BreakPointType({ 'sm': 1, 'md': 2, 'lg': 3 }).getValue(this.breakPoint))

              Row() {
                Row({ space: 4 }) {
                  Image($r('[basic].media.ic_public_search'))
                    .width(16)
                    .height(16)
                    .fillColor($r('[basic].color.white'))
                  Text('搜索...')
                    .fontSize(14)
                    .fontColor($r('[basic].color.white'))
                }
                .backgroundColor('#33191919')
                .width('100%')
                .height(40)
                .borderRadius(20)
                .padding({ left: 12 })
              }
              .margin({ top: this.safeTop })
              .padding({ left: 16, right: 16 })
            }
            .width('100%')


            // 分类
            Column({ space: 10 }) {
              // 分类
              List({ space: 16 }) {
                ForEach(this.categories, (item: CategoryItem) => {
                  ListItem() {
                    Column() {
                      Image(item.picture)
                        .width(56)
                        .aspectRatio(1)
                      Text(item.name)
                        .fontSize(10)
                        .fontColor('#CC191919')
                    }
                    .width(60)
                    .height(80)
                    .borderRadius(30)

                    .clip(true)
                    .backgroundImage(item.picture)
                    .backgroundImageSize(ImageSize.Contain)
                    .backgroundImagePosition(Alignment.Center)
                    .backgroundBlurStyle(
                      BlurStyle.BACKGROUND_ULTRA_THICK,
                      { scale: 0.25 }
                    )
                  }
                })
              }
              .width('100%')
              .height(92)
              .scrollBar(BarState.Off)
              .listDirection(Axis.Horizontal)
              .alignListItem(ListItemAlign.Center)

              // 特惠推荐
              Column({ space: new BreakPointType({ 'sm': 14, 'md': 36, 'lg': 72 }).getValue(this.breakPoint) }) {
                Image($r('app.media.home_cmd_title'))
                  .width(150)
                  .height(20)
                Row() {
                  Image($r('app.media.home_cmd_inner'))
                    .width(86)
                    .height(116)
                  List({ space: 10 }) {
                    ForEach(this.saleGoods, (item: MkGoodsItem) => {
                      ListItem() {
                        DiscountGoodsComp({ goods: item })
                      }
                    })
                  }
                  .layoutWeight(1)
                  .width('100%')
                  .height(116)
                  .backgroundColor($r('[basic].color.white'))
                  .borderRadius({
                    topRight: 8,
                    bottomRight: 8
                  })
                  .padding({ right: 10, left: 10 })
                  .scrollBar(BarState.Off)
                  .listDirection(Axis.Horizontal)
                }
              }
              .width('100%')
              .height(166)
              .backgroundImage($r('app.media.home_cmd_sm'))
              .backgroundImageSize(ImageSize.Cover)
              .borderRadius(8)
              .padding(10)
              .alignItems(HorizontalAlign.Start)

              // 爆款推荐+一站买全
              Row({ space: new BreakPointType({ 'sm': 14, 'md': 36, 'lg': 72 }).getValue(this.breakPoint) }) {
                this.DiscountBuilder({
                  title: '爆款推荐',
                  subTitle: '最受欢迎',
                  bg: '#EDF1FB',
                  list: this.hotGoods
                })
                this.DiscountBuilder({
                  title: '一站买全',
                  subTitle: '精心优选',
                  bg: '#FCF6EA',
                  list: this.oneGoods
                })
              }

              // 新鲜好物
              Column({ space: new BreakPointType({ 'sm': 14, 'md': 36, 'lg': 72 }).getValue(this.breakPoint) }) {
                Image($r('app.media.home_new'))
                  .width(146)
                  .height(19)
                List({ space: 10 }) {
                  ForEach(this.newGoods, (item: MkGoodsItem) => {
                    ListItem() {
                      DiscountGoodsComp({ type: DiscountType.NEW, goods: item })
                    }
                  })
                }
                .width('100%')
                .height(116)
                .scrollBar(BarState.Off)
                .listDirection(Axis.Horizontal)
              }
              .width('100%')
              .height(156)
              .padding(10)
              .backgroundColor('#F7EFF5')
              .borderRadius(8)
              .alignItems(HorizontalAlign.Start)

              // 推荐商品
              WaterFlow() {
                LazyForEach(this.recommendGoods, (item: MkGoodsItem) => {
                  FlowItem() {
                    MkGoods({ goods: item })
                  }
                })
              }
              .columnsTemplate(new BreakPointType({
                'sm': '1fr 1fr',
                'md': '1fr 1fr 1fr',
                'lg': '1fr 1fr 1fr'
              }).getValue(this.breakPoint))
              .columnsGap(8)
              .rowsGap(10)
              .onReachEnd(async () => {
                this.limit += 10
                const res = await getRecommendApi(this.limit)
                this.recommendGoods.reloadData(res.data.result as MkGoodsItem[])
              })
              .height('100%')
              .nestedScroll({
                scrollForward: NestedScrollMode.PARENT_FIRST,
                scrollBackward: NestedScrollMode.SELF_FIRST
              })

            }
            .padding({
              left: 8,
              right: 8,
              bottom: 10,
              top: 10
            })
          }
        }
        .height('100%')
        .scrollBar(BarState.Off)
      }
      .transition(TransitionEffect.OPACITY.animation({ duration: 400 }))
      .onRefreshing(async () => {
        await this.getData()
        this.isRefreshing=false
        this.limit=10
      })
    }
  }

  @Builder RefreshBuilder() {
    Row() {
      if(this.isRefreshing){
        MkLoading()
      }
    }
    .width('100%')
    .padding(10)
    .justifyContent(FlexAlign.Center)
  }

}