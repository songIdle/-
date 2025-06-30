import { auth, huaweiAuthPlugin, MkLoading, MKLoadingDialog, MkNavbar } from 'basic'
import { promptAction } from '@kit.ArkUI'
import { huaweiLoginAPI, LoginApi } from '../api'

@Builder
function LoginViewBuilder() {
  NavDestination() {
    LoginView()
  }
  .hideTitleBar(true)
}

@Component
export struct LoginView {
  dialog: CustomDialogController = new CustomDialogController({
    builder: MKLoadingDialog({ message: '华为登录中' }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })
  @State @Watch('onInput') account: string = 'zhousg'
  @State @Watch('onInput') password: string = '123456'
  @State valid: boolean = false
  @State agree: boolean = false
  @Consume pageStack: NavPathStack
  onInput() {
    this.valid = this.account && this.password ? true : false
  }

  async onSubmit() {
    if (!this.agree) {
      return promptAction.showToast({ message: '请先勾选协议' })
    }
    try {
      const res = await LoginApi({
        account: this.account,
        password: this.password
      })
      auth.saveUser(res.data.result)
      promptAction.showToast({ message: '你成功了' })
      this.pageStack.pop()
    }catch (e){
      promptAction.showToast({message:'用户名/密码错误'})
      this.getUIContext().getFocusController().clearFocus()
    }

  }

  @Styles
  formStyle() {
    .width('100%')
    .height(42)
    .padding({
      left: 16,
      right: 16,
      top: 0,
      bottom: 0
    })
  }

  build() {
    Column() {
      // 自定义导航栏
      MkNavbar({
        // 点击导航左侧图标，返回上一页
        leftClickHandler: () => {
          this.pageStack.pop()
        }
      })
      // 登录表单
      Column({ space: 16 }) {
        Text('账号密码登录')
          .fontSize(18)
          .fontColor($r('[basic].color.black'))
          .width('100%')
          .fontWeight(500)
          .margin({ bottom: 10 })
        TextInput({ placeholder: '请输入账号', text: $$this.account })
          .placeholderColor($r('[basic].color.gray'))
          .placeholderFont({ size: 14 })
          .formStyle()
          .onEditChange((text) => {
            this.onInput()
          })
        TextInput({ placeholder: '请输入密码', text: $$this.password })
          .type(InputType.Password)
          .showPasswordIcon(false)
          .placeholderColor($r('[basic].color.gray'))
          .placeholderFont({ size: 14 })
          .formStyle()
          .onEditChange((text) => {
            this.onInput()
          })

        Row({ space: 4 }) {
          Checkbox()
            .select($$this.agree)
            .width(12)
            .aspectRatio(1)
            .selectedColor($r('[basic].color.black'))
            .mark({ size: 10, strokeWidth: 1 })
          Text() {
            Span('查看并同意')
            Span('《隐私条款》')
              .fontColor('#007DFB')
            Span('和')
            Span('《用户协议》')
              .fontColor('#007DFB')
          }
          .width('100%')
          .fontSize(12)
          .fontColor($r('[basic].color.gray'))
        }

        Button('登录')
          .backgroundColor(this.valid ? $r('[basic].color.black') : '#D4D2D9')
          .fontColor($r('[basic].color.white'))
          .formStyle()
          .onClick(() => {
            this.onSubmit()
          })

        Row() {
          Blank()
          Text('忘记密码')
            .fontColor('#007DFB')
            .fontSize(12)
        }
        .width('100%')

        Column({ space: 16 }) {
          Stack() {
            Text()
              .width(200)
              .height(1)
              .backgroundColor($r('[basic].color.under'))
            Text('其他登录方式')
              .width(100)
              .fontSize(12)
              .backgroundColor($r('[basic].color.white'))
              .fontColor($r('[basic].color.text'))
              .textAlign(TextAlign.Center)
          }

          Row() {
            // 后续放置华为登录
            // 后续放置华为登录
            Image($r('app.media.ic_user_huawei'))
              .width(40)
              .onClick(async () => {
                this.dialog.open()
                // 等待完善
                promptAction.showToast({ message: '华为登录中...' })
                const code = await huaweiAuthPlugin.requestAuth()
                if (code) {
                  const res = await huaweiLoginAPI(code)
                  auth.saveUser(res.data.result)
                  this.pageStack.pop()
                  promptAction.showToast({ message: '登录成功' })
                } else {
                  promptAction.showToast({ message: '登录异常' })
                }
                this.dialog.close()
              })

          }
        }
        .margin({ top: 200 })
      }
      .padding(30)
    }
    .width('100%')
    .height('100%')
  }
}