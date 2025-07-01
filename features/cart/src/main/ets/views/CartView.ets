import { auth, MkGuess, MkNavbar, MkUser, MKLoadingDialog, CartGoodsModel, CartGoods, MkEmpty,
  EmitterEvent,
  cart,
  Logger} from 'basic'
import { emitter } from '@kit.BasicServicesKit'
import { promptAction } from '@kit.ArkUI'

@Builder
export function CartViewBuilder() {

  NavDestination() {
    CartView()
  }
  .hideTitleBar(true)
}


@Component
export struct CartView {
  @StorageProp('safeBottom') safeBottom: number = 0
  @State isShowLeftIcon: boolean = false
  // 用户信息
  @StorageProp(auth.KEY) user: MkUser = {} as MkUser
  // 商品信息
  @State cartList: CartGoodsModel[] = []
  // 页面栈
  @Consume pageStack: NavPathStack
  // 自定义弹窗
  dialog = new CustomDialogController({
    builder: MKLoadingDialog(), // loading
    customStyle: true,
  })

  aboutToAppear(): void {
    const res = this.pageStack.getParamByName('CartView') as boolean[]
    this.isShowLeftIcon = res.pop() ?? false
  }

  totalCount() {
    return this.cartList.filter(v => v.selected==true)
      .reduce((sum, item) => sum + item.count * item.price, 0)
      .toFixed(2) // 保留两位小数
  }

  async getData(){
    if (!auth.getUser().token) {
      return
    }
    this.dialog.open()
    const res = await cart.list()
    this.cartList = res.data.result.map((item) => new CartGoodsModel(item))
    await cart.count()
    this.dialog.close()
  }

  onCheckOrder() {
    AlertDialog.show({
      message: '去结算'
    })
  }

  getCheckAll() {
    return this.cartList.every(v => v.selected)
  }

  @Builder
  DeleteBuilder(onDelete: () => void) {
    Text('删除')
      .fontSize(14)
      .width(60)
      .height(100)
      .backgroundColor($r('[basic].color.red'))
      .fontColor($r('[basic].color.white'))
      .textAlign(TextAlign.Center)
      .onClick(() => {
        onDelete()
      })
  }

