import { BreakpointConstants, BreakPointType, CategoryItem, CategoryItemChild, MkNavbar } from 'basic'

@Component
export struct CategoryView {
  @Consume pageStack: NavPathStack
  @StorageProp(BreakpointConstants.BREAK_POINT_KEY) currentBreakpoint: string = BreakpointConstants.SM
  // 滚动控制器
  scroller: Scroller = new Scroller()
  //  Mock分类数据
  @StorageProp('categoryData')
  categories: CategoryItem[] = new Array(10).fill({
    id: "1181622001",
    name: "气质女装",
    picture: "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/c1/qznz.png"
  })
  @State activeIndex: number = 0

  @Builder
  NavBuilder(){
    Column(){
      Text('分类')
    }.justifyContent(FlexAlign.Center)
    .layoutWeight(1)


  }
  build() {
    Column() {
      // 自定义导航栏组件
      MkNavbar({
        title: '商品分类', // 标题
        showLeftIcon: false, // 隐藏左侧按钮
        showRightIcon: true, // 显示右侧按钮
        rightIcon: $r('[basic].media.ic_public_search'), // 右侧图标为搜索
        rightClickHandler: () => { // 点击右侧图标回调
          this.pageStack.pushPathByName('SearchView', null)
        },
        customBuilder: this.NavBuilder
      })

      Row() {
        Column() {
          ForEach(this.categories, (item: CategoryItem, i) => {
            Text(item.name)// 文本
              .backgroundColor(this.activeIndex === i ? $r('[basic].color.black') : $r('[basic].color.white'))
              .fontSize(14)
              .fontColor(this.activeIndex === i ? $r('[basic].color.white') : $r('[basic].color.black'))
              .textAlign(TextAlign.Center)
              .width('100%')
              .height(56)
              .onClick(() => {
                this.activeIndex = i
                // 切换菜单时，滚动到顶部
                this.scroller.scrollTo({ yOffset: 0, xOffset: 0, animation: true })
              })

          })
        }
        .width(88)
        .border({ width: { right: 0.5 }, color: $r('[basic].color.under') })

        Scroll(this.scroller) {
          Column() {
            // 顶部图片
            Image(this.categories[this.activeIndex]?.picture)
              .width('100%')
              .height(
                new BreakPointType({
                  'sm': 136,
                  'md': 200,
                  'lg': 220,
                }).getValue(this.currentBreakpoint)
              )
              .objectFit(ImageFit.Contain)
              .backgroundColor('#f6f6f6')
              .borderRadius(8)
              .margin({ bottom: 8 })
            GridRow({
              columns: {
                sm: 2,
                md: 3,
                lg: 4,
              },
              gutter: 8
            }){
              // 子分类
              ForEach(this.categories[this.activeIndex]?.children, (sub: CategoryItemChild) => {
                GridCol() {
                  Column() {
                    // 图片
                    Image(sub.picture)
                      .width(64)
                      .aspectRatio(1)
                    Text(sub.name)// 文本
                      .fontSize(14)
                      .fontColor($r('[basic].color.text'))
                      .margin({ top: 8 })
                  }
                  .height('100%')
                  .justifyContent(FlexAlign.Center)
                }
                .aspectRatio(1)
                .backgroundColor('#f6f6f6')
                .borderRadius(8)
              })
            }
          }
          .padding(8)
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
      }
      .layoutWeight(1)
      .alignItems(VerticalAlign.Top)
    }
    .width('100%')
    .height('100%')
  }
}