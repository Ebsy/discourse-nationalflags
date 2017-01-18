import {h} from 'virtual-dom';
import {withPluginApi} from 'discourse/lib/plugin-api';
import {ajax} from 'discourse/lib/ajax'

function initializeNationalFlags(api, siteSettings) {
  const nationalflagsEnabled = siteSettings.nationalflag_enabled;

  if (!nationalflagsEnabled) {
    return;
  }

  api.decorateWidget('poster-name:after', dec => {
    console.log(dec)
    let result = '';

    if (dec.attrs && dec.attrs.hasOwnProperty('userCustomFields')) {
      if (!dec.attrs.userCustomFields.hasOwnProperty('nationalflag_iso')) {
        result = dec.attrs.userCustomFields.nationalflag_iso;
      } else {
        result = 'none'
      }
    } else {
      result = 'none'
    }

    return dec.h('img', {
      className: "nationalflag-post",
      attributes: {
        src: "/plugins/discourse-nationalflags/images/nationalflags/" + result + ".png"
      }
    });
  });
}

export default {
  name : 'nationalflag',
  initialize(container) {
    const siteSettings = container.lookup('site-settings:main');
    withPluginApi('0.1', api => initializeNationalFlags(api, siteSettings));
  }
};
