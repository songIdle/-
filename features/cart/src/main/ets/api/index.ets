import { RequestAxios } from 'basic'

import { CreateOrderParams, CreateOrderResult, PreOrder } from '../viewmodel'

// 订单-获取结算信息
export const getOrderPreApi = () => {
  return RequestAxios.get<PreOrder>('/member/order/pre')
}

// 订单管理-新增订单
export const createOrderApi = (data: CreateOrderParams) => {
  return RequestAxios.post<CreateOrderResult>('/member/order', data)
}