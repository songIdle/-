import { RequestAxios, MkUser, AddressItem } from 'basic'

interface LoginData {
  account: string
  password: string
}

export const LoginApi = (data: LoginData) => {
  return RequestAxios.post<MkUser>('/login', data)
}

// 华为登录 提交的信息
interface Data {
  code: string
  clientId: string
  clientSecret: string
}

export const clientId = '111423245'
export const clientSecret = '17752e55714da611536862790c6cd911ffb614e86fabb15456c3fba820be428e'

export const huaweiLoginAPI = (code: string) => {
  const data: Data = {
    clientId,
    clientSecret,
    code
  }
  return RequestAxios.post<MkUser>('/login/huawei', data)
}

// 获取地址
export const getAddressApi = () => {
  return RequestAxios.get<AddressItem[]>('/member/address')
}

// 其他略
export interface RequestType {
  address: string;
  contact: string;
  isDefault: 0 | 1; // 0 默认 1 非默认
  receiver: string;
}

// 新增地址
export const createAddressAPI = (data: RequestType) => {
  return RequestAxios.post<null>('/member/address', data)
}

// 更新地址-设置为默认地址
export const setDefaultAddressAPI = (id: string) => {
  return RequestAxios.put<null>(`/member/address/${id}`, new Object({ isDefault: 0 }))
}

// 删除地址
export const delAddressAPI = (id: string) => {
  return RequestAxios.delete<null>(`/member/address/${id}`)
}

// 修改地址
export const editAddressAPI = (id: string, data: RequestType) => {
  return RequestAxios.put<null>(`/member/address/${id}`, data)
}