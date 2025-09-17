package ${projectMetadata.groupId}.web.service.impl;

import cn.dev33.satoken.stp.StpUtil;
import cn.dev33.satoken.stp.parameter.SaLoginParameter;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.crypto.digest.BCrypt;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import ${projectMetadata.groupId}.common.core.constant.Constants;
import ${projectMetadata.groupId}.common.core.constant.GlobalConstants;
import ${projectMetadata.groupId}.common.core.constant.SystemConstants;
import ${projectMetadata.groupId}.common.core.domain.model.LoginUser;
import ${projectMetadata.groupId}.common.core.domain.model.PasswordLoginBody;
import ${projectMetadata.groupId}.common.core.enums.LoginType;
import ${projectMetadata.groupId}.common.core.exception.user.CaptchaException;
import ${projectMetadata.groupId}.common.core.exception.user.CaptchaExpireException;
import ${projectMetadata.groupId}.common.core.exception.user.UserException;
import ${projectMetadata.groupId}.common.core.utils.MessageUtils;
import ${projectMetadata.groupId}.common.core.utils.StringUtils;
import ${projectMetadata.groupId}.common.core.utils.ValidatorUtils;
import ${projectMetadata.groupId}.common.json.utils.JsonUtils;
import ${projectMetadata.groupId}.common.redis.utils.RedisUtils;
import ${projectMetadata.groupId}.common.satoken.utils.LoginHelper;
import ${projectMetadata.groupId}.common.tenant.helper.TenantHelper;
import ${projectMetadata.groupId}.common.web.config.properties.CaptchaProperties;
import ${projectMetadata.groupId}.system.domain.SysUser;
import ${projectMetadata.groupId}.system.domain.vo.SysClientVo;
import ${projectMetadata.groupId}.system.domain.vo.SysUserVo;
import ${projectMetadata.groupId}.system.mapper.SysUserMapper;
import ${projectMetadata.groupId}.web.domain.vo.LoginVo;
import ${projectMetadata.groupId}.web.service.IAuthStrategy;
import ${projectMetadata.groupId}.web.service.SysLoginService;
import org.springframework.stereotype.Service;

/**
 * 密码认证策略
 *
 * @author ${projectMetadata.author!"Michelle.Chung"}
 */
@Slf4j
@Service("password" + IAuthStrategy.BASE_NAME)
@RequiredArgsConstructor
public class PasswordAuthStrategy implements IAuthStrategy {

    private final CaptchaProperties captchaProperties;
    private final SysLoginService loginService;
    private final SysUserMapper userMapper;

    @Override
    public LoginVo login(String body, SysClientVo client) {
        PasswordLoginBody loginBody = JsonUtils.parseObject(body, PasswordLoginBody.class);
        ValidatorUtils.validate(loginBody);
        String tenantId = loginBody.getTenantId();
        String username = loginBody.getUsername();
        String password = loginBody.getPassword();
        String code = loginBody.getCode();
        String uuid = loginBody.getUuid();

        boolean captchaEnabled = captchaProperties.getEnable();
        // 验证码开关
        if (captchaEnabled) {
            validateCaptcha(tenantId, username, code, uuid);
        }
        LoginUser loginUser = TenantHelper.dynamic(tenantId, () -> {
            SysUserVo user = loadUserByUsername(username);
            loginService.checkLogin(LoginType.PASSWORD, tenantId, username, () -> !BCrypt.checkpw(password, user.getPassword()));
            // 此处可根据登录用户的数据不同 自行创建 loginUser
            return loginService.buildLoginUser(user);
        });
        loginUser.setClientKey(client.getClientKey());
        loginUser.setDeviceType(client.getDeviceType());
        SaLoginParameter model = new SaLoginParameter();
        model.setDeviceType(client.getDeviceType());
        // 自定义分配 不同用户体系 不同 token 授权时间 不设置默认走全局 yml 配置
        // 例如: 后台用户30分钟过期 app用户1天过期
        model.setTimeout(client.getTimeout());
        model.setActiveTimeout(client.getActiveTimeout());
        model.setExtra(LoginHelper.CLIENT_KEY, client.getClientId());
        // 生成token
        LoginHelper.login(loginUser, model);

        LoginVo loginVo = new LoginVo();
        loginVo.setAccessToken(StpUtil.getTokenValue());
        loginVo.setExpireIn(StpUtil.getTokenTimeout());
        loginVo.setClientId(client.getClientId());
        return loginVo;
    }

    /**
     * 校验验证码
     *
     * @param username 用户名
     * @param code     验证码
     * @param uuid     唯一标识
     */
    private void validateCaptcha(String tenantId, String username, String code, String uuid) {
        String verifyKey = GlobalConstants.CAPTCHA_CODE_KEY + StringUtils.blankToDefault(uuid, "");
        String captcha = RedisUtils.getCacheObject(verifyKey);
        RedisUtils.deleteObject(verifyKey);
        if (captcha == null) {
            loginService.recordLogininfor(tenantId, username, Constants.LOGIN_FAIL, MessageUtils.message("user.jcaptcha.expire"));
            throw new CaptchaExpireException();
        }
        if (!code.equalsIgnoreCase(captcha)) {
            loginService.recordLogininfor(tenantId, username, Constants.LOGIN_FAIL, MessageUtils.message("user.jcaptcha.error"));
            throw new CaptchaException();
        }
    }

    private SysUserVo loadUserByUsername(String username) {
        SysUserVo user = userMapper.selectVoOne(new LambdaQueryWrapper<SysUser>().eq(SysUser::getUserName, username));
        if (ObjectUtil.isNull(user)) {
            log.info("登录用户：{} 不存在.", username);
            throw new UserException("user.not.exists", username);
        } else if (SystemConstants.DISABLE.equals(user.getStatus())) {
            log.info("登录用户：{} 已被停用.", username);
            throw new UserException("user.blocked", username);
        }
        return user;
    }

}
