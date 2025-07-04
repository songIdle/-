import { MkEmpty, MkNavbar, MKLoadingDialog, MKPullToRefresh, MkTabs } from 'basic'
import { OrderItem, OrderSku } from '../viewmodel'
import { promptAction } from '@kit.ArkUI'
import { getOrderApi } from '../api'


@Builder
function OrderViewBuilder() {
  OrderView()
}

// 顶级组件
@Component
export struct OrderView {
  @StorageProp('safeBottom') safeBottom: number = 0
  @State activeIndex: number = 0
  @State list: OrderItem[] = []
  @State isEmpty: boolean = false
  page: number = 1
  totalPage: number = 0
  scroller = new Scroller()
  @Consume pageStack: NavPathStack
  // 自定义 dialog
  dialog = new CustomDialogController({
    builder: MKLoadingDialog(),
    customStyle: true,
    alignment: DialogAlignment.Center,
    maskColor: '22000000',
    autoCancel: false
  })
  aboutToAppear(): void {
    this.activeIndex = this.pageStack.getParamByName('OrderView').pop() as number
    this.getData()
  }

  // 获取订单列表数据
  async getData() {
    this.dialog.open()
    const res = await getOrderApi({
      pageSize: 5, // 页容量
      page: this.page, // 页码
      orderState: this.activeIndex // 订单分类
    })
    // 保存列表数据
    this.list = res.data.result.items
    this.isEmpty=this.list.length==0?true:false
    this.dialog.close()
  }

  @Builder
  ListBuilder() {
    List({ scroller: this.scroller }) {
      ListItem()
      ForEach(this.list, (order: OrderItem) => {
        ListItem() {
          OrderItemComp({ order })
        }
      })
      ListItem() {
        Row()
          .height(this.safeBottom - 8)
      }
    }
    .divider({
      strokeWidth: 8,
      color: $r('[basic].color.under')
    })
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.None)
  }

  build() {
    NavDestination() {
      Column() {
        MkNavbar({ title: '我的订单', bg: $r('[basic].color.under'),leftClickHandler: () => {
          this.pageStack.pop()
        } })
        Row() {
          MkTabs({
            activeIndex: this.activeIndex,
            tabConfig: [
              { name: '全部' },
              { name: '待付款' },
              { name: '待发货' },
              { name: '待收货' },
              { name: '待评价' }
            ],
            spaceBetween: true,
            onTabChange: (_item, index) => {
              // promptAction.showToast({
              //   message: `index:${index},item${JSON.stringify(_item)}`
              // })
              this.activeIndex = index
              this.getData()
            }
          })
        }
        .height(40)

        if (this.isEmpty) {
          MkEmpty()
        }
        // 下拉组件 触底组件
        MKPullToRefresh({
          data: this.list,
          scroller: this.scroller,
          customList: () => {
            this.ListBuilder()
          },
          onLoadMore: async () => {
            return undefined
          },
          customRefresh: null,
          customLoad: null,
        })
          .width('100%')
          .height('100%')
          .layoutWeight(1)
      }
      .backgroundColor($r('[basic].color.under'))
    }
    .hideTitleBar(true)

  }
}

// 列表项
@Component
struct OrderItemComp {
  @Prop order: OrderItem
  timer: number = 0
  @State countDown: string = ''

  @Builder
  StateBuilder() {
    if (this.order.orderState === 1) {
      Row() {
        Text('待付款')
          .textAlign(TextAlign.Center)
          .width(50)
          .fontColor($r('[basic].color.white'))
          .fontSize(11)
          .height(18)
          .borderRadius({ bottomRight: 9 })
          .linearGradient({
            angle: 90,
            colors: [[$r('[basic].color.linear_begin'), 0], [$r('[basic].color.linear_end'), 1]]
          })
        Text(this.countDown)
          .textAlign(TextAlign.Center)
          .width(60)
          .fontSize(11)
          .fontColor($r('[basic].color.red'))
      }
      .backgroundColor('#FFDEE2')
      .height(18)
      .borderRadius(9)
      .clip(true)
    } else if (this.order.orderState === 2) {
      Text('待发货')
        .fontSize(12)
        .fontColor($r('[basic].color.red'))
    } else if (this.order.orderState === 3) {
      Text('待收货')
        .fontSize(12)
        .fontColor($r('[basic].color.red'))
    } else if (this.order.orderState === 4) {
      Text('待评价')
        .fontSize(12)
        .fontColor($r('[basic].color.black'))
    } else if (this.order.orderState === 5) {
      Text('已完成')
        .fontSize(12)
        .fontColor($r('[basic].color.black'))
    } else if (this.order.orderState === 6) {
      Text('已取消')
        .fontSize(12)
        .fontColor($r('[basic].color.gray'))
    }
  }

