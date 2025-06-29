import { GoodsItems } from '../viewmodel'
import { RequestAxios } from '../utils/Request'

// 默认值为 6
export const getGuessLikeApi = () => {
  return RequestAxios.get<GoodsItems>('/home/goods/guessLike')
}