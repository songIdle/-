import { RequestAxios } from 'basic'

import { PreOrder } from '../viewmodel'

// 订单-获取结算信息
export const getOrderPreApi = () => {
  return RequestAxios.get<PreOrder>('/member/order/pre')
}