import { Logger, MkNavbar, MKNavPathStack } from 'basic'
import { webview } from '@kit.ArkWeb'

@Builder
function PayViewBuilder() {
  PayView()
}

@Component
export struct PayView {
  @Consume pageStack: NavPathStack
  // 订单id
  orderId: string = ''
  webviewController: webview.WebviewController = new webview.WebviewController()

  aboutToAppear(): void {
    this.orderId=this.pageStack.getParamByName('PayView').pop() as string
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.TopStart }) {
        Column() {
          // 如果有订单id
          if (this.orderId) {
            Web({
              src: `https://meikou-api.itheima.net/pay/wap/aliPay?orderId=${this.orderId}`,
              controller: this.webviewController
            })
            .onPageBegin((event: OnPageBeginEvent) => {
              // 监听页面开始加载，获取加载页面的 url 路径
              Logger.info(event)
              // 判断 url 路径是否为支付完成的页面
              if (event.url.includes('/pay/redirect?')) {
                // 跳转到支付结果页，传递参数
                const search = event.url.split('?')[1]
                this.pageStack.replacePath({ name: 'PayResultView', param: search })
              }
            })
          }
        }
        .height('100%')

        // title bar
        MkNavbar({
          title: '支付中',leftClickHandler:()=>{
            this.webviewController.backward()
          }
        })
      }
      .height('100%')
    }
    .hideTitleBar(true)

  }
}