import {h} from 'virtual-dom';
import {withPluginApi} from 'discourse/lib/plugin-api';
import {ajax} from 'discourse/lib/ajax';

// import Ember from 'ember';

function initializeNationalFlags(api, siteSettings) {
  const nationalflagsEnabled = siteSettings.nationalflag_enabled;

  if (!nationalflagsEnabled) {
    return;
  }

  api.decorateWidget('poster-name:after', dec => {
    let result = 'none';

    if (dec.attrs && dec.attrs.userCustomFields && dec.attrs.userCustomFields.nationalflag_iso) {
      result = dec.attrs.userCustomFields.nationalflag_iso;
      // Ember.Logger.debug(result)
    }

    if (!result || result === 'none') {
      // Ember.Logger.debug('NOT FOUND!')
      return;
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
