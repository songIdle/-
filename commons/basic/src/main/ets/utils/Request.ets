import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { auth } from './Auth'
import { Logger } from './Logger'
import { promptAction } from '@kit.ArkUI'
import { MKNavPathStack } from './MKNavPathStack'

// 实例化 通用配置
export const axiosInstance = axios.create({
  baseURL: 'https://meikou-api.itheima.net/',
  timeout: 20000
})

axiosInstance.interceptors.response.use((response: AxiosResponse) => {
  return Promise.resolve(response)
})

// 后端返回的数据格式 code, msg, result
interface HttpResponse<T> {
  code: string
  msg: string
  result: T
}

// 添加请求拦截器 request.use
axiosInstance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  // 获取用户信息
  const user = auth.getUser()
  // 是否有 token 信息
  if (user.token) {
    // 添加 token 信息到请求头中
    // Authorization  和  Bearer token  都是后端定的规范
    config.headers.Authorization = `Bearer ${user.token}`
  }
  return config;
}, (error: AxiosError) => {
  // 对请求错误做些什么
  return Promise.reject(error);
});

// 添加响应拦截器 response.use
axiosInstance.interceptors.response.use((response: AxiosResponse) => {
  // 对响应数据做点什么
  return response;
}, (error: AxiosError) => {
  Logger.error(error,'===std')
  // 对响应错误做点什么
  if (error.response?.status === 401) {
    // 401 一般是 token 信息错误
    promptAction.showToast({ message: '登录信息已过期，请重新登录' })
    // 清除用户信息
    auth.removeUser()
    // 跳转到登录页
    MKNavPathStack.pushPath({ name: 'LoginView' })
  }
  return Promise.reject(error);
});


// AxiosResponse 是 axios 响应类型
export type ResponseType<T> = AxiosResponse<HttpResponse<T>>

export class RequestAxios {
  static get<T>(url: string, params?: object): Promise<ResponseType<T>> {
    return axiosInstance.get<null, ResponseType<T>>(url, { params })
  }

  static post<T>(url: string, data?: object): Promise<ResponseType<T>> {
    return axiosInstance.post<null, ResponseType<T>>(url, data)
  }

  static delete<T>(url: string, obj?: object): Promise<ResponseType<T>> {
    return axiosInstance.delete<null, ResponseType<T>, Object>(url, { data: obj })
  }

  static put<T>(url: string, data?: object): Promise<ResponseType<T>> {
    return axiosInstance.put<null, ResponseType<T>>(url, data)
  }
}
