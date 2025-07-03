import { cart, Logger, MkCell, MkNavbar } from 'basic'
import { AddressItem, CreateOrderParamsGoods, OrderGoodsItem, Summary } from '../viewmodel'
import { promptAction } from '@kit.ArkUI'
import { createOrderApi, getOrderPreApi } from '../api'

@Builder
function CheckViewBuilder() {
  CheckView()
}

@Component
export struct CheckView {
  @Consume pageStack: NavPathStack
  @StorageProp('safeBottom') safeBottom: number = 0
  // 商品列表
  @State goodsList: OrderGoodsItem[] = []
  // 地址
  @State addressList: AddressItem[] = []
  // 摘要
  @State summary: Summary = {} as Summary
  // 弹框
  @State showPaySheet: boolean = false
  // 支付渠道
  @State payChannel: number = 1
  // 地址 id
  @State addressId: string = ''
  // 是否 loading
  @State loading: boolean = false

  aboutToAppear(): void {
    this.getData()
  }

  // 获取订单信息
  async getData() {
    // 获取结算信息
    const res = await getOrderPreApi()
    // 绑定数据: 地址列表、商品列表、结算金额
    this.addressList = res.data.result.userAddresses
    this.goodsList = res.data.result.goods
    this.summary = res.data.result.summary
  }

  async submitOrder() {
    if (this.payChannel !== 1) {
      return promptAction.showToast({ message: '暂不支持该支付方式' })
    }
    if (!this.addressId) {
      return promptAction.showToast({ message: '未选择收货地址' })
    }
    this.loading = true

    // 准备创建订单所需的 goods 参数
    const goods = this.goodsList.map<CreateOrderParamsGoods>(item => {
      return { skuId: item.skuId, count: item.count }
    })
    // 发送创建订单的请求
    const res = await createOrderApi({
      goods: goods, // 注意 goods 参数
      addressId: this.addressId, // 收货地址id
      deliveryTimeType: 1,
      buyerMessage: '',
      payType: 1,
      payChannel: this.payChannel // 支付渠道
    })
    Logger.info(res.data.result) // 订单创建成功后，检查订单 id
    this.loading = false // 修改状态
    this.showPaySheet = false // 隐藏弹框
    cart.count() // 更新购物车数量
    this.pageStack.pushPath({name:'PayView',param:res.data.result.id})
  }

