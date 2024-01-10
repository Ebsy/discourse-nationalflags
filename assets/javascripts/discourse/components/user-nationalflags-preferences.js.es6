import { default as computed, on } from 'discourse-common/utils/decorators';
import Component from "@ember/component";

export default Component.extend({
  layoutName: 'javascripts/discourse/templates/connectors/user-custom-preferences/user-nationalflags-preferences',

  @computed('model.custom_fields.nationalflag_iso')
  flagsource() {
    return  (this.get('model.custom_fields.nationalflag_iso')==null) ? 'none' : this.get('model.custom_fields.nationalflag_iso')
  }
});
