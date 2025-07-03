import { MkGuess, MkNavbar } from 'basic'

@Builder
function PayResultViewBuilder() {
  PayResultView()
}

@Component
export struct PayResultView {
  payResult: boolean = false
  orderId: string = ''
  @Consume pageStack: NavPathStack

  aboutToAppear(): void {
    const res=this.pageStack.getParamByName('PayResultView').pop() as string
    if (res) {
      const arr=res.split('&')
      this.orderId=arr[1].split('=')[1]
      this.payResult=arr[0].split('=')[1]=='true'
    }
  }

  build() {
    NavDestination() {
      Column() {
        MkNavbar({ title: this.payResult ? '付款成功' : '付款失败' })
        List() {
          ListItem() {
            Column({ space: 20 }) {
              Image(this.payResult ? $r('[basic].media.ic_public_check_filled') :
              $r('[basic].media.ic_public_close_filled'))
                .width(60)
                .height(60)
                .fillColor(this.payResult ? '#00C1BF' : '#B0171F')
              Text(this.payResult ? '付款成功' : '付款失败')
              Row({ space: 20 }) {
                Button('返回首页')
                  .backgroundColor($r('[basic].color.black'))
                  .fontSize(14)
                  .height(36)
                  .onClick(() => {
                    // 返回首页 用 -1 即可
                    this.pageStack.popToIndex(-1)
                    // 清空页面栈
                    this.pageStack.clear()
                  })
                Button('查看订单')
                  .fontSize(14)
                  .height(36)
                  .backgroundColor($r('[basic].color.white'))
                  .fontColor($r('[basic].color.black'))
                  .border({ width: 0.5, color: $r('[basic].color.border') })
                  .onClick(() => {
                    this.pageStack.pushPathByName('OrderView', this.orderId)
                  })

              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
            }
            .padding(40)
            .backgroundColor($r('[basic].color.under'))
          }

          ListItem() {
            MkGuess()
          }
        }
        .layoutWeight(1)
        .height('100%')
        .width('100%')
        .scrollBar(BarState.Off)
      }
    }
    .hideTitleBar(true)
  }
}