  @Builder
  GoodsItemBuilder(goods: OrderGoodsItem) {
    Row({ space: 10 }) {
      Image(goods.picture)
        .width(80)
        .height(80)
      Column({ space: 8 }) {
        Text(goods.name)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontSize(14)
          .fontColor($r('[basic].color.black'))
          .width('100%')
        Row({ space: 8 }) {
          Text(goods.attrsText)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .fontSize(12)
            .fontColor($r('[basic].color.text'))
            .layoutWeight(1)
          Text('x' + goods.count)
            .fontSize(14)
            .fontColor($r('[basic].color.gray'))
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Text('¥' + goods.payPrice)
          .width('100%')
          .fontSize(16)
          .fontColor($r('[basic].color.black'))
      }
      .layoutWeight(1)
    }
    .padding({ top: 10, bottom: 10 })
    .border({
      width: { bottom: 0.5 },
      color: '#e4e4e4'
    })
  }

  payChannels = ['支付宝', '微信支付', '华为支付']

  // 半模态
  @Builder
  PaySheetBuilder() {
    Column() {
      Text('¥' + this.summary.totalPayPrice?.toString())
        .fontSize(20)
        .fontWeight(500)
        .fontColor($r('[basic].color.black'))
        .height(50)
        .width('100%')
        .border({
          width: { bottom: 0.5 },
          color: $r('[basic].color.under')
        })
      ForEach(this.payChannels, (label: string, index) => {
        CheckCell({
          label: label, checked: this.payChannel === index + 1, onClickBox: () => {
            this.payChannel = index + 1
          }
        })
          .onClick(() => {
            this.payChannel = index + 1
          })
      })
      Row() {
        Button(this.loading ? '提交中...' : '立即支付')
          .width('100%')
          .height(36)
          .fontSize(14)
          .backgroundColor($r('[basic].color.red'))
          .onClick(() => {
            this.submitOrder()
          })
      }
      .height(50)
    }
    .padding({ left: 16, right: 16, bottom: this.safeBottom })
  }

  build() {
    NavDestination() {
      Column() {
        MkNavbar({ title: '结算' })
          .border({
            width: { bottom: 0.5 },
            color: '#e4e4e4'
          })
        List() {
          ListItem() {
            ChangeAddressComp({
              addressList: this.addressList, onChangeAddress: (addr) => {
                if (addr==null){
                  return
                }
                this.addressId = addr.id
              }
            })
          }

          ListItem() {
            Row() {
              Column() {
                ForEach(this.goodsList, (goods: OrderGoodsItem) => {
                  this.GoodsItemBuilder(goods)
                })
              }
              .padding({ left: 8, right: 8 })
              .backgroundColor($r('[basic].color.white'))
            }
            .padding({ top: 8, left: 8, right: 8 })
          }

          ListItem() {
            Row() {
              Column() {
                MkCell({ label: '配送时间', value: '时间不限' })
                MkCell({ label: '留言', value: '建议留言前先和卖家沟通' })
              }
              .padding({ left: 8, right: 8 })
              .backgroundColor($r('[basic].color.white'))
            }
            .padding({ top: 8, left: 8, right: 8 })
          }

          ListItem() {
            Row() {
              Column() {
                PriceCell({ label: '商品总价', price: this.summary.totalPrice })
                PriceCell({ label: '运费', price: this.summary.postFee })
                PriceCell({ label: '实付金额', price: this.summary.totalPayPrice, isRed: true })
              }
              .padding({ left: 8, right: 8 })
              .backgroundColor($r('[basic].color.white'))
            }
            .padding({ top: 8, left: 8, right: 8 })
          }

          ListItem() {
            Row() {
              Column() {
                CheckCell({ label: '在线支付', checked: true })
                CheckCell({ label: '货到付款' })
              }
              .padding({ left: 8, right: 8 })
              .backgroundColor($r('[basic].color.white'))
            }
            .padding(8)
          }

        }
        .width('100%')
        .height('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)

        Row() {
          Column() {
            Text() {
              Span('¥')
                .fontSize(14)
              Span(this.summary.totalPayPrice?.toFixed(2))
                .fontSize(20)
            }
            .fontColor($r('[basic].color.red'))
            .fontWeight(500)

            Text() {
              Span('共减')
                .fontColor($r('[basic].color.gray'))
              Span('¥00.00')
                .fontColor($r('[basic].color.red'))
                .fontWeight(500)
            }
            .fontSize(8)
          }
          .alignItems(HorizontalAlign.Start)

          Blank()
          Button('提交订单')
            .fontSize(14)
            .height(36)
            .backgroundColor($r('[basic].color.red'))
            .onClick(() => {
              this.showPaySheet = true
            })
        }
        .height(50 + this.safeBottom)
        .width('100%')
        .backgroundColor($r('[basic].color.white'))
        .border({
          width: { top: 0.5 },
          color: '#e4e4e4'
        })
        .padding({ left: 16, right: 16, bottom: this.safeBottom })
      }
      .backgroundColor($r('[basic].color.under'))
      .bindSheet($$this.showPaySheet, this.PaySheetBuilder(), {
        title: {
          title: '支付方式',
          subtitle: '请选择一种支付方式进行付款'
        }, height: SheetSize.FIT_CONTENT, backgroundColor: $r('[basic].color.white')
      })
    }
    .hideTitleBar(true)

  }
}


@Component
struct ChangeAddressComp {
  @Prop
  @Watch('onAddressListChange')
  addressList: AddressItem[] = []
  @State currentAddress: AddressItem = {} as AddressItem
  onChangeAddress: (address: AddressItem) => void = () => {

  }

  onAddressListChange() {
    if (this.addressList==null) {
      return
    }
    const defAddress = this.addressList.find(addr => addr.isDefault === 0)
    if (defAddress) {
      this.currentAddress = defAddress
    } else {
      this.currentAddress = this.addressList[0]
    }
    this.onChangeAddress(this.currentAddress)
  }

  aboutToAppear() {
    this.onChangeAddress(this.currentAddress)
  }

  @Builder
  AddressTipBuilder() {
    if (this.addressList.length) {
      Column({ space: 8 }) {
        Row({ space: 4 }) {
          if (this.currentAddress.isDefault === 0) {
            Text('默认')
              .fontSize(14)
              .width(40)
              .height(20)
              .borderRadius(4)
              .fontColor($r('[basic].color.white'))
              .textAlign(TextAlign.Center)
              .linearGradient({
                angle: 90,
                colors: [[$r('[basic].color.linear_begin'), 0], [$r('[basic].color.linear_end'), 1]]
              })
          }
          Text(this.currentAddress.fullLocation)
            .fontSize(14)
            .fontColor($r('[basic].color.text'))
        }

        Text(this.currentAddress.address)
          .fontWeight(500)
          .fontSize(16)
          .fontColor($r('[basic].color.black'))
        Text(`${this.currentAddress.receiver} ${this.currentAddress.contact}`)
          .fontSize(13)
          .fontColor($r('[basic].color.text'))
      }
      .alignItems(HorizontalAlign.Start)
      .padding({ top: 10, bottom: 10 })
    } else {
      Text('请填写收货地址')
        .fontSize(14)
        .fontColor($r('[basic].color.gray'))
    }
  }

  build() {
    Row() {
      MkCell({
        customLabel: () => {
          this.AddressTipBuilder()
        }
      })
    }
    .padding({ left: 16, right: 16 })
    .backgroundColor($r('[basic].color.white'))
    .width('100%')
    .onAppear(() => {
      this.onChangeAddress(this.currentAddress)
    })
  }
}

@Component
struct PriceCell {
  @Prop label: string
  @Prop price: number = 0
  @Prop isRed: boolean = false

  @Builder
  PriceBuilder() {
    Text('¥' + this.price)
      .fontSize(this.isRed ? 16 : 14)
      .fontColor(this.isRed ? $r('[basic].color.red') : $r('[basic].color.gray'))
  }

  build() {
    MkCell({
      label: this.label, customIcon: () => {
        this.PriceBuilder()
      }
    })
  }
}

@Component
struct CheckCell {
  @Prop label: string
  @Prop checked: boolean = false
  onClickBox: () => void = () => {

  }

  @Builder
  CheckBuilder() {
    Checkbox()
      .selectedColor($r('[basic].color.red'))
      .select(this.checked)
      .onClick(() => {
        this.onClickBox()
      })
  }

  build() {
    MkCell({
      label: this.label, customIcon: () => {
        this.CheckBuilder()
      }
    })
  }
}