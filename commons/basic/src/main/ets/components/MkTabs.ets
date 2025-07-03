import { Logger } from '../utils/Logger'

export interface MkTabItem {
  name: string
  value?: string | number
}

@Component
export struct MkTabs {
  @Prop @Watch('onActiveIndexChange') activeIndex: number = 0
  @Prop tabConfig: MkTabItem[] = [] // 选项数组
  @Prop lineWidth: number = 20
  @Prop lineHeight: number = 2
  @Prop tabHeight: number = 40
  @Prop gutter: number = 20
  @Prop paddingLeft: number = this.gutter
  @Prop paddingRight: number = this.gutter
  @State left: number = 100
  // cb
  onTabClick?: (tab: MkTabItem, index: number) => void = () => {
  }
  onTabChange?: (tab: MkTabItem, index: number) => void = () => {
  }
  list: Area[] = [] // 所有人的位置
  spaceBetween: boolean = false

  // 设置线条的宽度和位置
  setLineLeft(area: Area) {
    // TODO
    this.left = area.position.x as number // 让黑线跟过来
    this.lineWidth = area.width as number // 让黑线宽度和组件宽度保持一致
  }

  // @Watch 监听 activeIndex 的变化，设置线条的宽度和位置
  onActiveIndexChange() {
    // 现在被选中的item的位置
    this.setLineLeft(this.list?.[this.activeIndex])
  }

  @Builder
  TabBuilder(tab: MkTabItem, index: number) {
    Text(tab.name)
      .fontSize(15)
      .fontColor(this.activeIndex === index ? $r('app.color.black') : $r('app.color.gray'))
      .fontWeight(this.activeIndex === index ? 500 : 400)
      .animation({ duration: 300 })
      .onClick((e) => {
        if (this.activeIndex !== index) {
          this.activeIndex = index // 父组件传来的数据 不能直接修改(只在子组件有效果 不会同步到父组件)
          this.onTabChange?.(tab, index)
        }
      })// 监听组件的显示位置变化
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.list[index] = newValue // 将每个text组件现在的显示位置对象 都存下来
        if (this.activeIndex === index) {
          // 我被选中了
          this.setLineLeft(newValue)
        }
      })
  }

  build() {
    Row() {
      Row({ space: this.gutter }) {
        ForEach(this.tabConfig, (item: MkTabItem, index) => {
          this.TabBuilder(item, index)
        })
      }
      .width('100%')
      .padding({ left: this.paddingLeft, right: this.paddingRight })
      .height(this.tabHeight)
      .border({
        width: { bottom: 0.5 },
        color: $r('app.color.under')
      })
      .justifyContent(this.spaceBetween ? FlexAlign.SpaceBetween : FlexAlign.Start)

      // 移动的线条
      Row()
        .width(this.lineWidth)
        .height(this.lineHeight)
        .backgroundColor($r('app.color.black'))
        .position({ x: this.left, y: this.tabHeight - this.lineHeight })
    }
    .layoutWeight(1)
  }
}