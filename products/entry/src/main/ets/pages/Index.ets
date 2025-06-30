import { BreakpointConstants, EmitterEvent, Logger, MKNavPathStack } from 'basic';
import { CartView } from 'cart';
import { CategoryView } from 'category';
import { HomeView } from 'home';
import { MyView } from 'my';
import { emitter } from '@kit.BasicServicesKit';

interface TabItem {
  text: string
  normal: ResourceStr
  active: ResourceStr
}

@Entry
@Component
struct Index {
  @Provide pageStack: NavPathStack = MKNavPathStack
  @StorageProp('currentBreakpoint') breakPoint: string = 'xs'
  @StorageProp('safeBottom') safeBottom: number = 0
  @State activeIndex: number = 0
  list: TabItem[] = [
    { text: '首页', normal: $r('app.media.ic_public_home_normal'), active: $r('app.media.ic_public_home_active') },
    { text: '分类', normal: $r('app.media.ic_public_pro_normal'), active: $r('app.media.ic_public_pro_active') },
    { text: '购物袋', normal: $r('app.media.ic_public_cart_normal'), active: $r('app.media.ic_public_cart_active') },
    { text: '我的', normal: $r('app.media.ic_public_my_normal'), active: $r('app.media.ic_public_my_active') },
  ]
  aboutToAppear(): void {
    emitter.on(EmitterEvent.JUMP_TO_HOME, () => {
      this.activeIndex = 0
    })
  }
  aboutToDisappear(): void {
    // 移除监听
    emitter.off(EmitterEvent.JUMP_TO_HOME)
  }

  build() {
    Navigation(this.pageStack) {
      Tabs({ barPosition: BarPosition.End ,index:this.activeIndex}) {
        ForEach(this.list, (item: TabItem, index: number) => {
          TabContent() {
            if (index === 0) {
              HomeView()
            } else if (index === 1) {
              CategoryView()
            } else if (index === 2) {
              CartView()
            } else if (index === 3) {
              MyView()
            }
          }
          .tabBar(this.TabItemBuilder(item, index))
        })
      }
      .barPosition(this.breakPoint == BreakpointConstants.LG ? BarPosition.Start : BarPosition.End)
      .vertical(this.breakPoint == BreakpointConstants.LG ? true : false)
      .scrollable(false)
      .onTabBarClick(index => {
        this.activeIndex = index
      })
      .margin({ bottom: this.safeBottom })
    }
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
  }

  @Builder
  TabItemBuilder(item: TabItem, index: number) {
    Column() {
      Image(this.activeIndex === index ? item.active : item.normal)
        .width(24)
        .aspectRatio(1)
      Text(item.text)
      // 跨 HSP 访问资源，需要在 oh-package.json5中导入
        .fontColor($r('[basic].color.black'))
        .fontSize(12)
    }
    .justifyContent(FlexAlign.SpaceEvenly)
    .height(50)
  }
}