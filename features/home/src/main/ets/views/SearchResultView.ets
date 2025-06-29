import { GoodsItemsDataSource, MkGoods, MkGoodsItem, MKPullToRefresh } from 'basic'
import { searchGoodsApi } from '../api'

import { GoodsItems } from '../viewmodel'
import { promptAction } from '@kit.ArkUI'

// 联合类型
export type SortField = 'publishTime' | 'orderNum' | 'price'

export type SortMethod = 'desc' | 'asc'

// 提交给服务器的参数
export interface SearchParams {
  keyword: string
  sortField: SortField
  sortMethod: SortMethod
  page: number
  pageSize: number
}

// 搜索结果
export interface SearchResult {
  pageData: GoodsItems;
}

// 筛选条件
export interface SortCompAttr {
  field: SortField
  label: string
}


// 路由参数
interface RouterParam {
  keyword: string
}

@Builder
function SearchResultViewBuilder() {
  // 2. 准备组件 NavDestination
  NavDestination() {
    SearchResultView()
  }
  .hideTitleBar(true) // 隐藏默认标题栏
}

@Component
export struct SearchResultView {
  @Consume pageStack: NavPathStack
  // 顶部安全区域
  @StorageProp('safeTop') safeTop: number = 0
  // mock 数据
  @State data: GoodsItemsDataSource<MkGoodsItem> = new GoodsItemsDataSource<MkGoodsItem>()
  // 查询参数
  @State
  @Watch('paramsChange')
  params: SearchParams =
    {
      keyword: '',
      sortField: 'publishTime',
      sortMethod: 'desc',
      page: 1,
      pageSize: 10
    }
  // 筛选条件
  sortList: SortCompAttr[] = [
    { label: '时间', field: 'publishTime' },
    { label: '销量', field: 'orderNum' },
    { label: '价格', field: 'price' }
  ]
  // 控制器
  scroller = new Scroller()
  // 保存总页数，用于分页判断
  totalPage: number = 0

  aboutToAppear(): void {
    this.params.keyword = this.pageStack.getParamByName('SearchResultView')[0] as string
    this.queryData()
  }

  paramsChange() {

  }

  async queryData() {
    // 清空原数组
    this.data.reloadData([])
    // 重置页码
    this.params.page = 1
    const res = await searchGoodsApi(this.params)
    // Logger.info(res.data.result.pageData.items)
    this.data.pushDatas(res.data.result.pageData.items)
    // 保存总页数，用于分页判断
    this.totalPage = res.data.result.pageData.pages
  }
  // 加载更多数据
  async loadMore() {
    // 如果当前页码小于总页数
    if (this.params.page < this.totalPage) {
      // 页码增加
      this.params.page++
      // 发送请求
      const res = await searchGoodsApi(this.params)
      // 追加数据
      this.data.pushDatas(res.data.result.pageData.items)
    } else {
      promptAction.showToast({ message: '没有更多数据啦～' })
    }
  }

  build() {
    Column() {
      // 搜索区域
      Row() {
        Image($r('[basic].media.ic_public_left'))
          .width(24)
          .aspectRatio(1)
          .fillColor($r('[basic].color.white'))
          .margin(13)
          .onClick(() => {
            this.pageStack.pop()
          })
        Search({ placeholder: '商品关键字...', value: this.params.keyword })
          .searchIcon({ src: $r('[basic].media.ic_public_search'), color: $r('[basic].color.gray') })
          .placeholderColor($r('[basic].color.gray'))
          .placeholderFont({ size: 14 })
          .backgroundColor($r('[basic].color.white'))
          .textFont({ size: 14 })
          .layoutWeight(1)
          .padding(0)
          .margin(0)
          .height(36)
          .caretStyle({ color: $r('[basic].color.red') })
          .onSubmit((value) => {
            this.params.keyword = value
            this.queryData()
          })
      }
      .padding({ top: this.safeTop, right: 16 })
      .linearGradient({
        angle: 135,
        colors: [[$r('[basic].color.linear_begin'), 0], [$r('[basic].color.linear_end'), 1]]
      })

      // list
      Row() {
        ForEach(this.sortList, (item: SortCompAttr) => {
          // 筛选组件
          SortItemComp({
            label: item.label,
            field: item.field,
            sortField: this.params.sortField,
            sortMethod: this.params.sortMethod,
            onCLickItem: (sortField: SortField, sortMethod: SortMethod) => {
              this.params.sortField = sortField
              this.params.sortMethod = sortMethod
              this.queryData()
            }
          })
        })
        Text('筛选')
          .fontSize(14)
          .fontColor($r('[basic].color.gray'))
      }
      .padding({ left: 16, right: 16 })
      .height(50)
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .border({ width: { bottom: 0.5 }, color: $r('[basic].color.border') })

      MKPullToRefresh({
        data: $data,
        scroller: this.scroller,
        customList: () => {
          this.getWaterFlowView()
        },
        // 可选项，下拉刷新回调
        onRefresh: async () => {
          await this.queryData()
          return '刷新成功'
        },
        // 上拉加载更多回调
        onLoadMore: async () => {
          this.loadMore()
          return '上拉加载'
        }
      })
        .layoutWeight(1) // 占满主轴剩余空间
    }
  }
  // 通过重构把 WaterFlow 变成 @Builder
  @Builder
  getWaterFlowView() {
    WaterFlow({ scroller: this.scroller }) {
      LazyForEach(this.data, (item: MkGoodsItem) => {
        FlowItem() {
          MkGoods({ goods: item, smallImage: true })
        }
      })
    }
    .columnsTemplate("1fr 1fr")
    .columnsGap(0.5)
    .rowsGap(0.5)
    .layoutWeight(1) // 占满主轴剩余空间
  }
}

@Component
struct SortItemComp {
  // 筛选字段
  field: SortField = 'publishTime'
  // 显示的文本
  label: string = ''
  // 状态变量，接收父组件的状态属性
  // 父组件的筛选字段
  @Prop sortField: SortField = 'publishTime'
  // 父组件的排序方法
  @Prop sortMethod: SortMethod = 'desc'

  // TODO 点击筛选条件，回传  sortField 和 sortMethod 给父组件（回调函数）
  onCLickItem: (sortField: SortField, sortMethod: SortMethod) => void = () => { }

  build() {
    Row() {
      Text(this.label)
        .fontWeight(500)
        .fontSize(14)
        .fontColor(this.sortField === this.field ? $r('[basic].color.black') : $r('[basic].color.gray'))
      Column() {
        Image($r('[basic].media.ic_public_up'))
          .width(15)
          .height(6)
          .fillColor(this.sortField === this.field && this.sortMethod === 'asc' ? $r('[basic].color.black') :
          $r('[basic].color.gray'))
        Image($r('[basic].media.ic_public_down'))
          .width(15)
          .height(6)
          .fillColor(this.sortField === this.field && this.sortMethod === 'desc' ? $r('[basic].color.black') :
          $r('[basic].color.gray'))
      }
      .justifyContent(FlexAlign.Center)
    }
    .onClick(() => {
      if (this.field === this.sortField) {
        this.onCLickItem(this.field, this.sortMethod === 'desc' ? 'asc' : 'desc')
      } else {
        this.onCLickItem(this.field, 'desc')
      }
    })
  }
}