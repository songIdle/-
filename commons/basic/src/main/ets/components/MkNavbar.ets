@Component
export struct MkNavbar {
  // 顶部安全区域
  @StorageProp('safeTop') safeTop: number = 0
  @Prop title: string =''
  @Prop leftIcon: ResourceStr = $r('app.media.ic_public_left')
  @Prop rightIcon: ResourceStr= $r('app.media.ic_public_more')
  @Prop showLeftIcon: boolean = true
  @Prop showRightIcon: boolean = false
  @Prop color: ResourceColor =$r('app.color.black')
  @Prop bg: ResourceColor =$r('app.color.white')
  leftClickHandler:()=>void=()=>{}
  rightClickHandler:()=>void=()=>{}

  @BuilderParam
  customBuilder:()=>void=this.defaultTitle


  @Builder
  defaultTitle() {
    Text(this.title)
      .fontSize(16)
      .fontWeight(500)
      .layoutWeight(1)
      .textAlign(TextAlign.Center)
      .fontColor(this.color)
  }

  build() {
    Row() {
      Row() {
        if (this.showLeftIcon) {
          Image(this.leftIcon)
            .width(24)
            .aspectRatio(1)
            .fillColor(this.color)
            .onClick(() => {
              this.leftClickHandler()
            })
        }

      }
      .width(50)
      .aspectRatio(1)
      .justifyContent(FlexAlign.Center)

      // Text('导航标题')
      //   .fontSize(16)
      //   .fontWeight(500)
      //   .layoutWeight(1)
      //   .textAlign(TextAlign.Center)
      //   .fontColor($r('app.color.black'))
      this.customBuilder()
      Row() {
        if (this.showRightIcon) {
          Image(this.rightIcon)
            .width(24)
            .aspectRatio(1)
            .fillColor(this.color)
            .onClick(() => {
              this.rightClickHandler()
            })
        }
      }
      .width(50)
      .aspectRatio(1)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height(50 + this.safeTop)
    .backgroundColor(this.bg)
    .padding({ top: this.safeTop })
  }
}