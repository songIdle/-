import { CategoryItem, MkGoodsItem, RequestAxios } from "basic"
import { Banner, HotResult } from "../viewmodel"
import { SearchParams, SearchResult } from "../views/SearchResultView"

export const getBannerApi = () => {
  return RequestAxios.get<Banner[]>('/home/banner')
}
export const getCategoryApi = () => {
  return RequestAxios.get<CategoryItem[]>('/home/category/head')
}

// 首页-特惠推荐
export const getHotPreferenceApi = () => {
  return RequestAxios.get<HotResult>('/hot/preference')
}

// 首页-爆款推荐
export const getHotInVogueApi = () => {
  return RequestAxios.get<HotResult>('/hot/inVogue')
}

// 首页-一站买全
export const getHotOneStopApi = () => {
  return RequestAxios.get<HotResult>('/hot/oneStop')
}

export const getNewApi = () => {
  return RequestAxios.get<MkGoodsItem[]>('/home/new')
}

export const getRecommendApi = (limit: number = 10) => {
  return RequestAxios.get<MkGoodsItem[]>('/home/recommend', new Object({ limit }))
}

// 其他略
export const searchGoodsApi = (data: SearchParams) => {
  return RequestAxios.post<SearchResult>('/search/all', data)
}