import { RequestAxios, MkUser } from 'basic'

interface LoginData {
  account: string
  password: string
}

export const LoginApi = (data: LoginData) => {
  return RequestAxios.post<MkUser>('/login', data)
}