import { RequestAxios, MkUser } from 'basic'

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