  build() {
    Column() {
      MkNavbar({ title: '购物袋',
        showLeftIcon: this.isShowLeftIcon,
        leftClickHandler: () => {
          this.pageStack.pop()
        },
        showRightIcon: true
      })
        .border({
          width: { bottom: 0.5 },
          color: '#e4e4e4'
        })
      List() {
        if (this.user.token) {

          if (this.cartList.length) {
            ForEach(this.cartList, (cartModel: CartGoodsModel,index:number) => {
              ListItem() {
                CartItemComp({
                  cart: cartModel,
                  onChangeSelected:async  selected => {
                    // 更新数据
                    // 更新页面
                    this.dialog.open()
                    await cart.update(cartModel.skuId, { selected:selected })
                    cartModel.selected=selected
                    this.cartList.splice(index, 1, cartModel)
                    await cart.count()
                    this.dialog.close()
                  },
                  onChangeCount:async  count => {
                    // 更新数据
                    // 更新页面
                    this.dialog.open()
                    // 更新后端数据count: count
                    await cart.update(cartModel.skuId, { count:count.toString() })
                    // 更新自己页面
                    cartModel.count = count // !深层 => 浅层赋值/Observed ObjectLink
                    this.cartList.splice(index, 1, cartModel)
                    // 更新数量
                    await cart.count()
                    this.dialog.close()
                  }
                })
              }
              .backgroundColor($r('[basic].color.under'))
              .padding({ left: 8, right: 8 })
              .transition({ type: TransitionType.Delete, opacity: 0 })
              .swipeAction({
                end: this.DeleteBuilder(async () => {
                  this.dialog.open()
                  await cart.delete({ids:[cartModel.skuId]})
                  promptAction.showToast({message:'删除成功'})
                  this.cartList.splice(index,1)
                  await cart.count()
                  this.dialog.close()
                })
              })
            }, (cart: CartGoods) => cart.skuId)
          } else {
            ListItem() {
              MkEmpty({
                tip: '购物袋是空的~',
                buttonText: '去逛逛',
                onClickButton: () => {
                  // 如何去 tab 的第一个呢？
                  emitter.emit(EmitterEvent.JUMP_TO_HOME)
                }
              })
            }
          }
        } else {
          // 未登录
          ListItem() {
            MkEmpty({
              tip: '您还未登陆~',
              buttonText: '请先登录',
              onClickButton: () => {
                // 去登陆也
                this.pageStack.pushPath({name:'LoginView'})
              }
            })
          }
        }
        ListItem() {
          MkGuess()
            .margin({ top: 8, bottom: 8 })
        }

      }
      .contentStartOffset(8)
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)

      if (this.cartList.length) {
        Row() {
          Checkbox()
            .selectedColor($r('[basic].color.red'))
            .select(this.getCheckAll())
            .onClick(async () => {
              this.dialog.open()
              const isCheckAllRes =  this.getCheckAll()
              // 更新服务器的数据
              await cart.checkAll({ selected: !isCheckAllRes })
              // 更新本地数据
              this.cartList.forEach((item) => {
                item.selected = !isCheckAllRes
              })
              this.cartList = this.cartList.slice() // 截取指定的数据到新数组中
              this.dialog.close()
            })
          Text('全选')
            .fontSize(14)
            .fontColor($r('[basic].color.black'))

            .margin({ right: 20 })
          Text('合计:')
            .fontSize(14)
            .fontColor($r('[basic].color.black'))
            .margin({ right: 2 })
          Text(this.totalCount())
            .fontSize(16)
            .fontWeight(500)
            .fontColor($r('[basic].color.red'))
            .layoutWeight(1)
          Button('去结算')
            .fontSize(14)
            .height(36)
            .backgroundColor($r('[basic].color.red'))
            .onClick(() => {

            })
        }
        .height(50)
        .width('100%')
        .backgroundColor($r('[basic].color.white'))
        .border({
          width: { top: 0.5, bottom: 0.5 },
          color: '#e4e4e4'
        })
        .padding({ left: 16, right: 16 })
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('[basic].color.under'))
    .onVisibleAreaChange([0, 1], (isVisible) => {
      if (isVisible) {
        this.getData()
      }
    })
    .padding({ bottom: this.isShowLeftIcon?this.safeBottom:0 })
  }
}

@Component
struct CartItemComp {
  @Prop cart: CartGoodsModel
  onChangeSelected: (selected: boolean) => void = () => {

  }
  onChangeCount: (count: number) => void = () => {

  }
  dialog = new CustomDialogController({
    builder: MKLoadingDialog({ message: '' }),
    customStyle: true,
    alignment: DialogAlignment.Center,
  })

  build() {
    Row({ space: 10 }) {

      Checkbox()
        .selectedColor($r('[basic].color.red'))
        .size({ width: 14, height: 14 })
        .select(this.cart.selected)
        .onChange(selected => {
          this.onChangeSelected(selected)
        })
      Image(this.cart.picture)
        .width(80)
        .height(80)
      Column({ space: 8 }) {
        Text(this.cart.name)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontSize(14)
          .fontColor($r('[basic].color.black'))
          .width('100%')
        Row() {
          Text(this.cart.attrsText)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .fontSize(12)
            .fontColor($r('[basic].color.text'))
            .layoutWeight(1)
          Image($r('sys.media.ohos_ic_public_arrow_down'))
            .fillColor($r('[basic].color.gray'))
            .width(16)
            .height(16)
        }
        .padding({ left: 6, right: 4 })
        .width(100)
        .height(24)
        .backgroundColor($r('[basic].color.under'))
        .borderRadius(2)

        Row() {
          Text(`¥${this.cart.price}`)
            .fontSize(14)
            .fontWeight(500)
          Counter(){
            Text(this.cart.count.toString())
          }
          .enableInc(this.cart.count < this.cart.stock)
          .enableDec(this.cart.count>1)
          .onInc(async ()=>{
            this.onChangeCount(this.cart.count + 1)
          })
          .onDec(async ()=>{
            this.onChangeCount(this.cart.count - 1)
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height(100)
    .padding(10)
    .border({ width: { bottom: 0.5 }, color: '#e4e4e4' })
    .backgroundColor($r('[basic].color.white'))
  }
}