  @Builder
  ButtonBuilder() {
    Row({ space: 10 }) {
      if ([5, 6].includes(this.order.orderState)) {
        Button('删除订单')
          .whiteStyle()
          .onClick(() => {
            // TODO
          })
      }
      if ([5].includes(this.order.orderState)) {
        Button('查看评价')
          .whiteStyle()
          .onClick(() => {
            // TODO
          })
      }
      if ([3, 4, 5].includes(this.order.orderState)) {
        Button('查看物流')
          .whiteStyle()
          .onClick(() => {
          })
      }
      if ([1].includes(this.order.orderState)) {
        Button('取消订单')
          .whiteStyle()
          .onClick(() => {
            // TODO
          })
      }
      if ([1].includes(this.order.orderState)) {
        Button('立即付款')
          .redStyle()
          .onClick(() => {
            // TODO
          })
      }
      if ([2, 5, 6].includes(this.order.orderState)) {
        Button('再次购买')
          .redStyle()
          .onClick(() => {
            // TODO
          })
      }
      if ([3].includes(this.order.orderState)) {
        Button('确认收货')
          .redStyle()
          .onClick(() => {
            // TODO
          })
      }
    }
    .width('100%')
    .justifyContent(FlexAlign.End)
  }

  build() {
    Row() {
      Column() {
        Row() {
          Text(this.order.createTime)
            .fontSize(12)
            .fontColor($r('[basic].color.gray'))
          this.StateBuilder()
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        ForEach(this.order.skus, (sku: OrderSku) => {
          OrderSkuComp({ goods: sku })
        })

        Text('实付款：¥' + this.order.payMoney)
          .fontWeight(500)
          .fontColor($r('[basic].color.black'))
          .alignSelf(ItemAlign.End)
          .padding({ top: 10, bottom: 10 })

        this.ButtonBuilder()
      }
      .padding(10)
      .borderRadius(8)
      .backgroundColor($r('[basic].color.white'))
    }
    .padding({ left: 8, right: 8 })
  }
}

// 订单信息
@Component
struct OrderSkuComp {
  @Prop goods: OrderSku

  build() {
    Row({ space: 10 }) {
      Image(this.goods.image)
        .width(80)
        .height(80)
      Column({ space: 10 }) {
        Text(this.goods.name)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontColor($r('[basic].color.black'))
          .fontSize(14)
          .width('100%')
        Text(this.goods.attrsText)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')
          .fontColor($r('[basic].color.text'))
          .fontSize(14)
      }
      .justifyContent(FlexAlign.Start)
      .layoutWeight(1)
      .height(80)

      Column({ space: 10 }) {
        Text('¥' + this.goods.curPrice)
          .fontSize(14)
          .fontColor($r('[basic].color.black'))
        Text('x' + this.goods.quantity)
          .fontSize(14)
          .fontColor($r('[basic].color.gray'))
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.End)
      .width(70)
      .height(80)
    }
    .padding({ top: 10, bottom: 10 })
  }
}

// 扩展按钮
@Extend(Button)
function whiteStyle() {
  .fontWeight(400)
  .fontSize(14)
  .height(30)
  .backgroundColor($r('[basic].color.white'))
  .fontColor($r('[basic].color.black'))
  .padding({
    left: 10,
    right: 10,
    top: 0,
    bottom: 0
  })
  .border({ width: 0.5, color: $r('[basic].color.border') })
}

@Extend(Button)
function redStyle() {
  .fontWeight(400)
  .fontSize(14)
  .height(30)
  .padding({
    left: 10,
    right: 10,
    top: 0,
    bottom: 0
  })
  .backgroundColor($r('[basic].color.red'))
}

