import { Logger } from '../../../../Index'
import { auth } from '../utils/Auth'
import { RequestAxios } from '../utils/Request'
import { CartGoods } from '../viewmodel'

interface AddParams {
  skuId: string
  count: number
}
interface CountResult {
  count: number
}

interface UpdateParams {
  selected?: boolean
  count?: string
}

class Cart {
  CartKey: string = 'cartCount'
  // 添加
  add(data: AddParams) {
    return RequestAxios.post<null>('/member/cart', data)
  }

  // 获取购物车数量
  async count() {
    let count = 0
    // 用户已登录才发请求获取
    const userInfo = auth.getUser()
    if (userInfo.token) {
      // 获取购物车数量
      const res = await RequestAxios.get<CountResult>('/member/cart/count')
      // 更新变量，用于全局存储
      count = res.data.result.count
    }
    // 全局存储购物车数量
    AppStorage.setOrCreate(this.CartKey, count)
  }

  // 获取列表
  async list() {
    return RequestAxios.get<CartGoods[]>('/member/cart')
  }

  // 修改
  async update(skuId: string, data: UpdateParams){
    return RequestAxios.put<CartGoods>(`/member/cart/${skuId}`, data)
  }
}

export const cart = new Cart()