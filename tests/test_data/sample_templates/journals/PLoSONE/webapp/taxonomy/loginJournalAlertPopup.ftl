<div class="top-header">
  <span class="heading">Save this journal alert</span>
</div>

<div class="body-wrapper">
  <div class="check-box"><strong>Log in to create a weekly email alert for:</strong>
    ${category!""}
  </div>
  <div class="button-wrapper">
    <input type="button" class="primary" id="btn-login-alert" onclick="window.location.href='${freemarker_config.context}/user/secure/secureRedirect.action?goTo=${global.thisPage}'" value="Log In"/>
    <input type="button" class="primary" id="btn-create-alert" onclick="window.location.href='${freemarker_config.registrationURL}'" value="Create Account"/>
    <input type="button" class="btn-cancel-alert" value="Cancel"/>
  </div>
</div>