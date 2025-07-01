// 地址
export interface AddressItem {
  address: string
  contact: string
  fullLocation: string
  id: string
  isDefault: 0 | 1
  receiver: string
  provinceCode: number
  cityCode: number
  countyCode: number
}

// 订单
export interface OrderGoodsItem {
  attrsText: string;
  count: number;
  id: string;
  name: string;
  payPrice: string;
  picture: string;
  price: string;
  skuId: string;
  totalPayPrice: string;
  totalPrice: string;
}

// 摘要
export interface Summary {
  discountPrice: number;
  goodsCount: number;
  postFee: number;
  totalPayPrice: number;
  totalPrice: number;
}

// 结算信息
export interface PreOrder {
  goods: OrderGoodsItem[]
  userAddresses: AddressItem[]
  summary: Summary
}

// 创建订单商品信息
export interface CreateOrderParamsGoods {
  skuId: string
  count: number
}

// 生成订单参数
export interface CreateOrderParams {
  deliveryTimeType: number
  payType: number
  buyerMessage: string
  payChannel: number
  goods: CreateOrderParamsGoods[]
  addressId: string
}

// 创建订单结果
export interface CreateOrderResult {
  id: string
}

// 订单
export interface OrderItem {
  countdown: number;
  createTime: string;
  id: string;
  orderState: 1 | 2 | 3 | 4 | 5 | 6;
  payChannel: number;
  payLatestTime: string;
  payMoney: number;
  payType: number;
  postFee: number;
  skus: OrderSku[];
  totalMoney: number;
  totalNum: number;
}

// 订单 sku
export interface OrderSku {
  attrsText: string;
  curPrice: number;
  id: string;
  image: string;
  name: string;
  properties: Property[];
  quantity: number;
  realPay: number;
  spuId: string;
}

// 属性
export interface Property {
  propertyMainName: string;
  propertyValueName: string;
}