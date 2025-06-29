@Component
export struct MkCell {
  @Prop label: string = ''
  @Prop value: string = ''
  @Prop icon: ResourceStr = $r('app.media.ic_public_right')
  @Prop hasBorder: boolean = true
  @BuilderParam customLabel: () => void = this.LabelBuilder
  @BuilderParam customIcon: () => void = this.IconBuilder


  @Builder
  IconBuilder() {
    // 图标
    Image(this.icon)
      .width(20)
      .aspectRatio(1)
      .fillColor($r('app.color.gray'))
  }

  @Builder
  LabelBuilder() {
    // 文本
    Text(this.label)
      .fontSize(14)
      .fontColor($r('app.color.black'))
  }

  build() {
    Row({ space: 8 }) {
      // 文本
      this.customLabel()
      Blank()
      Text(this.value)
        .fontSize(14)
        .fontColor($r('app.color.gray'))
      // 图标
      this.customIcon()
    }
    .width('100%')
    .constraintSize({ minHeight: 50 })
    .border({ width: { bottom: this.hasBorder ? 1 : 0 }, color: $r('app.color.under') })
  }

}


@Component
export struct MkCellGroup {
  @BuilderParam default: () => void = this.defaultBuilder

  @Builder
  defaultBuilder() {

  }

  build() {
    Column() {
      // 子组件放置的位置
      this.default()
    }
    .border({
      width: { top: 0.6, bottom: 0.6 },
      color: $r('app.color.under')
    })
    .padding({ left: 16, right: 16 })
    .backgroundColor($r('app.color.white'))
  }
}