import { AddressItem, Logger, MkNavbar } from 'basic';
import { createAddressAPI, editAddressAPI, RequestType } from '../api';
import { promptAction } from '@kit.ArkUI';

@Builder
function AddressCreateViewBuilder() {
  AddressCreateView()
}

@Component
export struct AddressCreateView {
  @StorageProp('safeBottom') safeBottom: number = 0
  @Consume pageStack: NavPathStack
  // 用于收集表单的数据
  @State addressData: RequestType = {
    receiver: '', // 收货人
    contact: '', // 手机号码
    address: '', // 详细地址
    isDefault: 1, // 0 默认 1 非默认
  }
  @State addressId:string=''
  aboutToAppear(): void {
    const data = this.pageStack.getParamByName('AddressCreateView').pop() as AddressItem
    if (!!data) {
      // 表单回显
      this.addressData.receiver = data.receiver
      this.addressData.contact = data.contact
      this.addressData.address = data.address
      this.addressData.isDefault = data.isDefault
      // 保存地址id
      this.addressId = data.id
    }
  }

  // 点击保存提交表单，注意：最多只能添加 10 个收货地址
  async onSubmit() {
    // 检查收货地址表单数据
    Logger.info(this.addressData)
    // 新增收货地址
    if (this.addressId) {
      // 有地址id，修改收货地址
      const res = await editAddressAPI(this.addressId, this.addressData)
      promptAction.showToast({ message: res.data.msg })
    } else {
      // 没有id，新增收货地址
      const res = await createAddressAPI(this.addressData)
      promptAction.showToast({ message: res.data.msg })
    }
    // 返回上一页
    this.pageStack.pop()
  }
  build() {
    NavDestination() {
      Column() {
        // 顶部区域
        MkNavbar({
          title: this.addressId ? '修改地址' : '新增地址',
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
                TextInput({ placeholder: '请填写收货人名称', text: $$this.addressData.receiver })
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
                TextInput({ placeholder: '请填写收货人电话', text: $$this.addressData.contact  })
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
                TextInput({ placeholder: '请填写详细地址' , text: $$this.addressData.address})
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
                Toggle({ isOn: this.addressData.isDefault === 0 ? true : false, type: ToggleType.Checkbox })
                  .selectedColor(($r('[basic].color.red')))
                  .onChange((isOn: boolean) => {
                    this.addressData.isDefault = isOn ? 0 : 1 // 0 默认 1 非默认
                  })
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
            .onClick(() => {
              this.onSubmit()
            })
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