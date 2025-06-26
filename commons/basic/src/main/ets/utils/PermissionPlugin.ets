import { abilityAccessCtrl, bundleManager, Permissions } from '@kit.AbilityKit'

class PermissionPlugin {
  // 检查单个权限
  checkAccessToken(permission: Permissions) {
    try {
      const atManager = abilityAccessCtrl.createAtManager();
      const bundleInfo =
        bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
      const accessTokenId = bundleInfo.appInfo.accessTokenId
      const grantStatus = atManager.checkAccessTokenSync(accessTokenId, permission);
      return grantStatus;
    } catch (e) {
      return abilityAccessCtrl.GrantStatus.PERMISSION_DENIED
    }
  }

  // 检查多个权限
  async checkPermissions(permissions: Permissions[]) {
    for (let permission of permissions) {
      const grantStatus = this.checkAccessToken(permission)
      if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
        return false
      }
    }
    return true
  }

  // 首次向用户申请授权
  async requestPermissions(permissions: Permissions[]) {
    const atManager = abilityAccessCtrl.createAtManager();
    const res = await atManager.requestPermissionsFromUser(getContext(), permissions) // 首次
    const isAuth = res.authResults.every(item => item === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
    return isAuth ? Promise.resolve() : Promise.reject()
  }

  // 二次向用户申请授权
  async requestPermissionOnSetting(permissions: Permissions[]) {
    const atManager = abilityAccessCtrl.createAtManager();
    const grantStatus = await atManager.requestPermissionOnSetting(getContext(), permissions) // 二次
    const isAuth = grantStatus.every(item => item === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
    return isAuth ? Promise.resolve() : Promise.reject()
  }
}

// 暴露实例对象
export const permissionPlugin = new PermissionPlugin()