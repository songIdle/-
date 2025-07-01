import { auth, huaweiAuthPlugin, MkCell, MkCellGroup, MkNavbar, MkUser } from 'basic'
import { promptAction } from '@kit.ArkUI'

// import { MkCell, MkCellGroup } from 'basic'

@Builder
function SettingsViewBuilder() {
  NavDestination() {
    SettingsView()
  }
  .hideTitleBar(true)
}

@Component
export struct SettingsView {
  @StorageProp(auth.KEY) user: MkUser = {} as MkUser
  @Consume pageStack: NavPathStack

  @Builder
  ProfileBuilder() {
    Row({ space: 8 }) {
      Image(this.user.avatar)
        .width(50)
        .aspectRatio(1)
        .borderRadius(25)
      Column({ space: 4 }) {
        Text(this.user.nickname || this.user.account)
          .fontColor($r('[basic].color.black'))
          .fontWeight(500)
        Text('账号名：' + this.user.account)
          .fontColor($r('[basic].color.gray'))
          .fontSize(12)
      }
      .alignItems(HorizontalAlign.Start)
    }
    .padding({ top: 16, bottom: 16 })
  }

  build() {
    Column() {
      MkNavbar({
        title: '设置',
        leftClickHandler: () => {
          // 点击返回
          this.pageStack.pop()
        }
      })
      Column({ space: 8 }) {
          MkCellGroup() {
            MkCell({
              hasBorder: false, customLabel: () => {
                this.ProfileBuilder()
              }
            })
          }

          MkCellGroup() {
            MkCell({ label: '收货地址管理' })
              .onClick(() => {
                  this.pageStack.pushPath({ name: 'AddressManageView' })
              })
            MkCell({ label: '账号安全' })
            MkCell({ label: '消息设置' })
            MkCell({ label: '隐私设置' })
            MkCell({ label: '通用设置', hasBorder: false })
          }

          MkCellGroup() {
            MkCell({ label: '退出登录', hasBorder: false })
              .onClick(() => {
                AlertDialog.show(
                  {
                    title: '提示',
                    message: '确定退出？',
                    autoCancel: true,
                    alignment: DialogAlignment.Bottom,
                    gridCount: 4,
                    offset: { dx: 0, dy: -20 },
                    primaryButton: {
                      value: '取消',
                      action: () => {
                        console.info('Callback when the first button is clicked')
                      }
                    },
                    secondaryButton: {
                      enabled: true,
                      defaultFocus: true,
                      style: DialogButtonStyle.HIGHLIGHT,
                      value: '确定',
                      action:  () => {
                        auth.removeUser()
                        this.pageStack.pop()
                      }
                    },
                    cancel: () => {
                      console.info('Closed callbacks')
                    }
                  }
                )
              })
          }

        MkCellGroup() {
          MkCell({ label: '取消授权', hasBorder: false })
            .onClick(() => {
              AlertDialog.show(
                {
                  title: '提示',
                  message: '确定退出？',
                  autoCancel: true,
                  alignment: DialogAlignment.Bottom,
                  gridCount: 4,
                  offset: { dx: 0, dy: -20 },
                  primaryButton: {
                    value: '取消',
                    action: () => {
                      console.info('Callback when the first button is clicked')
                    }
                  },
                  secondaryButton: {
                    enabled: true,
                    defaultFocus: true,
                    style: DialogButtonStyle.HIGHLIGHT,
                    value: '确定',
                    action: async () => {
                      await huaweiAuthPlugin.cancelAuth()
                      auth.removeUser()
                      this.pageStack.pop()
                      promptAction.showToast({ message: '取消授权成功' })
                    }
                  },
                  cancel: () => {
                    console.info('Closed callbacks')
                  }
                }
              )
            })
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('[basic].color.under'))

  }
}