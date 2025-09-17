package ${projectMetadata.groupId}.web.service;

import cn.hutool.crypto.digest.BCrypt;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.RequiredArgsConstructor;
import ${projectMetadata.groupId}.common.core.constant.Constants;
import ${projectMetadata.groupId}.common.core.constant.GlobalConstants;
import ${projectMetadata.groupId}.common.core.domain.model.RegisterBody;
import ${projectMetadata.groupId}.common.core.enums.UserType;
import ${projectMetadata.groupId}.common.core.exception.user.CaptchaException;
import ${projectMetadata.groupId}.common.core.exception.user.CaptchaExpireException;
import ${projectMetadata.groupId}.common.core.exception.user.UserException;
import ${projectMetadata.groupId}.common.core.utils.MessageUtils;
import ${projectMetadata.groupId}.common.core.utils.ServletUtils;
import ${projectMetadata.groupId}.common.core.utils.SpringUtils;
import ${projectMetadata.groupId}.common.core.utils.StringUtils;
import ${projectMetadata.groupId}.common.log.event.LogininforEvent;
import ${projectMetadata.groupId}.common.redis.utils.RedisUtils;
import ${projectMetadata.groupId}.common.tenant.helper.TenantHelper;
import ${projectMetadata.groupId}.common.web.config.properties.CaptchaProperties;
import ${projectMetadata.groupId}.system.domain.SysUser;
import ${projectMetadata.groupId}.system.domain.bo.SysUserBo;
import ${projectMetadata.groupId}.system.mapper.SysUserMapper;
import ${projectMetadata.groupId}.system.service.ISysUserService;
import org.springframework.stereotype.Service;

/**
 * 注册校验方法
 *
 * @author ${projectMetadata.author!"Lion Li"}
 */
@RequiredArgsConstructor
@Service
public class SysRegisterService {

    private final ISysUserService userService;
    private final SysUserMapper userMapper;
    private final CaptchaProperties captchaProperties;

    /**
     * 注册
     */
    public void register(RegisterBody registerBody) {
        String tenantId = registerBody.getTenantId();
        String username = registerBody.getUsername();
        String password = registerBody.getPassword();
        // 校验用户类型是否存在
        String userType = UserType.getUserType(registerBody.getUserType()).getUserType();

        boolean captchaEnabled = captchaProperties.getEnable();
        // 验证码开关
        if (captchaEnabled) {
            validateCaptcha(tenantId, username, registerBody.getCode(), registerBody.getUuid());
        }
        SysUserBo sysUser = new SysUserBo();
        sysUser.setUserName(username);
        sysUser.setNickName(username);
        sysUser.setPassword(BCrypt.hashpw(password));
        sysUser.setUserType(userType);

        boolean exist = TenantHelper.dynamic(tenantId, () -> {
            return userMapper.exists(new LambdaQueryWrapper<SysUser>()
                .eq(SysUser::getUserName, sysUser.getUserName()));
        });
        if (exist) {
            throw new UserException("user.register.save.error", username);
        }
        boolean regFlag = userService.registerUser(sysUser, tenantId);
        if (!regFlag) {
            throw new UserException("user.register.error");
        }
        recordLogininfor(tenantId, username, Constants.REGISTER, MessageUtils.message("user.register.success"));
    }

    /**
     * 校验验证码
     *
     * @param username 用户名
     * @param code     验证码
     * @param uuid     唯一标识
     */
    public void validateCaptcha(String tenantId, String username, String code, String uuid) {
        String verifyKey = GlobalConstants.CAPTCHA_CODE_KEY + StringUtils.blankToDefault(uuid, "");
        String captcha = RedisUtils.getCacheObject(verifyKey);
        RedisUtils.deleteObject(verifyKey);
        if (captcha == null) {
            recordLogininfor(tenantId, username, Constants.LOGIN_FAIL, MessageUtils.message("user.jcaptcha.expire"));
            throw new CaptchaExpireException();
        }
        if (!code.equalsIgnoreCase(captcha)) {
            recordLogininfor(tenantId, username, Constants.LOGIN_FAIL, MessageUtils.message("user.jcaptcha.error"));
            throw new CaptchaException();
        }
    }

    /**
     * 记录登录信息
     *
     * @param tenantId 租户ID
     * @param username 用户名
     * @param status   状态
     * @param message  消息内容
     * @return
     */
    private void recordLogininfor(String tenantId, String username, String status, String message) {
        LogininforEvent logininforEvent = new LogininforEvent();
        logininforEvent.setTenantId(tenantId);
        logininforEvent.setUsername(username);
        logininforEvent.setStatus(status);
        logininforEvent.setMessage(message);
        logininforEvent.setRequest(ServletUtils.getRequest());
        SpringUtils.context().publishEvent(logininforEvent);
    }

}
