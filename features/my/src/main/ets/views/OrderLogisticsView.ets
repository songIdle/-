import { map, mapCommon, MapComponent, navi } from '@kit.MapKit';
import { router } from '@kit.ArkUI';
import { AsyncCallback } from '@kit.BasicServicesKit';
import { Logger, MKNavPathStack, permissionPlugin } from 'basic';

@Builder
function OrderLogisticsViewBuilder() {
  OrderLogisticsView()
}


@Component
export struct OrderLogisticsView {
  @StorageProp('safeTop') safeTop: number = 0
  @StorageProp('safeBottom') safeBottom: number = 0
  @State loading: boolean = false
  @Consume pageStack: NavPathStack
  list: LogisticsItem[] = [
    {
      stateText: '运输中',
      detail: '您的订单已达到廊坊【美蔻北方仓库】',
      time: '昨天 16:34',
    },
    {
      stateText: '',
      detail: '您的订单已经离开天津武清分拣中心，前往美蔻北方仓库',
      time: '2024-06-09 12:34',
    },
    {
      stateText: '',
      detail: '您的订单由美蔻【天津武清分拣中心】准备送往【美蔻北方仓库】',
      time: '2024-06-09 10:21',
    },
    {
      stateText: '',
      detail: '您的订单由美蔻【天津武清分拣中心】分拣完成',
      time: '2024-06-09 08:10',
    },
    {
      stateText: '仓库处理中',
      detail: '打包完成',
      time: '2024-06-09 06:10',
    },
    {
      stateText: '',
      detail: '扫描完成',
      time: '2024-06-09 05:50',
    },
    {
      stateText: '',
      detail: '拣货完成',
      time: '2024-06-09 05:40',
    },
    {
      stateText: '',
      detail: '您的订单已打印完成',
      time: '2024-06-09 05:30',
    },
    {
      stateText: '已下单',
      detail: '温馨提示：您的订单预计6月10日09:00-15:00送达',
      time: '2024-06-09 06:10',
    },
  ]

  //地图配置项
  private mapOptions?: mapCommon.MapOptions;
  private callback?:AsyncCallback<map.MapComponentController>;
  private mapController?:map.MapComponentController;

  //初始化配置

  //获取上个页面参数
  aboutToAppear(): void {
    permissionPlugin.requestPermissions(["ohos.permission.LOCATION"])
    const order_id = this.pageStack.getParamByName('OrderLogisticsView').pop() as string
    Logger.info(order_id, '订单id')
    this.mapOptions = {
      position: {
        target: {
          latitude: 31.984410,
          longitude: 118.7662537
        },
        zoom: 10
      }
    }
    this.callback = async (err, mapController) => {
      if (!err) {
        // 获取地图的控制器类，用来操作地图
        this.mapController = mapController;
        // 返回地图组件的监听事件管理接口
        let polylineOption: mapCommon.MapPolylineOptions = {
          // 折线坐标点，必传
          points: [{
            latitude: 31.984410,
            longitude: 118.7662537
          }, {
            latitude: 31.084410,
            longitude: 118.0662537
          }],
          clickable: true,
          color: 0xff000000,
          startCap: mapCommon.CapStyle.BUTT,
          endCap: mapCommon.CapStyle.BUTT,
          geodesic: false,
          jointType: mapCommon.JointType.DEFAULT,
          visible: true,
          width: 10,
          zIndex: 0,
          gradient: false
        };
        // 在地图上添加一条折线
        let mapPolyline: map.MapPolyline = await this.mapController.addPolyline(polylineOption);
      }
    };
  }



  build() {
    NavDestination() {
      Column() {
        Stack({ alignContent: Alignment.TopStart }) {
          if (!this.loading) {

            MapComponent({ mapOptions: this.mapOptions, mapCallback: this.callback })
              .width('100%')
              .height('100%')
          }
          Row() {
            Image($r('[basic].media.ic_public_left'))
              .width(24)
              .aspectRatio(1)
              .fillColor($r('[basic].color.text'))
          }
          .justifyContent(FlexAlign.Center)
          .width(40)
          .aspectRatio(1)
          .borderRadius(20)
          .backgroundColor($r('[basic].color.white'))
          .margin({ top: this.safeTop + 5, left: 16 })
          .onClick(() => {
            this.pageStack.pop()
          })
        }
        .width('100%')
        .aspectRatio(1.2)

        Row({ space: 8 }) {
          Text('申通快递')
            .fontSize(12)
          Text('ST439742843428')
            .fontSize(12)
            .fontColor($r('[basic].color.gray'))
          Blank()
          Text('预计明天送达')
            .fontSize(12)
            .fontColor($r('[basic].color.gray'))
        }
        .padding({ left: 16, right: 16 })
        .height(40)
        .width('100%')
        .border({ width: { bottom: 0.5 }, color: $r('[basic].color.border') })

        List() {
          ForEach(this.list, (item: LogisticsItem, i) => {
            ListItem() {
              LogisticsItemComp({
                isActive: i === 0,
                isEnd: i === (this.list.length - 1),
                stateText: item.stateText,
                detail: item.detail,
                time: item.time
              })
            }
            .padding({ top: i === 0 ? 16 : 0 })
          })

        }
        .layoutWeight(1)
        .width('100%')
        .scrollBar(BarState.Off)
      }
    }
    .hideTitleBar(true)

  }
}


interface LogisticsItem {
  stateText: string
  detail: string
  time: string
}

@Component
struct LogisticsItemComp {
  stateText: string = ''
  detail: string = ''
  time: string = ''
  isActive: boolean = false
  isEnd: boolean = false

  build() {
    Row() {
      // indicator
      if (!this.isActive) {
        Row() {
        }
        .width(10)
        .height(10)
        .borderRadius(5)
        .backgroundColor('#E9E8EC')
        .position({ y: 6, x: -5 })
      } else {
        Row() {
          Image($r('[basic].media.ic_public_check'))
            .width(16)
            .aspectRatio(1)
            .fillColor($r('[basic].color.white'))
        }
        .justifyContent(FlexAlign.Center)
        .width(24)
        .aspectRatio(1)
        .backgroundColor($r('[basic].color.red'))
        .borderRadius(12)
        .position({ y: 0, x: -12 })
        .zIndex(1)
      }
      Row() {
      }
      .width(2)
      .height(this.isEnd ? 16 : '100%')
      .backgroundColor('#E9E8EC')
      .position({ y: 0, x: -1 })

      // info
      Column({ space: 6 }) {
        if (this.stateText) {
          Text(this.stateText)
            .fontSize(16)
            .fontWeight(500)
            .lineHeight(22)
            .fontColor(this.isActive ? $r('[basic].color.red') : $r('[basic].color.gray'))
        }
        Text(this.detail)
          .fontSize(14)
          .fontColor($r('[basic].color.text'))
        Text(this.time)
          .fontSize(12)
          .fontColor($r('[basic].color.gray'))
      }
      .alignItems(HorizontalAlign.Start)
      .width('100%')
      .padding({ left: 20, bottom: 20 })
    }
    .width('100%')
    .padding({ left: 27, right: 16 })
    .clip(true)
  }
}