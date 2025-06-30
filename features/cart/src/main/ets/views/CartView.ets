import { auth, MkGuess, MkNavbar, MkUser, MKLoadingDialog, CartGoodsModel, CartGoods, MkEmpty,
  EmitterEvent } from 'basic'
import { emitter } from '@kit.BasicServicesKit'

@Component
export struct CartView {
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

  }

  onCheckOrder() {
    AlertDialog.show({
      message: '去结算'
    })
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
      MkNavbar({ title: '购物袋', showLeftIcon: false, showRightIcon: true })
        .border({
          width: { bottom: 0.5 },
          color: '#e4e4e4'
        })
      List() {
        if (this.user.token) {

          if (this.cartList.length) {
            ForEach(this.cartList, (cart: CartGoodsModel) => {
              ListItem() {
                CartItemComp({
                  cart: cart,
                  onChangeSelected: selected => {
                    // 更新数据
                    // 更新页面
                  },
                  onChangeCount: count => {
                    // 更新数据
                    // 更新页面
                  }
                })
              }
              .backgroundColor($r('[basic].color.under'))
              .padding({ left: 8, right: 8 })
              .transition({ type: TransitionType.Delete, opacity: 0 })
              .swipeAction({
                end: this.DeleteBuilder(async () => {
                  AlertDialog.show({
                    message: 'clickDel'
                  })
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
          Text('全选')
            .fontSize(14)
            .fontColor($r('[basic].color.black'))
            .margin({ right: 20 })
          Text('合计:')
            .fontSize(14)
            .fontColor($r('[basic].color.black'))
            .margin({ right: 2 })
          Text('998')
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
          Counter()
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