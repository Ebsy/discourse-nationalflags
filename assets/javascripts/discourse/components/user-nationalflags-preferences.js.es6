import 'discourse/models/store'
import { computed } from "@ember/object";

export default Ember.Component.extend({
  layoutName: 'javascripts/discourse/templates/connectors/user-custom-preferences/user-nationalflags-preferences',

  @computed('model.custom_fields.nationalflag_iso')
  get flagsource() {
    return  (this.get('model.custom_fields.nationalflag_iso')==null) ? 'none' : this.get('model.custom_fields.nationalflag_iso')
  }
});
