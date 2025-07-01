import { MkNavbar } from 'basic';

@Builder
function AddressCreateViewBuilder() {
  AddressCreateView()
}

@Component
export struct AddressCreateView {
  @StorageProp('safeBottom') safeBottom: number = 0
  @Consume pageStack: NavPathStack

  build() {
    NavDestination() {
      Column() {
        // 顶部区域
        MkNavbar({
          title: '新增地址',
          leftClickHandler:()=>{
            this.pageStack.pop()
          }
        })

        // 地址信息表单
        Row() {
          List() {
            ListItem() {
              Row() {
                Text('收货人')
                  .width(80)
                  .fontSize(14)
                  .fontColor($r('[basic].color.black'))
                TextInput({ placeholder: '请填写收货人名称' })
                  .fontSize(14)
                  .backgroundColor($r('[basic].color.white'))
              }
              .listItemStyle()
            }

            ListItem() {
              Row() {
                Text('手机号码')
                  .width(80)
                  .fontSize(14)
                  .fontColor($r('[basic].color.black'))
                TextInput({ placeholder: '请填写收货人电话' })
                  .fontSize(14)
                  .backgroundColor($r('[basic].color.white'))
              }
              .listItemStyle()
            }


            ListItem() {
              Row() {
                Text('详细地址')
                  .width(80)
                  .fontSize(14)
                  .fontColor($r('[basic].color.black'))
                TextInput({ placeholder: '请填写详细地址' })
                  .fontSize(14)
                  .backgroundColor($r('[basic].color.white'))


              }
              .listItemStyle()
            }

            ListItem() {
              Row() {
                Text('设为默认地址')
                  .fontSize(14)
                  .fontColor(($r('[basic].color.black')))
                Toggle({ isOn: true, type: ToggleType.Checkbox })
                  .selectedColor(($r('[basic].color.red')))
              }
              .listItemStyle()
            }
          }
          .divider({
            strokeWidth: 1,
            color: '#eee'
          })
          .backgroundColor($r('[basic].color.white'))
          .padding({ left: 8, right: 8 })
        }
        .layoutWeight(1)
        .alignItems(VerticalAlign.Top)


        // 底部保存按钮
        Row() {
          Button('保存')
            .backgroundColor(($r('[basic].color.black')))
            .fontSize(14)
            .width('100%')
        }
        .height(46)
        .padding({ left: 16, right: 16 })
      }
      .height('100%')
      .backgroundColor('#F5F4F9')
      .padding({ bottom: this.safeBottom })
    }
    .hideTitleBar(true)
  }
}

// 拓展自定义样式
@Extend(Row)
function listItemStyle() {
  .padding({ top: 4, bottom: 4 })
  .width('100%')
  .justifyContent(FlexAlign.SpaceBetween)
  .backgroundColor($r('[basic].color.white'))
}