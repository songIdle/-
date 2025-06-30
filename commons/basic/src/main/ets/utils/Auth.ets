import { cart } from "../api/cart"

export interface MkUser {
  token: string
  nickname: string
  avatar: string
  account: string
}

class Auth {
  KEY: string = 'user'

  initUser(){
    PersistentStorage.persistProp(this.KEY, { });
  }
  // 取信息
  getUser() {
    return AppStorage.get<MkUser>(this.KEY) || {} as MkUser
  }

  // 存信息
  saveUser(user: MkUser) {
    AppStorage.setOrCreate<MkUser>(this.KEY, user)
    cart.count()
  }

  // 删信息
  removeUser() {
    AppStorage.setOrCreate<MkUser>(this.KEY, {} as MkUser)
    cart.count()
  }
}

// 导出实例化对象
export const auth = new Auth()