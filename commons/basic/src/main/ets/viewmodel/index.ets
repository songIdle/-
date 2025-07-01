export interface MkGoodsItem {
  id: string
  name: string
  desc: string
  price: string
  picture: ResourceStr
  orderNum: number
}
export interface CategoryItem {
  children?: CategoryItemChild[]
  goods?: MkGoodsItem[]
  id: string
  name: string
  picture: ResourceStr
}

export interface CategoryItemChild {
  id: string
  name: string
  picture: ResourceStr
}

export *  from  './DataSource'

// 其他略
export interface GoodsItems {
  counts: number;
  items: MkGoodsItem[];
  page: number;
  pages: number;
  pageSize: number;
}

// 购物车
export interface CartGoods {
  count: number;
  id: string;
  name: string;
  picture: string;
  price: number;
  selected: boolean;
  skuId: string;
  stock: number;
  attrsText: string;
}

@Observed
export class CartGoodsModel implements CartGoods {
  count: number = 0
  id: string = ''
  name: string = ''
  picture: string = ''
  price: number = 0
  selected: boolean = false
  skuId: string = ''
  stock: number = 0
  attrsText: string = ''

  constructor(model: CartGoods) {
    this.count = model.count
    this.id = model.id
    this.name = model.name
    this.picture = model.picture
    this.price = model.price
    this.selected = model.selected
    this.skuId = model.skuId
    this.stock = model.stock
    this.attrsText = model.attrsText
  }
}

export interface AddressItem {
  address: string // 详细地址
  contact: string // 联系电话
  fullLocation: string
  id: string
  isDefault: 0 | 1 //是否默认 0默认
  receiver: string // 收货人
  provinceCode: number
  cityCode: number
  countyCode: number
}