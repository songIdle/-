@Entry
@Component
struct TestPage {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      List({space:5}){
        ForEach(Array.from({length:9}),(item:number,index)=>{
          ListItem()
            .backgroundColor(Color.Red)
            .width(20)
            .height(20)
        })
      }.alignRules({
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End }
      })
      .listDirection(Axis.Horizontal)
      .width(this.getWidth(9))
      .height(20)
      .id('list4')
      .margin({top:100})


      List({space:5}){
        ForEach(Array.from({length:4}),(item:number,index)=>{
          ListItem()
            .backgroundColor(Color.Red)
            .width(20)
            .height(20)
        })
      }.alignRules({
        left: { anchor: 'list4', align: HorizontalAlign.Start },
        bottom:{ anchor: 'list4', align: VerticalAlign.Top },
      })
      .listDirection(Axis.Horizontal)
      .width(this.getWidth(4))
      .height(20)
      .id('list2')
      .margin({bottom:5})

      List({space:5}){
        ForEach(Array.from({length:4}),(item:number,index)=>{
          ListItem()
            .backgroundColor(Color.Red)
            .width(20)
            .height(20)
        })
      }.alignRules({
        right: { anchor: 'list4', align: HorizontalAlign.End },
        bottom:{ anchor: 'list4', align: VerticalAlign.Top },
      })
      .listDirection(Axis.Horizontal)
      .width(this.getWidth(4))
      .height(20)
      .id('list3')
      .margin({bottom:5})

      List({space:5}){
        ForEach(Array.from({length:2}),(item:number,index)=>{
          ListItem()
            .backgroundColor(Color.Red)
            .width(20)
            .height(20)
        })
      }.alignRules({
        right: { anchor: 'list2', align: HorizontalAlign.End },
        left: { anchor: 'list2', align: HorizontalAlign.Start },
        bottom:{ anchor: 'list2', align: VerticalAlign.Top },
      })
      .listDirection(Axis.Horizontal)
      .width(this.getWidth(2))
      .height(20)
      .id('list0')
      .margin({bottom:5})

      List({space:5}){
        ForEach(Array.from({length:2}),(item:number,index)=>{
          ListItem()
            .backgroundColor(Color.Red)
            .width(20)
            .height(20)
        })
      }.alignRules({
        right: { anchor: 'list3', align: HorizontalAlign.End },
        left: { anchor: 'list3', align: HorizontalAlign.Start },
        bottom:{ anchor: 'list3', align: VerticalAlign.Top },
      })
      .listDirection(Axis.Horizontal)
      .width(this.getWidth(2))
      .height(20)
      .id('list1')
      .margin({bottom:5})


      List({space:5}){
        ForEach(Array.from({length:9}),(item:number,index)=>{
          ListItem()
            .backgroundColor(Color.Red)
            .width(20)
            .height(20)
        })
      }.alignRules({
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End },
        top:{ anchor: 'list4',align:VerticalAlign.Bottom }
      })
      .listDirection(Axis.Horizontal)
      .width(this.getWidth(9))
      .height(20)
      .margin({ top:5 })
      .id('list5')

      List({space:5}){
        ForEach(Array.from({length:7}),(item:number,index)=>{
          ListItem()
            .backgroundColor(Color.Red)
            .width(20)
            .height(20)
        })
      }.alignRules({
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End },
        top:{ anchor: 'list5',align:VerticalAlign.Bottom }
      })
      .listDirection(Axis.Horizontal)
      .width(this.getWidth(7))
      .height(20)
      .margin({ top:5 })
      .id('list6')

      List({space:5}){
        ForEach(Array.from({length:5}),(item:number,index)=>{
          ListItem()
            .backgroundColor(Color.Red)
            .width(20)
            .height(20)
        })
      }.alignRules({
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End },
        top:{ anchor: 'list6',align:VerticalAlign.Bottom }
      })
      .listDirection(Axis.Horizontal)
      .width(this.getWidth(5))
      .height(20)
      .margin({ top:5 })
      .id('list7')

      List({space:5}){
        ForEach(Array.from({length:3}),(item:number,index)=>{
          ListItem()
            .backgroundColor(Color.Red)
            .width(20)
            .height(20)
        })
      }.alignRules({
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End },
        top:{ anchor: 'list7',align:VerticalAlign.Bottom }
      })
      .listDirection(Axis.Horizontal)
      .width(this.getWidth(3))
      .height(20)
      .margin({ top:5 })
      .id('list8')

      List({space:5}){
        ForEach(Array.from({length:1}),(item:number,index)=>{
          ListItem()
            .backgroundColor(Color.Red)
            .width(20)
            .height(20)
        })
      }.alignRules({
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End },
        top:{ anchor: 'list8',align:VerticalAlign.Bottom }
      })
      .listDirection(Axis.Horizontal)
      .width(20)
      .height(20)
      .margin({ top:5 })
      .id('list9')
    }
    .height('100%')
    .width('100%')
    .backgroundColor(Color.Pink)
  }


  getWidth(index:number){
    return index*20+(index-1)*5
  }
}