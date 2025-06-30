import { authentication } from '@kit.AccountKit'

class HuaweiAuthPlugin {
  // 代替了用户输入用户名密码
  async requestAuth() {
    // 1. 创建一个Account Kit授权请求对象，可通过返回值设置请求参数。
    const huaweiIdProvider = new authentication.HuaweiIDProvider()
    const authCreateRequest = huaweiIdProvider.createAuthorizationWithHuaweiIDRequest() // 创建华为授权请求
    // 2. 添加请求参数
    authCreateRequest.scopes = ['phone']
    authCreateRequest.permissions = ['serviceauthcode']
    authCreateRequest.forceAuthorization = true
    // 3. 执行授权请求，获取认证码
    const authController = new authentication.AuthenticationController(getContext())
    const authResponse: authentication.AuthorizationWithHuaweiIDResponse =
      await authController.executeRequest(authCreateRequest) // 执行授权请求
    const authorizationCode = authResponse.data?.authorizationCode // 华为授权code码(有了它 有了用户信息)
    return authorizationCode
  }

  // getHuaweiIDState  api12 支持

  async cancelAuth() {
    try {
      // 1. 创建一个Account Kit授权请求对象，可通过返回值设置请求参数。
      const huaweiIdProvider = new authentication.HuaweiIDProvider()
      const authCancelRequest = huaweiIdProvider.createCancelAuthorizationRequest()
      // 2. 取消授权
      const authController = new authentication.AuthenticationController(getContext())
      await authController.executeRequest(authCancelRequest)
      return true
    } catch (e) {
      console.log('mk-logger', JSON.stringify(e))
      return false
    }
  }
}

export const huaweiAuthPlugin = new HuaweiAuthPlugin()