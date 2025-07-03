export interface OrderItem {
  countdown: number;
  createTime: string;
  id: string;

  // 1为待付款、2为待发货、3为待收货、4为待评价、5为已完成、6为已取消，未传该参数或0为全部
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

export interface Property {
  propertyMainName: string;
  propertyValueName: string;
}

export interface GetOrderParams {
  page: number
  pageSize: number
  orderState: number
}

export interface GetOrderResult {
  counts: number
  pageSize: number
  pages: number
  page: number
  items: OrderItem[]
}